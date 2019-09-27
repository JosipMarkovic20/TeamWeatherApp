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
import RealmSwift


public class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //MARK: TableView DataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataForView?.geonames.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = viewModel.dataForView!.geonames[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "da") as? WeatherTableViewCell {
            cell.backgroundColor = .clear
            cell.setupCell(letter: data.name.first?.uppercased() ?? "s", location: data.name)
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    //MARK: Variables
    let viewModel: SearchViewModel
    var customView: SearchView!
    var searchBar: UISearchBar!
    let disposeBag = DisposeBag()
    var bottomConstraint: NSLayoutConstraint?
    public var closingScreenDelegate: SearchScreenClosingDelegate!
    public weak var coordinatorDelegate: CoordinatorDelegate?
    var loader = LoaderViewController()
    
    var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    public override func viewDidDisappear(_ animated: Bool) {
        coordinatorDelegate?.viewControllerHasFinished()
    }
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
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: viewDidLoad
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        prepareForViewModel()
        bindTextFieldWithRx()
        
    }
    //MARK: ViewDidAppear
    override public func viewDidAppear(_ animated: Bool) {
        setupSearchBar()
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    //MARK: prepare For View Model
    func prepareForViewModel(){
        let input = SearchViewModel.Input(getDataSubject: ReplaySubject<String>.create(bufferSize: 1))
        
        let output = viewModel.transform(input: input)
        
        for disposable in output.disposables {
            disposable.disposed(by: disposeBag)
        }
        
        refreshTableView(subject: output.dataReadySubject).disposed(by: disposeBag)
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        prepareLoader(subject: output.loaderSubject).disposed(by: disposeBag)
    }
    
    //MARK: Did select row at
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.dataForView?.geonames[indexPath.row]
        closingScreenDelegate.screenWillClose(location: LocationsClass(lng: data!.lng, lat: data!.lat, name: data!.name, geoName: data!.geonameId))
        self.dismiss(animated: false) {
        }
    }
    
    //MARK: Loader function
    func prepareLoader(subject: PublishSubject<Bool>) -> Disposable {
        return subject
        .observeOn(MainScheduler.instance)
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background)).subscribe(onNext: { [unowned self] (bool) in
            if bool{
                self.addChild(self.loader)
                self.loader.view.frame = self.view.frame
                self.view.addSubview(self.loader.view)
                self.loader.didMove(toParent: self)
            }else{
                self.loader.willMove(toParent: nil)
                self.loader.view.removeFromSuperview()
                self.loader.removeFromParent()
            }
            }, onError: { (error) in
                print("Error displaying loader ", error)
        })
    }
    deinit {
        print("Deinit: \(self)")
    }
    //MARK: UISettings
    func setupUI(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        tableView.delegate = self
        tableView.dataSource = self
        customView = SearchView(frame: UIScreen.main.bounds, tableView: tableView)
        
        searchBar = customView.searchBar
        searchBar.delegate = self
        cancelButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        view.addSubview(customView)
        view.addSubview(tableView)
        view.addSubview(searchBar)
        view.insertSubview(cancelButton, aboveSubview: tableView)
        tableView.separatorStyle = .none
    
        
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "da")
        setupConstraints()
    }
    
    //MARK: SearchBar setup
    func setupSearchBar(){
        let searchTextField = customView.searchBar.value(forKey: "searchField") as! UITextField
        searchTextField.textAlignment = NSTextAlignment.left
        let image:UIImage = UIImage(named: "search_icon")!
        let imageView:UIImageView = UIImageView.init(image: image)
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(red: 109/255, green: 161/255, blue: 51/255, alpha: 1)
        searchTextField.leftView = nil
        searchTextField.placeholder = "Search"
        searchTextField.rightView = imageView
        searchTextField.rightViewMode = UITextField.ViewMode.always
        
        if let backgroundview = searchTextField.subviews.first {
            backgroundview.layer.cornerRadius = 18;
            backgroundview.clipsToBounds = true;
        }
    }
    //MARK: Constraints setup
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
    //MARK: Animation handle
    @objc func keyboardWillShow(notification: NSNotification){
          UIView.setAnimationsEnabled(true)
              if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                  let keyboardHeight = keyboardFrame.cgRectValue.height
                  
                  let isKeyboardShown = notification.name == UIResponder.keyboardWillShowNotification
                  self.bottomConstraint?.constant = isKeyboardShown ? -keyboardHeight : -60
                  
                  UIView.animate(withDuration: 1) {
                      self.view.layoutIfNeeded()
                  }
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
