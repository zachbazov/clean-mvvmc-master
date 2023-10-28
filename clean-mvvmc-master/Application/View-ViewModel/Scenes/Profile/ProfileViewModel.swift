//
//  ProfileViewModel.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/10/2023.
//

import UIKit
import CodeBureau

final class ProfileViewModel: ViewModel {
    
    var coordinator: ProfileCoordinator?
    
    
    let isEditing: ObservedValue<Bool> = ObservedValue(false)
    
    let profiles: ObservedValue<[Profile]> = ObservedValue([])
    
    var addingAvatar: Avatar?
    
    var editingProfile: Profile?
    
    var editingProfileIndex: Int?
    
    var hasChanges: Bool {
        
        guard let index = editingProfileIndex else {
            return false
        }
        
        return editingProfile != profiles.value[index]
    }
    
    var avatars: [String] {
        return ["av-dark-red",
                "av-dark-green",
                "av-dark-blue",
                "av-dark-purple",
                "av-light-green",
                "av-light-blue",
                "av-light-yellow"]
    }
    
    var settings: [ProfileSetting] {
        return [.maturityRating,
                .displayLanguageSetting,
                .audioAndSubtitlesSetting,
                .autoplayNextEpisodeSetting,
                .autoplayPreviewsSetting]
    }
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
                    
                    profiles.value = response?.data.toDomain() ?? []
                    
                    profiles.value.append(Profile.addProfile)
                }
            }
            
        } else {
            
            useCase.request(
                endpoint: .find,
                request: request,
                cached: nil,
                completion: { [weak self] (result: Result<HTTPProfileDTO.GET.Response, DataTransferError>) in
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let response):
                        
                        self.profiles.value = response.data.toDomain()
                        
                        self.profiles.value.append(Profile.addProfile)
                        
                    case .failure(let error):
                        debugPrint(.error, error.localizedDescription)
                    }
                })
        }
    }
    
    func createProfile(with request: HTTPProfileDTO.POST.Request) {
        
        let useCase = ProfileUseCase()
        
        if #available(iOS 13.0.0, *) {
            
            Task {
                
                if let response: HTTPProfileDTO.POST.Response? = await useCase.request(endpoint: .create, request: request) {
                    
                    profiles.value.insert(response!.data.toDomain(), at: profiles.value.count - 1)
                }
            }
            
        } else {
            
            useCase.request(
                endpoint: .create,
                request: request,
                cached: nil) { [weak self] (result: Result<HTTPProfileDTO.POST.Response, DataTransferError>) in
                    guard let self = self else {
                        return
                    }
                    
                    switch result {
                    case .success(let response):
                        
                        self.profiles.value.insert(response.data.toDomain(), at: self.profiles.value.count - 1)
                        
                    case .failure(let error):
                        debugPrint(.error, error.localizedDescription)
                    }
                }
            
        }
    }
    
    func updateProfile(request: HTTPProfileDTO.PATCH.Request, with settingsRequest: HTTPProfileDTO.Settings.PATCH.Request) {
        
        let useCase = ProfileUseCase()
        
        if #available(iOS 13.0.0, *) {
            
            Task {
                
                let _: HTTPProfileDTO.PATCH.Response? = await useCase.request(endpoint: .update, request: request)
                let _: HTTPProfileDTO.Settings.PATCH.Response? = await useCase.request(endpoint: .update, request: settingsRequest)
            }
            
        } else {
            
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            
            useCase.request(
                endpoint: .update,
                request: request,
                cached: nil) { (result: Result<HTTPProfileDTO.PATCH.Response, DataTransferError>) in
                    
                    if case let .failure(error) = result {
                        debugPrint(.error, error.localizedDescription)
                    }
                    
                    dispatchGroup.leave()
                }
            
            dispatchGroup.enter()
            
            useCase.request(
                endpoint: .update,
                request: settingsRequest,
                cached: nil) { (result: Result<HTTPProfileDTO.Settings.PATCH.Response, DataTransferError>) in
                    
                    if case let .failure(error) = result {
                        debugPrint(.error, error.localizedDescription)
                    }
                    
                    dispatchGroup.leave()
                }
        }
    }
    
    func updateProfileSettings(with request: HTTPProfileDTO.Settings.PATCH.Request) {
        
        let useCase = ProfileUseCase()
        
        if #available(iOS 13.0.0, *) {
            
            Task {
                
                let _: HTTPProfileDTO.Settings.PATCH.Response? = await useCase.request(endpoint: .update, request: request)
            }
            
        } else {
            
            useCase.request(
                endpoint: .update,
                request: request,
                cached: nil) { (result: Result<HTTPProfileDTO.Settings.PATCH.Response, DataTransferError>) in
                    
                    if case let .failure(error) = result {
                        debugPrint(.error, error.localizedDescription)
                    }
                }
        }
    }
    
    func deleteProfile(with request: HTTPProfileDTO.DELETE.Request) {
        
        let useCase = ProfileUseCase()
        
        if #available(iOS 13.0.0, *) {
            
            Task {
                
                if let _: Void = await useCase.request(endpoint: .delete, request: request) {
                    
                    profiles.value.removeAll(where: { $0._id == request.id })
                }
            }
            
        } else {
            
            useCase.request { [weak self] result in
                guard let self = self else {
                    return
                }
                
                if case .success = result {
                    
                    self.profiles.value.removeAll(where: { $0._id == request.id })
                }
            }
        }
    }
}
