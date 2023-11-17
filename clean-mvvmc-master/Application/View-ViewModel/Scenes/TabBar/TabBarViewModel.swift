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
        let profileResponseStore = ProfileResponseStore()
        
        let request = HTTPProfileDTO.GET.Request(user: user.toDTO(), _id: selectedProfileId)
        
        if #available(iOS 13.0.0, *) {
            
            Task {
                
                if let response: HTTPProfileDTO.GET.Response? = await profileUseCase.request(endpoint: .find, request: request) {
                    
                    profile.value = response?.data.first?.toDomain()
                }
            }
            
        } else {
            
            profileUseCase.request(
                endpoint: .find,
                request: request,
                cached: { [weak self] (response: HTTPProfileDTO.GET.Response?) in
                    guard let self = self else {
                        return
                    }
                    
                    self.profile.value = response?.data.first?.toDomain()
                    
                }) { [weak self] (result: Result<HTTPProfileDTO.GET.Response, DataTransferError>) in
                    guard let self = self else {
                        return
                    }
                    
                    switch result {
                    case .success(let response):
                        
                        self.profile.value = response.data.first?.toDomain()
                        
                        profileResponseStore.saver.saveResponse(response)
                        
                    case .failure(let error):
                        print(error)
                    }
                }
        }
    }
}
