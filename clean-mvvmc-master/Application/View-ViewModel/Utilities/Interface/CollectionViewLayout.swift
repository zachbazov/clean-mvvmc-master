//
//  CollectionViewLayout.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/10/2023.
//

import UIKit

final class CollectionViewLayout: UICollectionViewFlowLayout {
    
    private let layout: Layout
    
    private var itemsPerLine: CGFloat = 3.0
    
    private var lineSpacing: CGFloat = 8.0
    
    private var size: CGSize {
        return CGSize(width: widthForItem(), height: heightForItem())
    }
    
    init(layout: Layout) {
        self.layout = layout
        
        super.init()
    }
    
    convenience init(layout: Layout, scrollDirection: UICollectionView.ScrollDirection? = .horizontal) {
        self.init(layout: layout)
        
        self.scrollDirection = scrollDirection == .horizontal ? .horizontal : .vertical
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepare() {
        super.prepare()
        
        minimumLineSpacing = lineSpacing
        minimumInteritemSpacing = .zero
        sectionInset = .zero
        itemSize = size
        
        switch layout {
        case .rated:
            minimumLineSpacing = .zero
            
        case .resumable:
            break
        case .standard:
            break
        case .blockbuster:
            break
        case .detail:
            sectionInset = .init(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
            
        case .navigationOverlay:
            sectionInset = .init(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
            
        case .descriptive:
            break
        case .trailer:
            break
        case .search:
            break
        case .profile:
            
            itemsPerLine = 2.0
            
            minimumLineSpacing = 16.0
            minimumInteritemSpacing = .zero
            
            let numberOfItems = collectionView?.numberOfItems(inSection: .zero).toCGFloat() ?? .zero
            
            var horizontalInset = size.width / itemsPerLine
            let verticalInset: CGFloat
            
            switch numberOfItems {
                
            case let n where n <= 1:
                
                horizontalInset = ((collectionView?.bounds.width ?? .zero) / itemsPerLine)
                verticalInset = ((collectionView?.bounds.height ?? .zero) / itemsPerLine) - size.height + minimumLineSpacing + lineSpacing
                
                sectionInset = UIEdgeInsets(horizontal: horizontalInset, vertical: verticalInset)
                
            case let n where n <= 6:
                
                verticalInset = (collectionView?.bounds.height ?? .zero) / (numberOfItems * itemsPerLine) + (size.height / itemsPerLine)
                
                sectionInset = UIEdgeInsets(horizontal: horizontalInset, vertical: verticalInset)
                
            default:
                
                verticalInset = (collectionView?.bounds.height ?? .zero) / (numberOfItems * itemsPerLine) + (size.height / itemsPerLine) - ((minimumLineSpacing * itemsPerLine) * itemsPerLine)
                
                sectionInset = UIEdgeInsets(horizontal: horizontalInset, vertical: verticalInset)
            }
            
        case .avatarSelector:
            
            minimumLineSpacing = 4.0
            minimumInteritemSpacing = 4.0
            
            sectionInset = .init(top: .zero, left: 16.0, bottom: .zero, right: 16.0)
            
        case .profileSelector:
            
            minimumLineSpacing = 4.0
            minimumInteritemSpacing = .zero
            
            sectionInset = .init(top: .zero, left: 16.0, bottom: .zero, right: 16.0)
            
        case .notification:
            sectionInset = .init(top: 4.0, left: .zero, bottom: 4.0, right: .zero)
            
        default:
            break
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if layout == .avatarSelector && layout == .profileSelector {
            return false
        }
        
        if let oldBounds = collectionView?.bounds as CGRect?,
           oldBounds.size != newBounds.size {
            
            return true
        }
        
        return super.shouldInvalidateLayout(forBoundsChange: newBounds)
    }
}

// MARK: - Layout Type

extension CollectionViewLayout {
    
    /// Layout representation type.
    enum Layout {
        case rated
        case resumable
        case standard
        case blockbuster
        case navigationOverlay
        case detail
        case descriptive
        case trailer
        case news
        case search
        case profile
        case avatarSelector
        case profileSelector
        case notification
    }
}


extension CollectionViewLayout {
    
    private func widthForItem() -> CGFloat {
        guard let width = collectionView?.bounds.width else {
            return .zero
        }
        
        switch layout {
        case .rated:
            return width / itemsPerLine + lineSpacing
            
        case .blockbuster:
            return width / itemsPerLine + (lineSpacing * itemsPerLine)
            
        case .detail:
            return width / itemsPerLine - (lineSpacing * itemsPerLine)
            
        case .navigationOverlay:
            return width / itemsPerLine - (lineSpacing * (itemsPerLine - 1))
            
        case .descriptive:
            return width
        case .trailer:
            return width
        case .news:
            return width
        case .search:
            return width
        case .profile:
            return 128.0
        case .avatarSelector:
            return 68.0
        case .profileSelector:
            return 64.0
        case .notification:
            return width
        default:
            return width / itemsPerLine - (lineSpacing * itemsPerLine + 1)
        }
    }
    
    private func heightForItem() -> CGFloat {
        guard let height = collectionView?.bounds.height else {
            return .zero
        }
        
        switch layout {
        case .rated:
            return height - lineSpacing
        case .resumable:
            return height - lineSpacing
        case .standard:
            return height - lineSpacing
        case .blockbuster:
            return height - lineSpacing
        case .navigationOverlay:
            return 162.0
        case .detail:
            return 146.0
        case .descriptive:
            return 156.0
        case .trailer:
            return 224.0
        case .news:
            return 426.0
        case .search:
            return 80.0
        case .profile:
            return widthForItem() + lineSpacing
        case .avatarSelector:
            return 68.0
        case .profileSelector:
            return 64.0 + 16.0
        case .notification:
            return 80.0
        }
    }
}
