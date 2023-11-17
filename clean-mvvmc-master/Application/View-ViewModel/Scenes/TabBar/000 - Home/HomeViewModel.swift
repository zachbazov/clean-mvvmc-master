//
//  HomeViewModel.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import Foundation

final class HomeViewModel: ViewModel {
    
    var coordinator: TabBarCoordinator?
    
    
    var sections: [Section] = []
    var media: [Media] = []
    
    
    let dataSourceState: ObservedValue<MediaTableViewDataSource.State> = ObservedValue(.all)
    
    let numberOfRowsInSection: Int = 1
}


extension HomeViewModel {
    
    func fetchData() {
        
        let sectionResponseStore = SectionResponseStore()
        let mediaResponseStore = MediaResponseStore()
        
        if let sectionResponse: HTTPSectionDTO.Response? = sectionResponseStore.fetcher.fetchResponse() {
            sections = sectionResponse?.data.toDomain() ?? []
        }
        
        if let mediaResponse: HTTPMediaDTO.Response? = mediaResponseStore.fetcher.fetchResponse() {
            media = mediaResponse?.data.toDomain() ?? []
        }
    }
}
