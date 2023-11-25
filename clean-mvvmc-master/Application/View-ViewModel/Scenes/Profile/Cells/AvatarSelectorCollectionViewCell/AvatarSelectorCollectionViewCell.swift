//
//  AvatarSelectorCollectionViewCell.swift
//  clean-mvvmc-master
//
//  Created by Developer on 26/10/2023.
//

import UIKit

final class AvatarSelectorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var button: UIButton!
    
    
    var viewModel: ProfileViewModel?
    
    var cellViewModel: AvatarSelectorCollectionViewCellViewModel?
    
    var indexPath: IndexPath?
    
    
    func deploySubviews() {
        configureSubviews()
    }
    
    func configureSubviews() {
        configureButton()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        isSelected = false
    }
}


extension AvatarSelectorCollectionViewCell {
    
    private func configureButton() {
        
        button.layer.cornerRadius = 8.0
        
        let imageName = cellViewModel?.image ?? ""
        let image = UIImage(named: imageName)
        
        button.setImage(image, for: .normal)
        
        if viewModel?.editingProfile?.image ?? "" == imageName
            || viewModel?.addingAvatar?.image == imageName {
            
            setStroke()
        }
    }
}


extension AvatarSelectorCollectionViewCell {
    
    @objc
    func cellDidTap() {
        
        let cells = viewModel?.coordinator?.avatarSelectorViewController?.collectionView.visibleCells ?? []
        
        for case let cell as AvatarSelectorCollectionViewCell in cells {
            
            if indexPath?.row == cell.indexPath!.row {
                
                cell.isSelected = true
                cell.setStroke()
                
                viewModel?.editingProfile?.image = cell.cellViewModel?.image ?? ""
                
                viewModel?.addingAvatar?.image = cell.cellViewModel?.image ?? ""
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
                    guard let self = self else { return }
                    
                    self.viewModel?.coordinator?.avatarSelectorViewController?.dismiss(animated: true)
                    
                    if let _ = self.viewModel?.coordinator?.editProfileViewController {
                        
                        let imageName = viewModel?.editingProfile?.image ?? ""
                        let image = UIImage(named: imageName)?
                            .withRenderingMode(.alwaysOriginal)
                        
                        self.viewModel?.coordinator?.editProfileViewController?.avatarButton.setImage(image, for: .normal)
                        
                        hasChanges()
                    }
                    
                    if let _ = self.viewModel?.coordinator?.addProfileViewController {
                        
                        let imageName = viewModel?.addingAvatar?.image ?? ""
                        let image = UIImage(named: imageName)?
                            .withRenderingMode(.alwaysOriginal)
                        
                        self.viewModel?.coordinator?.addProfileViewController?.avatarButton.setImage(image, for: .normal)
                    }
                }
                
            } else {
                
                cell.isSelected = false
                cell.removeStroke()
            }
        }
    }
    
    func cellDidLongPress(_ gesture: UILongPressGestureRecognizer) {
    }
}


extension AvatarSelectorCollectionViewCell {
    
    func setStroke() {
        button.layer.borderColor = UIColor.hexColor("#ffffff").cgColor
        button.layer.borderWidth = 2.0
    }
    
    func removeStroke() {
        button.layer.borderColor = nil
        button.layer.borderWidth = .zero
    }
}

extension AvatarSelectorCollectionViewCell {
    
    private func hasChanges() {
        
        guard let editingProfile = viewModel?.editingProfile,
              let editingProfileIndex = viewModel?.editingProfileIndex else {
            return
        }
        
        viewModel?.hasChanges.value = editingProfile != viewModel?.profiles.value[editingProfileIndex]
    }
}
