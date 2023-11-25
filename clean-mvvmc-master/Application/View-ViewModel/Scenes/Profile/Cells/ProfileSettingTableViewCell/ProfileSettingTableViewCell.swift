//
//  ProfileSettingTableViewCell.swift
//  clean-mvvmc-master
//
//  Created by Developer on 25/10/2023.
//

import UIKit

final class ProfileSettingTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var symbolImageView: UIImageView!
    @IBOutlet private weak var headerTitleLabel: UILabel!
    @IBOutlet private weak var optionLabel: UILabel!
    
    var viewModel: ProfileViewModel?
    var cellViewModel: ProfileSettingTableViewCellViewModel?
    var indexPath: IndexPath?
    
    func deploySubviews() {
        configureSubviews()
        targetSubviews()
    }
    
    func configureSubviews() {
        configureLayer()
        configureImageView()
        configureLabels()
        configureAccessoryView()
    }
    
    func targetSubviews() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellDidTap)))
    }
}

extension ProfileSettingTableViewCell {
    
    enum Section: Int {
        case maturityRating
        case displayLanguage
        case audioAndSubtitles
        case autoplayNextEpisode
        case autoplayPreviews
    }
    
    enum CellType {
        case selectable
        case switchable
    }
}

extension ProfileSettingTableViewCell {
    
    @objc
    func switchValueDidChange(_ sender: UISwitch) {
        guard let section = ProfileSettingTableViewCell.Section(rawValue: sender.tag) else {
            return
        }
        
        switch section {
        case .autoplayNextEpisode:
            viewModel?.editingProfile?.settings?.autoplayNextEpisode = sender.isOn
            
        case .autoplayPreviews:
            viewModel?.editingProfile?.settings?.autoplayPreviews = sender.isOn
            
        default:
            break
        }
        
        hasChanges()
    }
    
    @objc
    func cellDidTap() {
        guard let section = ProfileSettingTableViewCell.Section(rawValue: indexPath?.section ?? .zero) else {
            return
        }
        
        switch section {
        case .maturityRating, .displayLanguage, .audioAndSubtitles:
            
            viewModel?.coordinator?.coordinate(to: .editSetting)
            
        default:
            return
        }
    }
    
    func cellDidLongPress(_ gesture: UILongPressGestureRecognizer) {
    }
}

extension ProfileSettingTableViewCell {
    
    private func configureLayer() {
        layer.cornerRadius = 4.0
    }
    
    private func configureImageView() {
        let image = UIImage(systemName: cellViewModel?.image ?? "")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        
        symbolImageView.image = image
    }
    
    private func configureLabels() {
        let headerTitle = cellViewModel?.title ?? ""
        
        headerTitleLabel.text = headerTitle
        
        let optionSubtitle = cellViewModel?.subtitle ?? ""
        
        optionLabel.text = optionSubtitle
        optionLabel.isHidden = cellViewModel?.type == .switchable
    }
    
    private func configureAccessoryView() {
        let chevron = UIImage(systemName: "chevron.right")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: chevron)
        let uiSwitch = UISwitch()
        
        uiSwitch.tag = indexPath?.section ?? .zero
        uiSwitch.onTintColor = UIColor.hexColor("#2c6ad3")
        uiSwitch.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        
        let section = ProfileSettingTableViewCell.Section(rawValue: indexPath?.section ?? .zero)
        
        switch section {
        case .autoplayNextEpisode:
            uiSwitch.isOn = viewModel?.editingProfile?.settings?.autoplayNextEpisode ?? true
            
        case .autoplayPreviews:
            uiSwitch.isOn = viewModel?.editingProfile?.settings?.autoplayPreviews ?? true
            
        default:
            break
        }
        
        accessoryView = cellViewModel?.type == .switchable ? uiSwitch : imageView
    }
    
    private func hasChanges() {
        guard let editingProfile = viewModel?.editingProfile,
              let editingProfileIndex = viewModel?.editingProfileIndex else {
            return
        }
        
        viewModel?.hasChanges.value = editingProfile != viewModel?.profiles.value[editingProfileIndex]
    }
}
