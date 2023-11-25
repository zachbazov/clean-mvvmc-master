//
//  TableHeaderView.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/11/2023.
//

import UIKit

final class TableHeaderView: UITableViewHeaderFooterView, Reusable, ViewInstantiable {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var viewModel: TableHeaderViewModel!
    
    func setTitle(_ string: String) {
        titleLabel.text = string
    }
}

struct TableHeaderViewModel {
    let title: String
}
