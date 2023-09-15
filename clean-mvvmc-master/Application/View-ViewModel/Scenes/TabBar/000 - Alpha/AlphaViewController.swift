//
//  AlphaViewController.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import UIKit

class AlphaViewController: UIViewController, ViewController {
    
    var viewModel: AlphaViewModel?
    
    
    @IBOutlet weak var customViewContainer: UIView!
    
    
    var customView: CustomView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCustomView()
    }
}


extension AlphaViewController {
    
    private func createCustomView() {
        let model = Profile(name: "iOS")
        let customViewModel = CustomViewModel(with: model)
        
        customView = CustomView(on: customViewContainer, with: customViewModel)
    }
}
