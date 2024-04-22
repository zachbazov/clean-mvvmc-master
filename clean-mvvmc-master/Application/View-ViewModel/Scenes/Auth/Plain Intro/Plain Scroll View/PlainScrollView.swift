//
//  PlainScrollView.swift
//  clean-mvvmc-master
//
//  Created by Developer on 14/04/2024.
//

import UIKit

final class PlainScrollView: UIView, ViewInstantiable {
    
    @IBOutlet private(set) weak var scrollView: UIScrollView!
    
    var viewModel: PlainScrollViewModel!
    
    private var firstPage: PlainPageView!
    private var secondPage: PlainPageView!
    private var thirdPage: PlainPageView!
    private var fourthPage: PlainPageView!
    
    init(on parent: UIView) {
        super.init(frame: parent.bounds)
        
        self.nibDidLoad()
        
        self.viewModel = PlainScrollViewModel()
        
        self.configurePages()
        self.configureScrollView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension PlainScrollView {
    
    private func configureScrollView() {
        scrollView.delegate = self
        
        let plainPages: [PlainPageView]! = [firstPage, secondPage, thirdPage, fourthPage]
        for page in plainPages {
            scrollView.addSubview(page)
        }
    }
    
    private func configurePages() {
        firstPage = PlainPageView(on: scrollView, withConfiguration: viewModel.pages[0])
        secondPage = PlainPageView(on: scrollView, withConfiguration: viewModel.pages[1])
        thirdPage = PlainPageView(on: scrollView, withConfiguration: viewModel.pages[2])
        fourthPage = PlainPageView(on: scrollView, withConfiguration: viewModel.pages[3])
    }
    
    private func handleScrolling(_ scrollView: UIScrollView) {
        let translationX = scrollView.panGestureRecognizer.translation(in: scrollView).x
        let offsetX = scrollView.contentOffset.x
        let pagesOffsets = [.zero, frame.size.width, frame.size.width * 2.0, frame.size.width * 3.0]
        
        if translationX < .zero {
            handleLeftScroll(offsetX: offsetX, translationX: translationX, pages: pagesOffsets)
        } else {
            handleRightScroll(offsetX: offsetX, translationX: translationX, pages: pagesOffsets)
        }
    }
    
    private func handleLeftScroll(offsetX: CGFloat, translationX: CGFloat, pages: [CGFloat]) {
        if offsetX == pages[0] {
            // PAGE 1
        } else if offsetX > pages[0] && offsetX < pages[1] {
            // PAGE 1 TO PAGE 2
        } else if offsetX == pages[1] {
            // PAGE 2
        } else if offsetX > pages[1] && offsetX < pages[2] {
            // PAGE 2 TO PAGE 3
        } else if offsetX == pages[2] {
            // PAGE 3
            
            let transformation = CGAffineTransform.identity
            animateFourthImageView(to: transformation)
        } else if offsetX > pages[2] && offsetX < pages[3] {
            // PAGE 3 TO PAGE 4
            
            viewModel.boundedOffsetX = calculateBoundedOffsetX(offsetX: offsetX, translationX: translationX)
            
            let transformation = CGAffineTransform(scaleX: viewModel.boundedOffsetX, y: viewModel.boundedOffsetX)
            animateFourthImageView(to: transformation)
        } else if offsetX == pages[3] {
            // PAGE 4
            
            viewModel.boundedOffsetX = 1.10
            
            let transformation = CGAffineTransform(scaleX: viewModel.boundedOffsetX, y: viewModel.boundedOffsetX)
            animateFourthImageView(to: transformation)
        }
    }
    
    private func handleRightScroll(offsetX: CGFloat, translationX: CGFloat, pages: [CGFloat]) {
        if offsetX == pages[3] {
            // PAGE 4
            
            let transformation = CGAffineTransform(scaleX: 1.10, y: 1.10)
            animateFourthImageView(to: transformation)
        } else if offsetX < pages[3] && offsetX > pages[2] {
            // PAGE 4 TO PAGE 3
            
            if offsetX <= pages[2] + (frame.size.width / 3.0) && offsetX > pages[2] {
                viewModel.boundedOffsetX = calculateBoundedOffsetX(offsetX: offsetX, translationX: translationX)
                
                let transformation = CGAffineTransform(scaleX: viewModel.boundedOffsetX, y: viewModel.boundedOffsetX)
                animateFourthImageView(to: transformation)
            }
        } else if offsetX == pages[2] {
            // PAGE 3
        } else if offsetX < pages[2] && offsetX > pages[1] {
            // PAGE 3 TO PAGE 2
        } else if offsetX == pages[1] {
            // PAGE 2
        } else if offsetX < pages[1] && offsetX > pages[0] {
            // PAGE 2 TO PAGE 1
        } else if offsetX == pages[0] {
            // PAGE 1
        }
    }
    
    private func calculateBoundedOffsetX(offsetX: CGFloat, translationX: CGFloat) -> CGFloat {
        let leftBoundedOffsetX = min(1.0 - (0.5 * translationX / (frame.size.width / 2.0)), 1.10)
        let rightBoundedOffsetX = max(1.1 + (1.0 - (0.5 * translationX / (frame.size.width / 3.0))), 1.0)
        return translationX < .zero ? leftBoundedOffsetX : rightBoundedOffsetX
    }
    
    private func animateFourthImageView(to transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else {
                return
            }
            
            self.fourthPage.backgroundImageView?.transform = transform
        }
    }
}

extension PlainScrollView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleScrolling(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        let controller = Application.app.coordinator.authCoordinator?.viewController
        
        controller?.pageControl.currentPage = Int(pageNumber)
    }
}
