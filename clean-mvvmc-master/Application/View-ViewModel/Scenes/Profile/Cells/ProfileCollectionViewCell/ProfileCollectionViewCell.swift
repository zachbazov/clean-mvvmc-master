//
//  ProfileCollectionViewCell.swift
//  clean-mvvmc-master
//
//  Created by Developer on 22/10/2023.
//

import UIKit

final class ProfileCollectionViewCell: UICollectionViewCell, CollectionViewCell {
    
    @IBOutlet private weak var button: UIButton!
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet private weak var badgeViewContainer: UIView!
    
    @IBOutlet private(set) weak var editOverlayContainer: UIView!
    
    
    var viewModel: ProfileViewModel?
    
    var cellViewModel: ProfileCollectionViewCellViewModel?
    
    var indexPath: IndexPath?
    
    private(set) var editOverlay: OverlayView?
    
    private(set) var deleteBadge: BadgeView?
    
    
    func deploySubviews() {
        createEditOverlayView()
        createBadgeView()
        
        configureSubviews()
        
        targetSubviews()
    }
    
    func configureSubviews() {
        configureButtons()
    }
    
    func targetSubviews() {
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(cellDidLongPress))
        
        addGestureRecognizer(longPressGesture)
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        editOverlay?.removeFromSuperview()
        deleteBadge?.removeFromSuperview()
        
        button.layer.borderColor = nil
        button.layer.borderWidth = .zero
    }
}


extension ProfileCollectionViewCell {
    
    private func setTitleLabel(_ text: String) {
        titleLabel.text = text
    }
    
    private func configureButtons() {
        
        button.layer.cornerRadius = 8.0
        editOverlay?.layer.cornerRadius = 8.0
        
        setTitleLabel(cellViewModel?.name ?? "")
        
        if cellViewModel?.id == "addProfile" {
            
            let pointSize: CGFloat = 40.0
            let configuration = UIImage.SymbolConfiguration(pointSize: pointSize, weight: .thin)
            let image = UIImage(systemName: cellViewModel?.image ?? "")?
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(.hexColor("#CACACA"))
                .withConfiguration(configuration)
            
            button.setImage(image, for: .normal)
            button.layer.borderColor = UIColor.hexColor("#AAAAAA").cgColor
            button.layer.borderWidth = 1.0
            
        } else {
            
            let imageName = cellViewModel?.image ?? ""
            let image = UIImage(named: imageName)
            
            button.setImage(image, for: .normal)
        }
    }
    
    private func createEditOverlayView() {
        
        if cellViewModel?.id != "addProfile" {
            
            editOverlay = OverlayView(type: .edit)
                .addToHierarchy(in: editOverlayContainer)
                .constraint(to: editOverlayContainer)
            
            editOverlay?.delegate = self
        }
    }
    
    private func createBadgeView() {
        
        if cellViewModel?.id != "addProfile" {
            
            deleteBadge = BadgeView(type: .delete)
                .addToHierarchy(in: badgeViewContainer)
                .constraint(to: badgeViewContainer)
            
            deleteBadge?.delegate = self
        }
    }
    
    
    @objc
    func cellDidTap() {
        
        if cellViewModel?.id == "addProfile" {
            
            viewModel?.coordinator?.coordinate(to: .add)
            
        } else {
            
            let cells = viewModel?.coordinator?.viewController?.collectionView?.visibleCells ?? []
            
            for case let cell as ProfileCollectionViewCell in cells where cell.cellViewModel?.id != "addProfile" {
                
                if indexPath == cell.indexPath {
                    
                    cell.isSelected = true
                    cell.setStroke()
                    
                    cell.button.scalingEffect { [weak self] in
                        guard let self = self else {
                            return
                        }
                        
                        self.animateCell(cell)
                    }
                    
                } else {
                    
                    cell.isSelected = false
                    cell.removeStroke()
                }
            }
        }
    }
    
    @objc
    func cellDidLongPress(_ gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .began, let badge = deleteBadge {
            
            button.scalingEffect()
            
            cellViewModel?.isLongPressed.toggle()
            
            badge.delegate?.badge?(badge, shouldBePresented: cellViewModel?.isLongPressed ?? true)
        }
    }
}

extension ProfileCollectionViewCell: OverlayViewDelegate {
    
    func overlay(_ overlay: OverlayView, shouldBePresented presented: Bool) {
        overlay.superview?.isHidden = !presented
    }
    
    @objc
    func overlayDidTap(_ overlay: OverlayView) {
        
        viewModel?.coordinator?.coordinate(to: .edit)
        
        guard let indexPath = indexPath else {
            return
        }
        
        let profile = viewModel?.profiles.value[indexPath.row]
        
        viewModel?.editingProfileIndex = indexPath.row
        
        viewModel?.editingProfile = profile
    }
}


extension ProfileCollectionViewCell: BadgeViewDelegate {
    
    func badge(_ badge: BadgeView, shouldBePresented presented: Bool) {
        badge.superview?.isHidden = !presented
    }
    
    func badgeDidTap(_ badge: BadgeView) {
        
        let authService = Application.app.server.authService
        
        if let _ = gestureRecognizers?.first as? UILongPressGestureRecognizer,
           let badge = deleteBadge {
            
            cellViewModel?.isLongPressed = false
            
            badge.delegate?.badge?(badge, shouldBePresented: cellViewModel?.isLongPressed ?? false)
        }
        
        guard let indexPath = indexPath,
              let user = authService.user else {
            return
        }
        
        let profile = viewModel?.profiles.value[indexPath.row]
        
        let request = HTTPProfileDTO.DELETE.Request(user: user.toDTO(), id: profile?._id ?? "")
        
        viewModel?.deleteProfile(with: request)
    }
}


