//
//  HomeScreenViewController.swift
//  TeamWeatherApp
//
//  Created by Josip Marković on 24/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit


class HomeScreenViewController: UIViewController, UISearchBarDelegate{
    
    //MARK: Views
    let homeScreenView: HomeScreenView = {
        let view = HomeScreenView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.searchAndSettingsView.settingsButton.addTarget(self, action: #selector(openSettingsScreen), for: .touchUpInside)
        return view
    }()
    
    
    //MARK: Properties
    let viewModel: HomeScreenViewModel
    
    
    init(viewModel: HomeScreenViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupSearchBar()
    }
    
    //MARK: UI Setup
    func setupUI(){
        self.view.addSubview(homeScreenView)

        homeScreenView.searchAndSettingsView.searchBar.delegate = self
        setupConstraints()
    }
    
    //MARK: Constraints
    func setupConstraints(){
        homeScreenView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        homeScreenView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        homeScreenView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        homeScreenView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

    }


    //MARK: Search bar methods
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        openSearchScreen()
        return false
    }

    func openSearchScreen(){
        print("Open that boi")
    }
    
    func setupSearchBar(){
        let searchTextField = homeScreenView.searchAndSettingsView.searchBar.value(forKey: "searchField") as! UITextField
        searchTextField.textAlignment = NSTextAlignment.left
        let image:UIImage = UIImage(named: "search_icon")!
        let imageView:UIImageView = UIImageView.init(image: image)
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(hex: "#6DA133")
        searchTextField.leftView = nil
        searchTextField.placeholder = "Search"
        searchTextField.rightView = imageView
        searchTextField.rightViewMode = UITextField.ViewMode.always
        
        if let backgroundview = searchTextField.subviews.first {
            backgroundview.layer.cornerRadius = 18;
            backgroundview.clipsToBounds = true;
        }
    }
    
    
    //MARK: Settings screen methods
    
    @objc func openSettingsScreen(){
        print("Open this boi")
    }
}
