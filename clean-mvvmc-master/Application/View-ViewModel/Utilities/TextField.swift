//
//  TextField.swift
//  clean-mvvmc-master
//
//  Created by Developer on 10/10/2023.
//

import UIKit

protocol ViewLifecycle {
    func viewDidDeploySubviews()
}
extension ViewLifecycle {
    func viewDidDeploySubviews() {}
}

extension UIView: ViewLifecycle {
}

@IBDesignable
final class TextField: UITextField {
    
    @IBInspectable
    var bgColor: UIColor = UIColor.clear
    
    @IBInspectable
    var cornerRadius: CGFloat = .zero
    
    @IBInspectable
    var topPadding: CGFloat = .zero
    
    @IBInspectable
    var leadingPadding: CGFloat = .zero
    
    @IBInspectable
    var trailingPadding: CGFloat = .zero
    
    @IBInspectable
    var bottomPadding: CGFloat = .zero
    
    @IBInspectable
    var floatingPlaceholder: String = "" {
        didSet {
            setFloatingPlaceholder(floatingPlaceholder)
        }
    }
    
    
    let floatingLabel: UILabel = UILabel()
    
    
    weak var heightConstraint: NSLayoutConstraint?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.viewDidConfigure()
        self.viewHierarchyDidConfigure()
        self.viewEventsDidTarget()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.viewDidConfigure()
        self.viewHierarchyDidConfigure()
        self.viewEventsDidTarget()
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        bgColor.setFill()
        path.fill()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        viewDidDeploySubviews()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsets(top: topPadding, left: leadingPadding, bottom: bottomPadding, right: trailingPadding)
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsets(top: topPadding, left: leadingPadding, bottom: bottomPadding, right: trailingPadding)
        return bounds.inset(by: padding)
    }
    
    
    func viewDidDeploySubviews() {
        constraintFloatingLabel()
    }
    
    func viewDidConfigure() {
        configureFloatingLabel()
    }
    
    func viewHierarchyDidConfigure() {
        addSubview(floatingLabel)
    }
    
    func viewEventsDidTarget() {
        addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
    }
    
    
    private func constraintFloatingLabel() {
        NSLayoutConstraint.activate([
            floatingLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            floatingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0)
        ])
    }
    
    private func configureFloatingLabel() {
        floatingLabel.translatesAutoresizingMaskIntoConstraints = false
        floatingLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .semibold)
        floatingLabel.textColor = UIColor.lightGray
    }
    
    private func animateFloatingLabel() {
        UIView.animate(withDuration: 0.3) {
            self.floatingLabel.transform = CGAffineTransform(
                translationX: .zero,
                y: -self.floatingLabel.frame.height + 2.0)
        }
    }
    
    private func hideFloatingLabel() {
        UIView.animate(withDuration: 0.3) {
            self.floatingLabel.transform = CGAffineTransform.identity
        }
    }
    
    private func setFloatingPlaceholder(_ placeholder: String) {
        floatingLabel.text = placeholder
        floatingLabel.sizeToFit()
    }
    
    private func setTextColor(_ color: UIColor) {
        textColor = color
    }
    
    
    func setHeightConstraint(_ constraint: NSLayoutConstraint?) {
        guard heightConstraint == nil else { return }
        
        heightConstraint = constraint
    }
    
    
    @objc
    func textFieldDidBeginEditing() {
        animateFloatingLabel()
        
        setTextColor(.white)
        
        heightConstraint?.constant = 56.0
    }
    
    @objc
    func textFieldDidEndEditing() {
        hideFloatingLabel()
        
        setTextColor(.clear)
        
        heightConstraint?.constant = 40.0
    }
}
