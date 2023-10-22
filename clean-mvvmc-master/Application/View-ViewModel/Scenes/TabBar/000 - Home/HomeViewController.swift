//
//  HomeViewController.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import UIKit
import CodeBureau

class HomeViewController: UIViewController, ViewController {
    
    var viewModel: HomeViewModel?
    
    
    @IBOutlet weak var customViewContainer: UIView!
    
    
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
        
        customView = CustomView(on: customViewContainer, with: customViewModel)
    }
}
