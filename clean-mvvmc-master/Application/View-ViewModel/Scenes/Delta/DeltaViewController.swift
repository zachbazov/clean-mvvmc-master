//
//  DeltaViewController.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import UIKit

final class DeltaViewController: UIViewController, ViewController {
    
    var viewModel: DeltaViewModel?
    
    
    deinit {
        print("deinit \(Self.self)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel?.coordinator?.deltaViewController = nil
    }
}
