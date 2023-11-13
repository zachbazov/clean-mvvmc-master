//
//  CustomView.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import UIKit

final class CustomView: UIView, ViewInstantiable {
    
    @IBOutlet private(set) weak var label: UILabel!
    
    
    let viewModel: CustomViewModel
    
    
    init(with viewModel: CustomViewModel) {
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
        self.nibDidLoad()
        
        self.configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    func configureSubviews() {
        setTitleText(viewModel.title)
    }
}


extension CustomView {
    
    @IBAction
    private func viewDidTap() {
        
        guard let coordinator = Application.app.coordinator.tabBarCoordinator else { return }
        
        coordinator.coordinate(to: .detail)
        
        /*
         coordinator.coordinate(to: .search)
         
         DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             coordinator.searchNavigationController?.removeChild()
         }
         */
    }
}


extension CustomView {
    
    func setTitleText(_ text: String) {
        label?.text = text
    }
}
