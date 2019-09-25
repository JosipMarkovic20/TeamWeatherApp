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
    var blurEffectView: UIVisualEffectView!
    
    init(frame: CGRect, tableView: UITableView) {
        self.tableView = tableView
        super.init(frame: frame)
        setupBlur()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        //self.insertSubview(tableView, aboveSubview: blurEffectView)
    }
    
    func setupBlur(){
           let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
           blurEffectView = UIVisualEffectView(effect: blurEffect)
           blurEffectView.frame = self.bounds
           blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           self.addSubview(blurEffectView)
       }
    
    func setupConstraints(){
        
    }
}
