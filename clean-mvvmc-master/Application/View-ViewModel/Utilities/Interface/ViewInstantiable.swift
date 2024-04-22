//
//  ViewInstantiable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 22/10/2023.
//

import UIKit

// MARK: - ViewInstantiable Type

protocol ViewInstantiable: UIView, Reusable {
}

// MARK: - ViewInstantiable Implementation

extension ViewInstantiable {
    
    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    @discardableResult
    func nibDidLoad() -> Self {
        
        let name = String(describing: Self.self)
        let view = Bundle.main.loadNibNamed(name, owner: self, options: nil)![0] as! UIView
        
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        return self
    }
    
    static func loadNib<T>(in parent: UIView) -> T where T: UIView {
        
        let name = String(describing: Self.self)
        let view = Bundle.main.loadNibNamed(name, owner: self, options: nil)![0] as! UIView
        
        view.addToHierarchy(in: parent)
            .constraint(to: parent)
        
        return view as! T
    }
}
