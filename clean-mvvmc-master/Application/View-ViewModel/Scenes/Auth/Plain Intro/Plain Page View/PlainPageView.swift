//
//  PageView.swift
//  clean-mvvmc-master
//
//  Created by Developer on 30/03/2024.
//

import UIKit

final class PlainPageView: UIView, ViewInstantiable {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private(set) weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var moreLabel: UILabel!
    
    let pageConfiguration: PlainPageConfigurable
    
    init(on parent: UIView, withConfiguration configuration: PlainPageConfigurable) {
        self.pageConfiguration = configuration
        
        let frame = CGRect(x: configuration.page.toCGFloat() * parent.frame.width, y: .zero, width: parent.frame.width, height: parent.frame.height)
        super.init(frame: frame)
        
        self.nibDidLoad()
        self.configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension PlainPageView {
    
    func configureSubviews() {
        imageView.image = UIImage(named: pageConfiguration.image)
        titleLabel.text = pageConfiguration.title
        descriptionLabel.text = pageConfiguration.description
        
        if pageConfiguration.page == 3 {
            clipsToBounds = true
            layer.masksToBounds = true
            
            backgroundImageView.image = UIImage(named: "intro-bg")
        }
    }
}
