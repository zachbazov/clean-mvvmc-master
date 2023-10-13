//
//  OmegaViewController.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import UIKit
import CodeBureau

final class OmegaViewController: UIViewController, ViewController {
    
    var viewModel: OmegaViewModel?
    
    
    deinit {
        print("deinit \(Self.self)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel?.coordinator?.omegaViewController = nil
    }
}
