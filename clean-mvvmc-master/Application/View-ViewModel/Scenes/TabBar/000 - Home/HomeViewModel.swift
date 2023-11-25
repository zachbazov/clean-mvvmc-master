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
    var displayMedia: [MediaTableViewDataSource.State: Media] = [:]
    
    
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
            
            MediaTableViewDataSource.Section.allCases.forEach {
                sections[$0.rawValue].media = filter(at: $0)
            }
            
            MediaTableViewDataSource.State.allCases.forEach {
                displayMedia[$0] = filter(forDisplayMediaAtState: $0)
            }
            
            coordinator?.homeViewController?.dataSource?.dataSourceDidChange()
        }
    }
}


extension HomeViewModel {
    
    private func filter(forDisplayMediaAtState state: MediaTableViewDataSource.State) -> Media? {
        guard displayMedia[state] == nil else {
            return nil
        }
        
        switch state {
        case .all:
            return media.randomElement()
        case .tvShows:
            return media.filter { $0.type == "series" }.randomElement()
        case .movies:
            return media.filter { $0.type == "film" }.randomElement()
        }
    }
    
    /// Filter a section based on an index of the table view data source.
    /// - Parameter index: Representation of the section's index.
    /// - Returns: Filtered media array.
    private func filter(at section: MediaTableViewDataSource.Section) -> [Media] {
        
        switch section {
        case .newRelease:
            
            switch dataSourceState.value {
            case .all:
                return media.shuffled().filter { $0.isNewRelease }
            case .tvShows:
                return media.filter { $0.type == "series" && $0.isNewRelease }
            case .movies:
                return media.filter { $0.type == "film" && $0.isNewRelease }
            }
            
        case .rated:
            
            switch dataSourceState.value {
            case .all:
                return media
                    .sorted { $0.rating > $1.rating }
                    .filter { $0.rating > 7.5 }
                    .slice(10)
            case .tvShows:
                return media
                    .filter { $0.type == "series" }
                    .sorted { $0.rating > $1.rating }
                    .filter { $0.rating > 7.5 }
                    .slice(10)
            case .movies:
                return media
                    .filter { $0.type == "film" }
                    .sorted { $0.rating > $1.rating }
                    .filter { $0.rating > 7.5 }
                    .slice(10)
            }
            
        case .resumable:
            
            switch dataSourceState.value {
            case .all:
                return media.shuffled()
            case .tvShows:
                return media.shuffled().filter { $0.type == "series" }
            case .movies:
                return media.shuffled().filter { $0.type == "film" }
            }
            
        case .myList:
            
//            guard let myList = Application.app.coordinator.tabCoordinator?.viewController?.viewModel.myList else {
//                return []
//            }
//            
//            let media = myList.media
//            
//            switch dataSourceState.value {
//            case .all:
//                return media.shuffled()
//            case .tvShows:
//                return media.shuffled().filter { $0.type == "series" }
//            case .movies:
//                return media.shuffled().filter { $0.type == "film" }
//            }
            return []
            
        case .blockbuster:
            
            let value = Float(7.5)
            
            switch dataSourceState.value {
            case .all:
                return media.filter { $0.rating > value }
            case .tvShows:
                return media.filter { $0.type == "series" }.filter { $0.rating > value }
            case .movies:
                return media.filter { $0.type == "film" }.filter { $0.rating > value }
            }
            
        default:
            
            switch dataSourceState.value {
            case .all:
                return media
                    .shuffled()
                    .filter { $0.genres.contains(sections[section.rawValue].title) }
            case .tvShows:
                return media
                    .shuffled()
                    .filter { $0.type == "series" }
                    .filter { $0.genres.contains(sections[section.rawValue].title) }
            case .movies:
                return media
                    .shuffled()
                    .filter { $0.type == "film" }
                    .filter { $0.genres.contains(sections[section.rawValue].title) }
            }
        }
    }
}








extension Array where Element == Media {
    
    func slice(_ maxLength: Int) -> [Element] { Array(prefix(maxLength)) }
    
    func toObjectIDs() -> [String] { map { String($0.id!) } }
    
    func toSet() -> Set<Element> { Set(self) }
}
