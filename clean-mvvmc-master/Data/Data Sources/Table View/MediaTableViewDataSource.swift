//
//  MediaTableViewDataSource.swift
//  clean-mvvmc-master
//
//  Created by Developer on 22/10/2023.
//

import UIKit

final class MediaTableViewDataSource: NSObject, TableViewDataSource {
    
    weak var tableView: UITableView?
    
    var viewModel: HomeViewModel
    
    
    init(_ tableView: UITableView, with viewModel: T) {
        self.tableView = tableView
        self.viewModel = viewModel
    }
    
    
    func dataSourceDidChange() {
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return .zero
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return .init()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}
