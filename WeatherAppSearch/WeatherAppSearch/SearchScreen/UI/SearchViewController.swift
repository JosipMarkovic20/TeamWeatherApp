//
//  SearchViewController.swift
//  WeatherAppSearch
//
//  Created by Matej Hetzel on 25/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit
import Shared
import RxSwift
import RxCocoa


class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //MARK: TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataForView?.geonames.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = viewModel.dataForView!.geonames[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "da") as? WeatherTableViewCell {
            cell.backgroundColor = .clear
            cell.setupCell(letter: data.name.first?.uppercased() ?? "s", location: data.name)
            return cell
        }
        return UITableViewCell()
    }
    
    //MARK: Variables
    let viewModel: SearchViewModel
    var customView: SearchView!
    let searchBar: UISearchBar!
    let disposeBag = DisposeBag()
    var bottomConstraint: NSLayoutConstraint?
    
    var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
     let cancelButton: UIButton = {
           let imageView = UIButton()
           imageView.setImage(UIImage(named: "settings_icon"), for: .normal)
           imageView.contentMode = .scaleToFill
           imageView.translatesAutoresizingMaskIntoConstraints = false
           return imageView
       }()
    
    //MARK: init
    init(viewModel: SearchViewModel, searchBar: UISearchBar) {
        self.viewModel = viewModel
        self.searchBar = searchBar
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        setupUI()
        prepareForViewModel()
    }
    
    func prepareForViewModel(){
        let input = SearchViewModel.Input(getDataSubject: ReplaySubject<String>.create(bufferSize: 1))
        
        let output = viewModel.transform(input: input)
        
        for disposable in output.disposables {
            disposable.disposed(by: disposeBag)
        }
        
        refreshTableView(subject: output.dataReadySubject).disposed(by: disposeBag)
        
        viewModel.input.getDataSubject.onNext("virovitica")
    }
    //MARK: UISettings
    func setupUI(){
        
        tableView.delegate = self
        tableView.dataSource = self
        customView = SearchView(frame: UIScreen.main.bounds, tableView: tableView)
        
        cancelButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        view.addSubview(customView)
        view.addSubview(tableView)
        view.addSubview(searchBar)
        view.insertSubview(cancelButton, aboveSubview: tableView)
        tableView.separatorStyle = .none
    
        
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "da")
        setupConstraints()
    }
    
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: view.topAnchor),
            customView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            customView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: searchBar.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        
        bottomConstraint = NSLayoutConstraint(item: searchBar!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -20)
        view.addConstraint(bottomConstraint!)
        
        NSLayoutConstraint.activate([
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            cancelButton.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 10)
        ])
        
    }
    //MARK: Binding function
    func bindTextFieldWithRx(){
        @discardableResult let _ = searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .enumerated()
            .skipWhile({ (index, value) -> Bool in
                return index == 0
            })
            .map({ (index, value) -> String in
                return value
            })
            .debounce(.milliseconds(300), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .bind(to: viewModel.input.getDataSubject)
    }
    //MARK: Action for button
    @objc func buttonPressed(){
        print("dismiss")
        self.dismiss(animated: false) {
        }
    }
    
    //MARK: Refresh Table View
    func refreshTableView(subject: PublishSubject<Bool>) -> Disposable{
        
        return subject
        .observeOn(MainScheduler.instance)
            .subscribeOn(viewModel.dependencies.scheduler)
        .subscribe(onNext: {[unowned self]  bool in
            self.tableView.reloadData()
        })
    }
}
