//
//  View+Instantiable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import UIKit
import CodeBureau

extension View {
    
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
    
    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    
    func nibDidLoad() {
        let identifier = String(describing: Self.self)
        let view = Bundle.main.loadNibNamed(identifier,
                                            owner: self,
                                            options: nil)![0] as! UIView
        
        addSubview(view)
        
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
