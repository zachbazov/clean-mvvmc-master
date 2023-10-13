//
//  CustomView.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import UIKit
import CodeBureau

final class CustomView: UIView, View {
    
    var viewModel: CustomViewModel?
    
    
    @IBOutlet private(set) weak var label: UILabel!
    
    
    init(on parent: UIView, with viewModel: CustomViewModel) {
        self.viewModel = viewModel
        
        super.init(frame: parent.bounds)
        
        parent.addSubview(self)
        
        self.nibDidLoad()
        
        self.updateView(with: viewModel)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.nibDidLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}


extension CustomView {
    @IBAction private func viewDidTap() {
        guard let coordinator = Application.app.coordinator.tabBarCoordinator else { return }
        
        coordinator.coordinate(to: .search)
    }
}


extension CustomView {
    
    func updateView(with viewModel: CustomViewModel?) {
        label?.text = viewModel?.title
    }
}
