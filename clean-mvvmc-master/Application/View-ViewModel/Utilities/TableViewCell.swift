//
//  TableViewCell.swift
//  clean-mvvmc-master
//
//  Created by Developer on 25/10/2023.
//

import UIKit

protocol TableViewCell: UITableViewCell, ViewInstantiable, PathIndexable {
    
    func cellDidTap()
    func cellDidLongPress(_ gesture: UILongPressGestureRecognizer)
}


extension TableViewCell {
    
    static func create<T, U>(
        in tableView: UITableView,
        for indexPath: IndexPath,
        with viewModel: U) -> T where T: TableViewCell, U: ViewModel {
            
            tableView.register(T.nib, forCellReuseIdentifier: T.reuseIdentifier)
            
            guard let cell: T = tableView.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
                fatalError()
            }
            
            switch (cell, viewModel) {
                
            case (let cell as ProfileSettingTableViewCell,
                  let viewModel as ProfileViewModel):
                
                let model = viewModel.settings[indexPath.section]
                let cellViewModel = ProfileSettingTableViewCellViewModel(with: model)
                
                cell.indexPath = indexPath
                cell.viewModel = viewModel
                cell.cellViewModel = cellViewModel
                cell.deploySubviews()
                
                return cell as! T
                
            default:
                fatalError()
            }
        }
}
