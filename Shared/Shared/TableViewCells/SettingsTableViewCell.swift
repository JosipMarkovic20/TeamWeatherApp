//
//  SettingsTableViewCell.swift
//  Shared
//
//  Created by Josip Marković on 27/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import Foundation
import UIKit


public class SettingsScreenTableCell: UITableViewCell{
    
    //MARK: Cell elements
    let squareView: UIView = {
        let squareView = UIView()
        squareView.translatesAutoresizingMaskIntoConstraints = false
        squareView.backgroundColor = UIColor(red: 182/255, green: 222/255, blue: 238/255, alpha: 1)
        return squareView
    }()
    
    let letterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GothamRounded-Book", size: 24)
        label.textColor = .white
        label.text = "X"
        return label
    }()
    
    let placeName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GothamRounded-Book", size: 18)
        label.textColor = .white
        return label
    }()
    
    public weak var deleteLocationDelegate: DeleteLocationDelegate?
    public var geonameId: Int?
    
    
    //MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI Setup
    func setupUI(){
        contentView.addSubview(placeName)
        contentView.addSubview(squareView)
        squareView.addSubview(letterLabel)
        
        setupConstraints()
        let deleteGesture = UITapGestureRecognizer(target: self, action:  #selector(deleteLocation))
        self.squareView.addGestureRecognizer(deleteGesture)
    }
    
    @objc func deleteLocation(){
        deleteLocationDelegate?.deleteLocation(geonameId: geonameId ?? 0)
    }
    
    //MARK: Constraints
    func setupConstraints(){
        squareView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3).isActive = true
        squareView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        squareView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        squareView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.contentView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        letterLabel.centerXAnchor.constraint(equalTo: squareView.centerXAnchor).isActive = true
        letterLabel.centerYAnchor.constraint(equalTo: squareView.centerYAnchor).isActive = true
        
        placeName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        placeName.leadingAnchor.constraint(equalTo: squareView.trailingAnchor, constant: 10).isActive = true
    }
    
    public func configureCell(name: String){
        placeName.text = name
    }
    
}
