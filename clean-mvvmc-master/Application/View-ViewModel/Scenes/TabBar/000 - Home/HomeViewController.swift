//
//  HomeViewController.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import UIKit
import CodeBureau

final class HomeViewController: UIViewController, ViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    
    var viewModel: HomeViewModel!
    
    lazy var dataSource: MediaTableViewDataSource? = createDataSource()
    
    
    deinit {
        debugPrint(.debug, "deinit \(Self.self)")
        
        viewDidDeallocate()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDidBindObservers()
        
        viewModel.fetchData()
        
//        removeSelectedProfile()
    }
    
    func viewDidDeploySubviews() {
        
    }
    
    func viewDidBindObservers() {
        
        viewModel.dataSourceState.observe(on: self) { [weak self] state in
            guard let self = self else {
                return
            }
            
            self.dataSource?.dataSourceDidChange()
        }
    }
    
    func viewDidUnbindObservers() {
        
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.dataSourceState.remove(observer: self)
        
        debugPrint(.success, "Removed `\(Self.self)` observers.")
    }
    
    func viewDidDeallocate() {
        viewDidUnbindObservers()
    }
}


extension HomeViewController {
    
    private func createDataSource() -> MediaTableViewDataSource {
        return MediaTableViewDataSource(tableView, with: viewModel)
    }
    
    private func removeSelectedProfile() {
        
        let userResponseStore = AuthResponseStore()
        
        var currentResponse: HTTPUserDTO.Response? = userResponseStore.fetcher.fetchResponse()
        
        let user = currentResponse?.data
        
        user?.selectedProfile = nil
        
        currentResponse?.data = nil
        
        userResponseStore.updater.updateResponse(currentResponse)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            currentResponse?.data = user
            
            userResponseStore.updater.updateResponse(currentResponse)
        }
    }
}
