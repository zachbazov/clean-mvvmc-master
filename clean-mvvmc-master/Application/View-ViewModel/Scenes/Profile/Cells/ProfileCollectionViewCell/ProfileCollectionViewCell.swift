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
            
            for case let cell as ProfileCollectionViewCell in cells {
                
                if indexPath == cell.indexPath {
                    
                    cell.isSelected = true
                    cell.setStroke()
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        cell.button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    }, completion: { [weak self] _ in
                        guard let self = self else {
                            return
                        }
                        
                        UIView.animate(withDuration: 0.2) {
                            
                            cell.button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                            
                            let authService = Application.app.server.authService
                            
                            guard var user = authService.user,
                                  let indexPath = self.indexPath else {
                                return
                            }
                            
                            self.viewModel?.editingProfile = self.viewModel?.profiles.value[indexPath.row]
                            user.selectedProfile = self.viewModel?.editingProfile?._id
                            
//                            let userResponseStore = AuthResponseStore()
//                            var currentResponse: HTTPUserDTO.Response? = userResponseStore.fetcher.fetchResponse()
                            let request = HTTPUserDTO.Request(user: user.toDTO())
//                            currentResponse?.data = user.toDTO()
//                            userResponseStore.deleter.deleteResponse()
//                            userResponseStore.saver.saveResponse(currentResponse)
                            
                            let server = Application.app.server
                            let userUseCase = UserUseCase()
                            let req = HTTPUserDTO.Request(user: authService.user!.toDTO())
                            
                            let sessionTask = URLSessionTask()
                            
                            guard !sessionTask.isCancelled else { return }
                            
                            
                            
                            _ = userUseCase.repository.update(request: request) { (result: Result<HTTPUserDTO.Response, DataTransferError>) in
                                
                                switch result {
                                case .success(let response):
                                    
                                    print(response.message)
                                    
//                                    let appCoordinator = Application.app.coordinator
//                                    let profileCoordinator = self.viewModel?.coordinator
//                                    let tabBarCoordinator = appCoordinator.tabBarCoordinator
//                                    
//                                    DispatchQueue.main.async {
//                                        
//                                        self.viewModel?.coordinator?.viewController?.dismiss(animated: true) {
//                                            appCoordinator.coordinate(to: tabBarCoordinator?.viewController)
//                                        }
//                                    }
                                    
                                case .failure(let error):
                                    print(error)
                                }
                            }
                        }
                    })
                    
                } else {
                    
                    if cell.cellViewModel?.id != "addProfile" {
                        
                        cell.isSelected = false
                        cell.removeStroke()
                    }
                }
            }
        }
    }
    
    @objc
    func cellDidLongPress(_ gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .began, let badge = deleteBadge {
            
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
