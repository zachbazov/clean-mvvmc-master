//
//  EditProfileSettingViewController.swift
//  clean-mvvmc-master
//
//  Created by Developer on 25/10/2023.
//

import UIKit

final class EditProfileSettingViewController: UIViewController, ViewController {
    
    @IBOutlet private weak var closeButton: UIButton!
    
    
    var viewModel: ProfileViewModel?
    
    
    deinit {
        print("deinit \(Self.self)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDidConfigure()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel?.coordinator?.editProfileSettingViewController = nil
    }
    
    
    func viewDidConfigure() {
        
    }
}


extension EditProfileSettingViewController {
    
    @IBAction
    private func closeDidTap() {
        viewModel?.coordinator?.editProfileNavigationController?.popViewController(animated: true)
    }
    
    @IBAction
    private func doneDidTap() {
        
    }
}
