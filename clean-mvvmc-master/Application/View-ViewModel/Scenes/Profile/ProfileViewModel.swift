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
    
    let hasChanges: ObservedValue<Bool> = ObservedValue(false)
    
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
    
    func setEditingProfile(_ profile: Profile) {
        editingProfile = profile
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
                    
                    guard let profile = response?.data else {
                        return
                    }
                    
                    profiles.value.insert(profile.toDomain(), at: profiles.value.count - 1)
                    
                    let authResponseStore = AuthResponseStore()
                    let authService = Application.app.server.authService
                    var user = authService.user
                    
                    user?.profiles = profiles.value.toObjectIDs()
                    var currentResponse: HTTPUserDTO.Response? = authResponseStore.fetcher.fetchResponse()
                    currentResponse?.data?.profiles = user?.profiles
                    
                    authResponseStore.deleter.deleteResponse()
                    authResponseStore.saver.saveResponse(currentResponse)
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
    
    func updateProfile(request: HTTPProfileDTO.PATCH.Request) {
        
        let useCase = ProfileUseCase()
        
        if #available(iOS 13.0.0, *) {
            
            Task {
                
                if let response: HTTPProfileDTO.PATCH.Response? = await useCase.request(endpoint: .update, request: request) {
                    
                    guard let profile = response?.data else {
                        return
                    }
                    
                    guard var toBeUpdatedProfile = profiles.value.first(where: { $0._id == profile._id }) else {
                        return
                    }
                    guard var index = profiles.value.firstIndex(of: toBeUpdatedProfile) else {
                        return
                    }
                    
                    toBeUpdatedProfile = profile.toDomain()
                    
                    profiles.value[index] = toBeUpdatedProfile
                    
                    let authResponseStore = AuthResponseStore()
                    let authService = Application.app.server.authService
                    var user = authService.user
                    
                    user?.profiles = profiles.value.toObjectIDs()
                    user?.selectedProfile = response?.data._id
                    
                    var currentResponse: HTTPUserDTO.Response? = authResponseStore.fetcher.fetchResponse()
                    currentResponse?.data?.profiles = user?.profiles
                    
                    authResponseStore.deleter.deleteResponse()
                    authResponseStore.saver.saveResponse(currentResponse)
                }
            }
            
        } else {
            
            useCase.request(
                endpoint: .update,
                request: request,
                cached: nil) { (result: Result<HTTPProfileDTO.PATCH.Response, DataTransferError>) in
                    
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