extension ProfileCollectionViewCell {
    
    func setStroke() {
        button.layer.borderColor = UIColor.hexColor("#ffffff").cgColor
        button.layer.borderWidth = 2.0
    }
    
    func removeStroke() {
        button.layer.borderColor = nil
        button.layer.borderWidth = .zero
    }
}


extension ProfileCollectionViewCell {
    
    private func animateCell(_ cell: ProfileCollectionViewCell) {
        
        let authService = Application.app.server.authService
        
        guard var user = authService.user,
              let indexPath = indexPath,
              let profile = viewModel?.profiles.value[indexPath.row] else {
            return
        }
        
        viewModel?.setEditingProfile(profile)
        
        user.setSelectedProfile(profile)
        
        let request = HTTPUserDTO.Request(user: user.toDTO())
        
        let userUseCase = UserUseCase()
        
        var activityIndicator: ActivityIndicatorView?
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                
                self.viewModel?.coordinator?.viewController?.collectionView.isHidden = true
                
                cell.titleLabel.isHidden = true
                
                let targetPoint = CGPoint(x: self.viewModel?.coordinator?.viewController?.view.center.x ?? .zero, y: (self.viewModel?.coordinator?.viewController?.view.center.y ?? .zero) - cell.bounds.height - 48)
                
                let cellFrameInCollectionView = self.viewModel?.coordinator?.viewController?.collectionView.convert(cell.frame, to: self.viewModel?.coordinator!.viewController!.view)
                
                guard let snapshot = cell.snapshotView(afterScreenUpdates: true) else {
                    return
                }
                
                snapshot.frame = cellFrameInCollectionView ?? .zero
                
                self.viewModel?.coordinator?.viewController?.view.addSubview(snapshot)
                
                UIView.animate(withDuration: 0.5, animations: {
                    
                    snapshot.center = targetPoint
                    
                }) { _ in
                    
                    activityIndicator = ActivityIndicatorView(frame: CGRect(x: .zero, y: .zero, width: 48, height: 48))
                    
                    guard let activityIndicator = activityIndicator else {
                        return
                    }
                    
                    activityIndicator.center = snapshot.center
                    activityIndicator.center.y += 96.0
                    
                    self.viewModel?.coordinator?.viewController?.view.addSubview(activityIndicator)
                    
                    activityIndicator.startAnimating()
                    
                    _ = userUseCase.repository.update(request: request) { (result: Result<HTTPUserDTO.Response, DataTransferError>) in
                        
                        switch result {
                        case .success:
                            
                            self.updateUserResponseStorage(user.toDTO())
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                
                                activityIndicator.stopAnimating()
                                activityIndicator.removeFromSuperview()
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    
                                    UIView.animate(withDuration: 2.0, delay: .zero, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: []) {
                                        
                                        self.animateSnapshot(snapshot, targetingPoint: targetPoint)
                                        
                                    } completion: { _ in
                                        
                                        self.cellDidFinishAnimating()
                                    }
                                }
                            }
                            
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
        }
    }
    
    private func updateUserResponseStorage(_ user: UserDTO) {
        
        let userResponseStore = AuthResponseStore()
        
        var currentResponse: HTTPUserDTO.Response? = userResponseStore.fetcher.fetchResponse()

        currentResponse?.data = user

        userResponseStore.updater.updateResponse(currentResponse)
    }
    
    private func animateSnapshot(_ snapshot: UIView, targetingPoint targetPoint: CGPoint) {
        
        let profileCoordinator = viewModel?.coordinator
        
        snapshot.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        
        let rect = profileCoordinator!.navigationController!.view.frame
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: targetPoint.x, y: targetPoint.y))
        
        path.addCurve(to: CGPoint(x: rect.midX, y: rect.midY),
                      controlPoint1: CGPoint(x: rect.midX - 50, y: rect.minY + 50),
                      controlPoint2: CGPoint(x: rect.minX, y: rect.midY - 50))
        
        path.addCurve(to: CGPoint(x: rect.midX + (rect.midX / 2), y: rect.maxY - snapshot.bounds.height - 48),
                      controlPoint1: CGPoint(x: rect.maxX - 50, y: rect.midY + 50),
                      controlPoint2: CGPoint(x: rect.midX + 50, y: rect.midY))
        
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.path = path.cgPath
        pathAnimation.duration = 2.0
        
        snapshot.layer.add(pathAnimation, forKey: "pathAnimation")
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        snapshot.layer.position = CGPoint(x: rect.midX + (rect.midX / 2), y: (profileCoordinator?.navigationController?.view.bounds.maxY ?? 0) - snapshot.bounds.height - 16.0)
        CATransaction.commit()
    }
    
    private func cellDidFinishAnimating() {
        
        let appCoordinator = Application.app.coordinator
        
        appCoordinator.profileCoordinator?.navigationController?.dismiss(animated: true) {
            
            appCoordinator.tabBarCoordinator?.viewController?.view.alpha = .zero
            
            appCoordinator.coordinate(to: appCoordinator.tabBarCoordinator?.viewController)
            
            UIView.animate(withDuration: 0.5) {
                
                appCoordinator.tabBarCoordinator?.viewController?.view.alpha = 1.0
            }
        }
    }
}




extension UIButton {
    
    func scalingEffect(_ completion: (() -> Void)? = nil) {
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self = self else {
                return
            }
            
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
        }, completion: { [weak self] _ in
            guard let self = self else {
                return
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
            }, completion: { _ in
                
                completion?()
            })
        })
    }
}
