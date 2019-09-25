//
//  Loader.swift
//  Shared
//
//  Created by Josip Marković on 25/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit


public class LoaderViewController: UIViewController {
    var loader  = UIActivityIndicatorView(style: .whiteLarge)
    
    public init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.startAnimating()
        view.addSubview(loader)
        
        loader.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loader.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
