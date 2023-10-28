//
//  ProfileViewController.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/10/2023.
//

import UIKit
import CodeBureau

final class ProfileViewController: UIViewController, ViewController {
    
    @IBOutlet private(set) weak var collectionView: UICollectionView!
    
    @IBOutlet private weak var editBarButton: UIBarButtonItem!
    
    
    var viewModel: ProfileViewModel?
    
    private(set) lazy var dataSource: ProfileCollectionViewDataSource? = createDataSource()
    
    
    deinit {
        viewDidDeallocate()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDidConfigure()
        viewDidBindObservers()
        
        viewModel?.fetchProfiles()
    }
    
    
    func viewDidConfigure() {
        configureCollectionViewLayout()
    }
    
    func viewDidBindObservers() {
        
        viewModel?.isEditing.observe(on: self) { isEditing in
            
            self.configureNavigationTitle(isEditing)
            self.configureBarButtonItem(isEditing)
        }
        
        viewModel?.profiles.observe(on: self) { profiles in
            
            self.dataSource?.dataSourceDidChange()
        }
    }
    
    func viewDidUnbindObservers() {
        
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.isEditing.remove(observer: self)
        viewModel.profiles.remove(observer: self)
        
        debugPrint(.success, "Removed `\(String(describing: Self.self))` observers.")
    }
    
    func viewDidDeallocate() {
        viewDidUnbindObservers()
        
        viewModel = nil
    }
}


extension ProfileViewController {
    
    @IBAction
    func editBarButtonDidTap() {
        
        viewModel?.isEditing.value.toggle()
        
        shouldPresentOverlays()
    }
}


extension ProfileViewController {
    
    private func createDataSource() -> ProfileCollectionViewDataSource {
        return ProfileCollectionViewDataSource(collectionView, with: viewModel)
    }
    
    private func configureNavigationTitle(_ isEditing: Bool) {
        title = !isEditing ? "Who's Watching?" : "Manage Profiles"
    }
    
    private func configureBarButtonItem(_ isEditing: Bool) {
        editBarButton.title = !isEditing ? "Edit" : "Done"
    }
    
    private func configureCollectionViewLayout() {
        
        let layout = CollectionViewLayout(layout: .profile, scrollDirection: .vertical)
        
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func shouldPresentOverlays() {
        
        for case let cell as ProfileCollectionViewCell
                in collectionView?.visibleCells ?? [] where cell.cellViewModel?.id != "addProfile" {
            
            if let overlay = cell.editOverlay {
                
                cell.overlay(overlay, shouldBePresented: viewModel?.isEditing.value ?? false)
            }
        }
    }
}
