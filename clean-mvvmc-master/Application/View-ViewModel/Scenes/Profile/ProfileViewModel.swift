//
//  ProfileViewModel.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/10/2023.
//

import UIKit
import CodeBureau

final class ProfileViewModel: CoordinatorViewModel {
    
    var coordinator: ProfileCoordinator?
}


extension ProfileViewModel {
    
    func fetchProfiles() {
        let authService = Application.app.server.authService
        
        guard let user = authService.user else {
            return
        }
        
        let useCase = ProfileUseCase()
        let request = HTTPProfileDTO.GET.Request(user: user.toDTO())
        
        if #available(iOS 13.0.0, *) {
            
            Task {
                if let response: HTTPProfileDTO.GET.Response? = await useCase.request(endpoint: .find, request: request) {
                    print(response!.toDomain())
                }
            }
        } else {
            
            useCase.request(
                endpoint: .find,
                request: request,
                cached: nil,
                completion: { (result: Result<HTTPProfileDTO.GET.Response, DataTransferError>) in
                    switch result {
                    case .success(let response):

                        print(response.toDomain())

                    case .failure(let error):
                        print(error)
                    }
                })
        }
    }
}
