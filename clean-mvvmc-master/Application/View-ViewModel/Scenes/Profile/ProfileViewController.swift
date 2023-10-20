//
//  ProfileViewController.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/10/2023.
//

import UIKit
import CodeBureau
import URLDataTransfer

final class ProfileViewController: UIViewController, CoordinatorViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    
    var controllerViewModel: ProfileViewModel?
    
    
    //private var dataSource
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDidDeploySubviews()
        viewDidConfigure()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            
            let authService = AuthService.shared
            
            guard let user = authService.user else {
                return
            }
            
            let useCase = ProfileUseCase()
            let request = HTTPProfileDTO.GET.Request(user: user)
            
            useCase.request(
                endpoint: .find,
                request: request,
                error: nil,
                cached: nil,
                completion: { result in
                    switch result {
                    case .success(let response):
                        
                        print(response.toDomain())
                        
                    case .failure(let error):
                        print(error)
                    }
                })
        })
    }
    
    
    func viewDidDeploySubviews() {
        
    }
    
    func viewDidConfigure() {
        
    }
}
