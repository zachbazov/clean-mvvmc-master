//
//  OverlayView.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/10/2023.
//

import UIKit

enum OverlayType {
    case edit
}


@objc
protocol OverlayViewDelegate: AnyObject {
    
    func overlay(_ overlay: OverlayView, shouldBePresented presented: Bool)
    
    func overlayDidTap(_ overlay: OverlayView)
}


final class OverlayView: UIView, ViewInstantiable {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    private var type: OverlayType?
    
    weak var delegate: OverlayViewDelegate? {
        didSet {
            targetSubviews()
        }
    }
    
    
    deinit {
        deallocateSubviews()
    }
    
    
    init(type: OverlayType) {
        self.type = type
        
        super.init(frame: .zero)
        
        self.nibDidLoad()
        
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    func configureSubviews() {
        layer.cornerRadius = 4.0
        
        configureImage()
    }
    
    func targetSubviews() {
        let tapGesture = UITapGestureRecognizer(target: delegate, action: #selector(delegate?.overlayDidTap(_:)))
        
        addGestureRecognizer(tapGesture)
    }
    
    func deallocateSubviews() {
        type = nil
        delegate = nil
    }
}


extension OverlayView {
    
    private func configureImage() {
        
        switch type {
        case .edit:
            imageView.image = UIImage(systemName: "pencil")
        default:
            break
        }
    }
}
