//
//  ProfileViewController.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/10/2023.
//

import UIKit
import CodeBureau

final class ProfileViewController: UIViewController, CoordinatorViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    
    var controllerViewModel: ProfileViewModel?
    
    
    //private var dataSource
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDidDeploySubviews()
        viewDidConfigure()
        
        //controllerViewModel?.fetchProfiles()
    }
    
    
    func viewDidDeploySubviews() {
        
    }
    
    func viewDidConfigure() {
        
    }
}
