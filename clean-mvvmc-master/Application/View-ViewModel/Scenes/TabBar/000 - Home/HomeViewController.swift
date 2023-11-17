//
//  HomeViewController.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import UIKit
import CodeBureau

final class HomeViewController: UIViewController, ViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    
    var viewModel: HomeViewModel!
    
    lazy var dataSource: MediaTableViewDataSource? = createDataSource()
    
    
    deinit {
        debugPrint(.debug, "deinit \(Self.self)")
        
        viewDidDeallocate()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDidBindObservers()
        
        viewModel.fetchData()
        
//        removeSelectedProfile()
    }
    
    func viewDidDeploySubviews() {
        
    }
    
    func viewDidBindObservers() {
        
        viewModel.dataSourceState.observe(on: self) { [weak self] state in
            guard let self = self else {
                return
            }
            
            self.dataSource?.dataSourceDidChange()
        }
    }
    
    func viewDidUnbindObservers() {
        
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.dataSourceState.remove(observer: self)
        
        debugPrint(.success, "Removed `\(Self.self)` observers.")
    }
    
    func viewDidDeallocate() {
        viewDidUnbindObservers()
    }
}


extension HomeViewController {
    
    private func createDataSource() -> MediaTableViewDataSource {
        return MediaTableViewDataSource(tableView, with: viewModel)
    }
    
//    private func createCustomView() {
//        
//        let model = Profile(name: "iOS", image: "person.circle")
//        let customViewModel = CustomViewModel(with: model)
//        
//        customView = CustomView(with: customViewModel)
//            .addToHierarchy(in: customViewContainer)
//            .constraint(to: customViewContainer)
//    }
    
    private func removeSelectedProfile() {
        
        let userResponseStore = AuthResponseStore()
        
        var currentResponse: HTTPUserDTO.Response? = userResponseStore.fetcher.fetchResponse()
        
        let user = currentResponse?.data
        
        user?.selectedProfile = nil
        
        currentResponse?.data = nil
        
        userResponseStore.updater.updateResponse(currentResponse)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            currentResponse?.data = user
            
            userResponseStore.updater.updateResponse(currentResponse)
        }
    }
}


extension UIImage {
    
    func scale(newWidth: CGFloat,
               cornerRadius: CGFloat = 0.0,
               borderWidth: CGFloat = 1.0,
               borderColor: UIColor = .white) -> UIImage {
        guard self.size.width != newWidth else { return self }
        
        let scaleFactor = newWidth / self.size.width
        let newHeight = self.size.height * scaleFactor
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        let roundedRect = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
        let roundedPath = UIBezierPath(roundedRect: roundedRect, cornerRadius: cornerRadius).cgPath
        
        context?.addPath(roundedPath)
        context?.clip()
        
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        context?.setStrokeColor(borderColor.cgColor)
        context?.setLineWidth(borderWidth)
        context?.addPath(roundedPath)
        context?.strokePath()
        
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? self
    }
}
