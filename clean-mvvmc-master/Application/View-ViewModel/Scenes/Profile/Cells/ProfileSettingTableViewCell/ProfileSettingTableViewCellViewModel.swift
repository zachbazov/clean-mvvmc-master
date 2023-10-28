//
//  ProfileSettingTableViewCellViewModel.swift
//  clean-mvvmc-master
//
//  Created by Developer on 25/10/2023.
//

import Foundation

struct ProfileSettingTableViewCellViewModel {
    
    let type: ProfileSettingTableViewCell.CellType
    let image: String
    let title: String
    var subtitle: String? = nil
    let hasSubtitle: Bool
    let isSwitchable: Bool
    
    
    init(with model: ProfileSetting) {
        self.type = model.isSwitchable ? .switchable : .selectable
        self.image = model.image
        self.title = model.title
        self.subtitle = model.subtitle
        self.hasSubtitle = model.hasSubtitle
        self.isSwitchable = model.isSwitchable
    }
}
