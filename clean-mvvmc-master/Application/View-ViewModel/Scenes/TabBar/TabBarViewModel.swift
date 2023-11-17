//
//  TabBarViewModel.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import Foundation

final class TabBarViewModel: ViewModel {
    
    var coordinator: TabBarCoordinator?
    
    let profile: ObservedValue<Profile?> = ObservedValue(nil)
}


extension TabBarViewModel {
    
    func fetchSelectedProfile(_ completion: (() -> Void)? = nil) {
        
        let authService = Application.app.server.authService
        
        guard let user = authService.user,
              let selectedProfileId = user.selectedProfile else {
            return
        }
        
        let profileUseCase = ProfileUseCase()
        
        let request = HTTPProfileDTO.GET.Request(user: user.toDTO(), _id: selectedProfileId)
        
        profileUseCase.request(endpoint: .find, request: request, cached: nil) { [weak self] (result: Result<HTTPProfileDTO.GET.Response, DataTransferError>) in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let response):
                
                self.profile.value = response.data.first?.toDomain()
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
