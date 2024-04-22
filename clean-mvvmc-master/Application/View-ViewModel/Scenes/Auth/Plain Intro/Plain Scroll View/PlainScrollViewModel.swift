//
//  IntroScrollViewModel.swift
//  clean-mvvmc-master
//
//  Created by Developer on 14/04/2024.
//

import Foundation

struct PlainScrollViewModel {
    
    lazy var pages: [PlainPage] = {
        let firstConfig = PlainPage(page: 0, image: "p0", title: "Watch everywhere", description: "Stream on your phone, tablet, laptop and TV.")
        let secondConfig = PlainPage(page: 1, image: "p1", title: "There's a plan for every fan", description: "Small price. Big entertainment.")
        let thirdConfig = PlainPage(page: 2, image: "p2", title: "Cancel online anytime", description: "Join today, no reason to wait.")
        let fourthConfig = PlainPage(page: 3, image: "p3", title: "How do I watch?", description: "Members that subscribe to Netflix can watch here in the app.")
        return [firstConfig, secondConfig, thirdConfig, fourthConfig]
    }()
    
    var boundedOffsetX: CGFloat = .zero
}
