//
//  SkeletonDisplayTableViewCell.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/11/2023.
//

import UIKit

final class SkeletonDisplayTableViewCell: UITableViewCell, TableViewCell {
    
    @IBOutlet private weak var rootContainer: UIView!
    @IBOutlet private weak var typeContainer: UIView!
    @IBOutlet private weak var logoContainer: UIView!
    @IBOutlet private weak var genresContainer: UIView!
    @IBOutlet private weak var addContainer: UIView!
    @IBOutlet private weak var detailContainer: UIView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        typeContainer.removeShimmer()
        logoContainer.removeShimmer()
        genresContainer.removeShimmer()
        addContainer.removeShimmer()
        detailContainer.removeShimmer()
    }
    
    func deploySubviews() {
        
        createShimmerViews()
        
        configureSubviews()
    }
    
    func configureSubviews() {
        let cornerRadius: CGFloat = 8.0
        
        rootContainer.layer.cornerRadius = cornerRadius
        typeContainer.layer.cornerRadius = cornerRadius
        logoContainer.layer.cornerRadius = cornerRadius
        genresContainer.layer.cornerRadius = cornerRadius
        addContainer.layer.cornerRadius = cornerRadius
        detailContainer.layer.cornerRadius = cornerRadius
    }
}

extension SkeletonDisplayTableViewCell {
    
    private func createShimmerViews() {
        typeContainer.addShimmer()
        logoContainer.addShimmer()
        genresContainer.addShimmer()
        addContainer.addShimmer()
        detailContainer.addShimmer()
    }
}
