//
//  BackgroundView.swift
//  TeamWeatherApp
//
//  Created by Josip Marković on 24/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit
import SnapKit



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
        
        backgroundGradient.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }

        bodyImage.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
        }
        
        headerImage.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
        }
    }
}
