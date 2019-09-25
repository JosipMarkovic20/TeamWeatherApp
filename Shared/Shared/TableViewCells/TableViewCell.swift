//
//  TableViewCell.swift
//  Shared
//
//  Created by Josip Marković on 25/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit

public class WeatherTableViewCell: UITableViewCell {
    
    let letterLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.textColor = .clear
        view.text = "Letter"
        view.font = UIFont.boldSystemFont(ofSize: 20)
        return view
    }()
    
    let locationLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.boldSystemFont(ofSize: 15)
        view.text = "ASDFAFSDASDASDASDAS"
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            letterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            letterLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            letterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5),
            
            locationLabel.leadingAnchor.constraint(equalTo: letterLabel.trailingAnchor, constant: 10),
            locationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            locationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
