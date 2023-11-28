//
//  UITableViewCell.swift
//  clean-mvvmc-master
//
//  Created by Developer on 25/10/2023.
//

import UIKit

@objc
protocol UITableViewCellInteracting {
    @objc optional func cellDidTap()
    @objc optional func cellDidLongPress(_ gesture: UILongPressGestureRecognizer)
}

extension UITableViewCell: ViewInstantiable,
                           PathIndexable,
                           UITableViewCellInteracting {
    
    static func create<T, U>(in tableView: UITableView,
                             for indexPath: IndexPath,
                             with viewModel: U) -> T where T: UITableViewCell, U: ViewModel {
        
        tableView.register(Self.nib, forCellReuseIdentifier: Self.reuseIdentifier)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.reuseIdentifier, for: indexPath) as? T else {
            fatalError()
        }
        
        switch (cell, viewModel) {
            
        case (let cell as ProfileSettingTableViewCell, let viewModel as ProfileViewModel):
            
            let model = viewModel.settings[indexPath.section]
            let cellViewModel = ProfileSettingTableViewCellViewModel(with: model)
            
            cell.indexPath = indexPath
            cell.viewModel = viewModel
            cell.cellViewModel = cellViewModel
            cell.deploySubviews()
            
        case (let cell as DisplayTableViewCell, let viewModel as HomeViewModel):
            
            let state = viewModel.dataSourceState.value
            let model = viewModel.displayMedia[state]
            let cellViewModel = DisplayTableViewCellViewModel(with: model ?? .vacantValue)
            
            cell.viewModel = cellViewModel
            cell.deploySubviews()
            
        case (let cell as SkeletonDisplayTableViewCell, _ as HomeViewModel):
            
            cell.deploySubviews()
            
        default:
            fatalError()
        }
        
        return cell
    }
}
