//
//  CountryCodeController.swift
//  Project
//
//  Created by CSS on 09/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class CountryCodeController: UIViewController {

    
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var countryListTableView: UITableView!
    private var dataSource = [Country]()
    private var filterDataSource = [Country]()
    var countryCode : Bind<Country>? // Send value on completion
    var countryDelegate: countryDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.initialLoads()
        self.countryListTableView.delegate = self
        self.countryListTableView.dataSource = self
        countryListTableView.register(UINib(nibName: XIB.Names.CountryCodeCell, bundle: nil), forCellReuseIdentifier: XIB.Names.CountryCodeCell)
        countryListTableView.separatorStyle = .none
        
        countryLbl.text = APPLocalize.localizestring.countryPickerTitle.localize() 
        Common.setFont(to: countryLbl, isTitle: true, size: 17, fontType: .semiBold)
    }
    
    
    //MARK:- Initial Loads
    
    private func initialLoads(){
        
        self.dataSource = Common.getCountries()
        self.filterDataSource = dataSource
        self.countryListTableView.reloadData()
        self.searchBar.delegate = self
        self.searchBar.becomeFirstResponder()
        self.searchBar.showsCancelButton = true
   
    }
    
    @IBAction func backToPreviousScreen(_ sender: UIButton) {
        
        dismiss(animated:true, completion: nil)
    }
    
}


//MARK: - TableView Delegate & Datasource
extension CountryCodeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterDataSource.count > 0 ? filterDataSource.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = countryListTableView.dequeueReusableCell(withIdentifier: XIB.Names.CountryCodeCell) as! CountryCodeCell
        
        if filterDataSource.count > indexPath.row {
            
            cell.set(values: filterDataSource[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if filterDataSource.count > indexPath.row {
            
            let selectedCountry = filterDataSource[indexPath.row]
            searchBar.text = selectedCountry.name
            dismiss(animated:true, completion: { [weak self] in
                
                self?.countryDelegate.didReceiveUserCountryDetails(countryDetails: selectedCountry)
            })
        }
        
    }
    
    
}

//MARK:- UISearchBarDelegate

extension CountryCodeController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filterDataSource = dataSource.filter({ ($0.name+$0.code+$0.dial_code).lowercased().contains(searchText.lowercased())})
        self.countryListTableView.reloadData()
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
    }
    
}

