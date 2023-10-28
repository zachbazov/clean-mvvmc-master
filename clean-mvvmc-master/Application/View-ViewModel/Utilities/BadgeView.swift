//
//  BadgeView.swift
//  clean-mvvmc-master
//
//  Created by Developer on 24/10/2023.
//

import UIKit

enum BadgeType {
    case delete
    case edit
}


@objc
protocol BadgeViewDelegate: AnyObject {
    
    @objc optional func badge(_ badge: BadgeView, shouldBePresented presented: Bool)
    
    func badgeDidTap(_ badge: BadgeView)
}


final class BadgeView: UIView, ViewInstantiable {
    
    @IBOutlet private weak var button: UIButton!
    
    var type: BadgeType?
    
    weak var delegate: BadgeViewDelegate? {
        didSet {
            targetSubviews()
        }
    }
    
    
    deinit {
        deallocateSubviews()
    }
    
    
    init(type: BadgeType) {
        self.type = type
        
        super.init(frame: .zero)
        
        self.nibDidLoad()
        
        self.configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    func configureSubviews() {
        configureBackground()
        configureButton()
    }
    
    func targetSubviews() {
        
        let tapGesture = UITapGestureRecognizer(target: delegate, action: #selector(delegate?.badgeDidTap))
        
        addGestureRecognizer(tapGesture)
    }
    
    func deallocateSubviews() {
        type = nil
        delegate = nil
    }
}


extension BadgeView {
    
    private func configureBackground() {
        
        layer.cornerRadius = 4.0
        
        switch type {
        case .delete:
            backgroundColor = .hexColor("#C62E27")
        case .edit:
            backgroundColor = .white
        default:
            break
        }
    }
    
    private func configureButton() {
        
        let image: UIImage?
        
        switch type {
        case .delete:
            
            let configuration = UIImage.SymbolConfiguration(font: .boldSystemFont(ofSize: 10.0))
            
            image = UIImage(systemName: "xmark")?
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(.white)
                .withConfiguration(configuration)
            
        case .edit:
            
            let configuration = UIImage.SymbolConfiguration(font: .boldSystemFont(ofSize: 13.0))
            
            image = UIImage(systemName: "pencil")?
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(.black)
                .withConfiguration(configuration)
            
        default:
            image = nil
        }
        
        button.setImage(image, for: .normal)
        
        button.addTarget(delegate, action: #selector(delegate?.badgeDidTap(_:)), for: .touchUpInside)
    }
}
