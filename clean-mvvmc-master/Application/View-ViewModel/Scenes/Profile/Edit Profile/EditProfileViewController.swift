//
//  EditProfileViewController.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/10/2023.
//

import UIKit
import CodeBureau

final class EditProfileViewController: UIViewController, ViewController {
    
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var badgeViewContainer: UIView!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var profileSettingsTableView: UITableView!
    
    
    var viewModel: EditProfileViewModel?
    
    
    //private var dataSource
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction
    private func cancelDidTap() {
        
    }
    
    @IBAction
    private func doneDidTap() {
        
    }
}
