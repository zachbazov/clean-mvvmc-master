//
//  ResumingCollectionViewCell.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/11/2023.
//

import UIKit

final class ResumingCollectionViewCell: MediaCollectionViewCell {
    
    @IBOutlet private weak var optionsButton: UIButton!
    @IBOutlet private weak var infoButton: UIButton!
    @IBOutlet private weak var lengthLabel: UILabel!
    @IBOutlet private weak var gradientView: UIView!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var progressView: UIProgressView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func deploySubviews() {
        super.deploySubviews()
    }
}
