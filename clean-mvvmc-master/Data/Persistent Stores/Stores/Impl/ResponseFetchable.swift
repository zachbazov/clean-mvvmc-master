//
//  ResponseFetchable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/10/2023.
//

import CoreData

protocol ResponseFetchable {
    
    func fetchResponse(completion: @escaping (Result<HTTPUserDTO.Response?, CoreDataError>) -> Void)
}
