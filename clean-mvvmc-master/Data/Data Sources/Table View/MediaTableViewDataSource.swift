//
//  MediaTableViewDataSource.swift
//  clean-mvvmc-master
//
//  Created by Developer on 22/10/2023.
//

import UIKit

final class MediaTableViewDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    weak var tableView: UITableView?
    
    var viewModel: HomeViewModel
    
    
    init(_ tableView: UITableView, with viewModel: HomeViewModel) {
        self.tableView = tableView
        self.viewModel = viewModel
    }
    
    
    func dataSourceDidChange() {
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return .init()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return .init()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

// MARK: - Index Type

extension MediaTableViewDataSource {
    
    /// Section index representation type.
    enum Index: Int, CaseIterable {
        case display
        case newRelease
        case resumable
        case action
        case rated
        case sciFi
        case myList
        case blockbuster
        case crime
        case thriller
        case adventure
        case comedy
        case drama
        case horror
        case anime
        case familyNchildren
        case documentary
    }
}

// MARK: - State Type

extension MediaTableViewDataSource {
    
    /// Section state representation type.
    enum State: Int, CaseIterable {
        case all
        case tvShows
        case movies
    }
}
