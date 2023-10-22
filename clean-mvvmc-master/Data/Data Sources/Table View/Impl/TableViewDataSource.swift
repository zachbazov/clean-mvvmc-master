//
//  TableViewDataSource.swift
//  clean-mvvmc-master
//
//  Created by Developer on 22/10/2023.
//

import UIKit

protocol TableViewDataSource: UITableViewDelegate, UITableViewDataSource {
    
    associatedtype T
    
    var viewModel: T { get }
    
    var tableView: UITableView? { get }
    
    init(_ tableView: UITableView, with viewModel: T)
    
    func dataSourceDidChange()
}
