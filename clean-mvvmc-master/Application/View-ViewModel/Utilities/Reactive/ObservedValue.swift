//
//  Observable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 22/10/2023.
//

import Foundation

protocol Observable {
    
    associatedtype T
    
    var value: T { get }
}

final class ObservedValue<T>: Observable {
    
    private struct Observer {
        
        private(set) weak var observer: AnyObject?
        
        let block: (T) -> Void
    }
    
    private var observers = [Observer]()
    
    var value: T {
        didSet {
            notifyObservers()
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
}

extension ObservedValue {
    
    func observe(on observer: AnyObject, block: @escaping (T) -> Void) {
        let observer = Observer(observer: observer, block: block)
        
        observers.append(observer)
        
        block(value)
    }
    
    func remove(observer: AnyObject) {
        observers = observers.filter { $0.observer !== observer }
    }
    
    private func notifyObservers() {
        for observer in observers {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                observer.block(self.value)
            }
        }
    }
}
