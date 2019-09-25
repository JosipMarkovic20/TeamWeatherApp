//
//  BackgroundView.swift
//  TeamWeatherApp
//
//  Created by Josip Marković on 24/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit




class BackgroundView: UIView{
    
    //MARK: UI Elements
    let bodyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "body_image-clear-day")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let headerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "header_image-clear-day")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let backgroundGradient: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI Setup
    func setupUI(){
        self.addSubview(backgroundGradient)
        self.addSubview(bodyImage)
        self.addSubview(headerImage)
        
        setupConstraints()
    }
    
    //MARK: Constraints
    func setupConstraints(){
        backgroundGradient.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundGradient.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundGradient.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        backgroundGradient.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        bodyImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bodyImage.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bodyImage.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        headerImage.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        headerImage.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        headerImage.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
}
