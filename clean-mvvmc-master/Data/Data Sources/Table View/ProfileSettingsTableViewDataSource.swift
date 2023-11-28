//
//  ProfileSettingsTableViewDataSource.swift
//  clean-mvvmc-master
//
//  Created by Developer on 25/10/2023.
//

import UIKit

final class ProfileSettingsTableViewDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private let viewModel: ProfileViewModel
    
    weak var tableView: UITableView?
    
    init(_ tableView: UITableView, with viewModel: ProfileViewModel?) {
        guard let viewModel = viewModel else {
            fatalError()
        }
        
        self.viewModel = viewModel
        self.tableView = tableView
    }
    
    func dataSourceDidChange() {
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.settings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return ProfileSettingTableViewCell.create(in: tableView, for: indexPath, with: viewModel)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UITableView.UISpacerView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UITableView.UISpacerView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2.0
    }
}
