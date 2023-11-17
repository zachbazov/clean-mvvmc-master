//
//  AvatarSelectorViewController.swift
//  clean-mvvmc-master
//
//  Created by Developer on 26/10/2023.
//

import UIKit

final class AvatarSelectorViewController: UIViewController, ViewController {
    
    @IBOutlet private weak var closeButton: UIButton!
    
    @IBOutlet private(set) weak var collectionView: UICollectionView!
    
    
    var viewModel: ProfileViewModel!
    
    private var dataSource: AvatarSelectorCollectionViewDataSource?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDidDeploySubviews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel?.coordinator?.avatarSelectorViewController = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutButtonLayer()
    }
    
    
    func viewDidDeploySubviews() {
        createDataSource()
    }
}


extension AvatarSelectorViewController {
    
    @IBAction
    private func closeDidTap() {
        dismiss(animated: true)
    }
}


extension AvatarSelectorViewController {
    
    private func createDataSource() {
        
        let layout = CollectionViewLayout(layout: .avatarSelector, scrollDirection: .vertical)
        
        collectionView.setCollectionViewLayout(layout, animated: false)
        
        dataSource = AvatarSelectorCollectionViewDataSource(collectionView, with: viewModel)
        
        dataSource?.dataSourceDidChange()
    }
    
    private func layoutButtonLayer() {
        closeButton.layer.cornerRadius = closeButton.bounds.height / 2.0
    }
}
