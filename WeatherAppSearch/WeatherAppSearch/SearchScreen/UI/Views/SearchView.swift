//
//  SearchView.swift
//  WeatherAppSearch
//
//  Created by Matej Hetzel on 25/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit

class SearchView: UIView {
    
    let tableView: UITableView!
    
    init(frame: CGRect, tableView: UITableView) {
        self.tableView = tableView
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
    }
}
