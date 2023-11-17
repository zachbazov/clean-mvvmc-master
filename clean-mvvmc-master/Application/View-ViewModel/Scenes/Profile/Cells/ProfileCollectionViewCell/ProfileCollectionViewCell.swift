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
    
    private var activityIndicator: ActivityIndicatorView?
    
    private var snapshot: UIView?
    
    
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
                        
                        self.animateCell()
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
    
    private func animateCell() {
        
        var authService = Application.app.server.authService
        
        guard var user = authService.user,
              let indexPath = indexPath,
              let profile = viewModel?.profiles.value[indexPath.row] else {
            return
        }
        
        viewModel?.setEditingProfile(profile)
        
        user.setSelectedProfile(profile)
        
        authService.user = user
        
        guard let profileController = viewModel?.coordinator?.viewController else {
            return
        }
        
        profileController.collectionView.isHidden = true
        
        titleLabel.isHidden = true
        
        let centerPoint = CGPoint(x: profileController.view.center.x,
                                  y: profileController.view.center.y - bounds.height - 48)
        
        cellViewModel?.centerPoint = centerPoint
        
        let cellFrameInCollectionView = profileController.collectionView.convert(frame, to: profileController.view)
        
        snapshot = snapshotView(afterScreenUpdates: true)
        
        guard let snapshot = snapshot else {
            return
        }
        
        snapshot.frame = cellFrameInCollectionView
        
        profileController.view.addSubview(snapshot)
        
        UIView.animate(withDuration: 0.5, animations: {
            
            profileController.navigationController?.navigationBar.alpha = .zero
            
            snapshot.center = centerPoint
            
        }) { [weak self] _ in
            guard let self = self else {
                return
            }
            
            createActivityIndicatorView()
            
            sendRequests()
        }
    }
    
    private func createActivityIndicatorView() {
        
        activityIndicator = ActivityIndicatorView(frame: CGRect(x: .zero, y: .zero, width: 48, height: 48))
        
        guard let activityIndicator = activityIndicator else {
            return
        }
        
        activityIndicator.center = snapshot?.center ?? .zero
        activityIndicator.center.y += 96.0
        
        viewModel?.coordinator?.viewController?.view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
    private func sendRequests() {
        
        let authService = Application.app.server.authService
        
        guard let user = authService.user else {
            return
        }
        
        let sectionRequest = HTTPSectionDTO.Request()
        let mediaRequest = HTTPMediaDTO.Request()
        let userRequest = HTTPUserDTO.Request(user: user.toDTO())
        
        let sectionUseCase = SectionUseCase()
        let mediaUseCase = MediaUseCase()
        let userUseCase = UserUseCase()
        
        let sectionResponseStore = SectionResponseStore()
        let mediaResponseStore = SectionResponseStore()
        
        if #available(iOS 13.0.0, *) {
            
            Task {
                
                let _: HTTPSectionDTO.Response? = await sectionUseCase.request(endpoint: .find, request: sectionRequest)
                
                let _: HTTPMediaDTO.Response? = await mediaUseCase.request(endpoint: .find, request: mediaRequest)
                
                if let _: HTTPUserDTO.Response? = await userUseCase.request(endpoint: .update, request: userRequest) {
                    
                    updateUserResponseStorage(user.toDTO())
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                        guard let self = self else {
                            return
                        }
                        
                        UIView.animate(withDuration: 0.5, delay: .zero, animations: {
                            
                            self.activityIndicator?.alpha = .zero
                            
                        }) { _ in
                            
                            self.activityIndicator?.stopAnimating()
                            self.activityIndicator?.removeFromSuperview()
                            
                            UIView.animate(withDuration: 2.0,
                                           delay: .zero,
                                           usingSpringWithDamping: 1.0,
                                           initialSpringVelocity: 1.0,
                                           options: []) {
                                
                                self.animateSnapshot()
                                
                            } completion: { _ in
                                
                                self.cellDidFinishAnimating()
                            }
                        }
                    }
                }
                
            }
            
        } else {
            
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            
            _ = sectionUseCase.repository.find(
                request: sectionRequest,
                cached: { (response: HTTPSectionDTO.Response?) in
                    
                    dispatchGroup.leave()
                },
                completion: { (result: Result<HTTPSectionDTO.Response, DataTransferError>) in
                    
                    switch result {
                    case .success(let response):
                        
                        sectionResponseStore.saver.saveResponse(response)
                        
                    case .failure(let error):
                        print(error)
                    }
                    
                    dispatchGroup.leave()
                })
            
            dispatchGroup.enter()
            
            _ = mediaUseCase.repository.find(
                request: mediaRequest,
                cached: { (response: HTTPMediaDTO.Response?) in
                    
                    dispatchGroup.leave()
                },
                completion: { (result: Result<HTTPMediaDTO.Response, DataTransferError>) in
                    
                    switch result {
                    case .success(let response):
                        
                        mediaResponseStore.saver.saveResponse(response)
                        
                    case .failure(let error):
                        print(error)
                    }
                    
                    dispatchGroup.leave()
                })
            
            dispatchGroup.enter()
            
            _ = userUseCase.request(
                endpoint: .update,
                request: userRequest,
                cached: nil,
                completion: { [weak self] (result: Result<HTTPUserDTO.Response, DataTransferError>) in
                    guard let self = self else {
                        return
                    }
                    
                    switch result {
                    case .success:
                        
                        self.updateUserResponseStorage(user.toDTO())
                         
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            
                            UIView.animate(withDuration: 0.5, delay: .zero, animations: {
                                
                                self.activityIndicator?.alpha = .zero
                                
                            }) { _ in
                                
                                self.activityIndicator?.stopAnimating()
                                self.activityIndicator?.removeFromSuperview()
                                
                                UIView.animate(withDuration: 2.0,
                                               delay: .zero,
                                               usingSpringWithDamping: 1.0,
                                               initialSpringVelocity: 1.0,
                                               options: []) {
                                    
                                    self.animateSnapshot()
                                    
                                } completion: { _ in
                                    
                                    self.cellDidFinishAnimating()
                                    
                                    dispatchGroup.leave()
                                }
                            }
                        }
                        
                    case .failure(let error):
                        print(error)
                    }
                })
        }
    }
    
    private func updateUserResponseStorage(_ user: UserDTO) {
        
        let userResponseStore = AuthResponseStore()
        
        var currentResponse: HTTPUserDTO.Response? = userResponseStore.fetcher.fetchResponse()

        currentResponse?.data = user

        userResponseStore.updater.updateResponse(currentResponse)
    }
    
    private func animateSnapshot() {
        
        guard let snapshot = snapshot,
              let profileCoordinator = viewModel?.coordinator,
              let view = profileCoordinator.navigationController?.view,
              let centerPoint = cellViewModel?.centerPoint else {
            return
        }
        
        snapshot.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        
        let path = UIBezierPath()
        let rect = view.frame
        
        let safeAreaBottomInset: CGFloat = profileCoordinator.navigationController?.view.safeAreaInsets.bottom ?? .zero
        let tabBarHeight: CGFloat = 49.0
        let tabBarMaxY: CGFloat = tabBarHeight + safeAreaBottomInset
        let tabBarItemImageSize: CGFloat = 20.0
        let numberOfTabBarItems: CGFloat = 3.0
        let spacingFromItemTabBarImageMinYToTabBarMinY: CGFloat = 6.0
        let spacingBetweenTabBarItems: CGFloat = 2.0
        
        path.move(to: CGPoint(x: centerPoint.x, y: centerPoint.y))
        
        path.addCurve(to: CGPoint(x: rect.midX, y: rect.midY),
                      controlPoint1: CGPoint(x: rect.midX - tabBarHeight, y: rect.minY + tabBarHeight),
                      controlPoint2: CGPoint(x: rect.minX, y: rect.midY - tabBarHeight))
        
        path.addCurve(to: CGPoint(x: rect.midX + (rect.midX / 2.0) + (tabBarItemImageSize + (spacingBetweenTabBarItems * (numberOfTabBarItems - 1.0))), y: rect.maxY - snapshot.bounds.height - tabBarHeight),
                      controlPoint1: CGPoint(x: rect.maxX - tabBarHeight, y: rect.midY + tabBarHeight),
                      controlPoint2: CGPoint(x: rect.midX + tabBarHeight, y: rect.midY))
        
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.path = path.cgPath
        pathAnimation.duration = 2.0
        
        snapshot.layer.add(pathAnimation, forKey: "pathAnimation")
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        snapshot.layer.position = CGPoint(
            x: rect.maxX - (tabBarItemImageSize * numberOfTabBarItems) - (spacingBetweenTabBarItems * numberOfTabBarItems),
            y: rect.maxY - tabBarMaxY - tabBarHeight - tabBarItemImageSize - spacingFromItemTabBarImageMinYToTabBarMinY)
        
        CATransaction.commit()
    }
    
    private func cellDidFinishAnimating() {
        
        let appCoordinator = Application.app.coordinator
        
        appCoordinator.tabBarCoordinator?.viewController?.view.alpha = .zero
        
        appCoordinator.coordinate(to: appCoordinator.tabBarCoordinator?.viewController)
        
        guard let profile = viewModel?.editingProfile else {
            return
        }
        
        appCoordinator.tabBarCoordinator?.viewController?.viewModel.profile.value = viewModel?.editingProfile
        
        UIView.animate(withDuration: 0.5) {
            
            appCoordinator.profileCoordinator?.navigationController?.view.alpha = .zero
            
            appCoordinator.tabBarCoordinator?.viewController?.view.alpha = 1.0
        }
    }
}
