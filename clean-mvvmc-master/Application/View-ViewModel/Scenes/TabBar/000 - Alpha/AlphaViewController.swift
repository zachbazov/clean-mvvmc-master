//
//  AlphaViewController.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import UIKit

class AlphaViewController: UIViewController, ViewController {
    
    var viewModel: AlphaViewModel?
    
    
    @IBOutlet weak var customViewContainer: UIView!
    
    
    var customView: CustomView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCustomView()
        
        let user = UserDTO(email: "qwe@gmail.com", password: "qweqweqwe")
        let request = HTTPUserDTO.Request(user: user)
        MongoService.shared.authService.signIn(request)
    }
}


extension AlphaViewController {
    
    private func createCustomView() {
        let model = Profile(name: "iOS")
        let customViewModel = CustomViewModel(with: model)
        
        customView = CustomView(on: customViewContainer, with: customViewModel)
    }
}
