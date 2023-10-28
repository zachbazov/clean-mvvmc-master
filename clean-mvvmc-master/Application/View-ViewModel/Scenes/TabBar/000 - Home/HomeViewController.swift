//
//  HomeViewController.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import UIKit

final class HomeViewController: UIViewController, ViewController {
    
    @IBOutlet private weak var customViewContainer: UIView!
    
    
    var viewModel: HomeViewModel?
    
    var customView: CustomView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCustomView()
    }
}


extension HomeViewController {
    
    private func createCustomView() {
        
        let model = Profile(name: "iOS", image: "person.circle")
        let customViewModel = CustomViewModel(with: model)
        
        customView = CustomView(with: customViewModel)
            .addToHierarchy(in: customViewContainer)
            .constraint(to: customViewContainer)
    }
}
