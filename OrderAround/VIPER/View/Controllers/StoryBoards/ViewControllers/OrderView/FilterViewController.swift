//
//  FilterViewController.swift
//  Project
//
//  Created by CSS on 23/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

struct FilterItems:Codable {
    var name:String
    var state:Bool
    var id:Int
    var type:String
    
    mutating func changeState(newState:Bool) {
        self.state = newState
    }
    
}


class FilterViewController: UIViewController {

    @IBOutlet weak var applyFilterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var filterTitleLbl: UILabel!
    var showResturantList = [1,2]
    var cusininsList = [1,2,3,4,5,6,7]
    var cellHeight: CGFloat = 45
    var headerHeight: CGFloat = 30
    
    var filterDataSource:[String:[FilterItems]]!
    var appliedFilter:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
        setCustomFont()
        tableView.register(UINib(nibName: XIB.Names.FilterCell, bundle: nil), forCellReuseIdentifier: XIB.Names.FilterCell)
        tableView.separatorStyle = .none
        checkFilterSate()
        appliedFilter = getFilterState()
    }
    
    func localize() {
        applyFilterButton.setTitle(APPLocalize.localizestring.applyFilter.localize(), for: .normal)
        resetButton.setTitle(APPLocalize.localizestring.reset.localize(), for: .normal)
        filterTitleLbl.text = APPLocalize.localizestring.filters.localize()
    }
    
    func setCustomFont() {
        Common.setFont(to: filterTitleLbl, isTitle: true, size: 15, fontType: .semiBold)
        Common.setFont(to: applyFilterButton, isTitle: true, size: 15, fontType: .semiBold)
        Common.setFont(to: resetButton, isTitle: true, size: 14, fontType: .semiBold)
    }
    
    @IBAction func applyFilterClickEvent(_ sender: UIButton) {
        guard let filterData = filterDataSource else {
          return
        }
        saveFilterDetails(data: filterData)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backToPreviousScreen(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func resetTheFilter(_ sender: UIButton) {
        removeFilterDetails()
        var tempArray = [FilterItems]()
        for filterData in filterDataSource {
           let filterValue = filterDataSource[filterData.key]
            for filterItem in filterValue ?? [FilterItems]() {
                let newItem =  FilterItems(name: filterItem.name, state: false, id: filterItem.id, type: filterItem.type)
                  tempArray.append(newItem)
            }
          
        }
        filterDataSource = Dictionary(grouping: tempArray, by: {$0.type})
        //changeFilterState(enable: false)
        checkFilterSate()
        tableView.reloadData()
        
    }

    //MARK: - Filter Logics
    func getFilterState() -> Bool {
        for filter in filterDataSource {
            let filterd = filter.value.filter({$0.state == true})
            if filterd.count > 0 {
                return true
            }
        }
        return false
    }
    
    func checkFilterSate () {
        if getFilterState() {
           changeFilterState(enable: true)
        } else {
            if appliedFilter {
                changeFilterState(enable: true)
            } else {
                changeFilterState(enable: false)
            }
           
        }
    }
    
    func changeFilterState(enable:Bool) {
        resetButton.isUserInteractionEnabled = enable
        applyFilterButton.isUserInteractionEnabled = enable
        resetButton.alpha = (enable == true) ? 1.0 : 0.5
        applyFilterButton.alpha = resetButton.alpha
        applyFilterButton.superview?.alpha = applyFilterButton.alpha
    }
}


//MARK: UITableViewDelegate & UITableViewDataSource

extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = Array(filterDataSource.values)[section]
        return data.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let data = filterDataSource else { return 0 }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return cellHeight
        case 1:
            return cellHeight
        default:
            return 0
        }
    }
    
    func  tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            return headerHeight
        case 1:
            return headerHeight
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: headerHeight)
        headerView.backgroundColor = .white
        let headerLbl = UILabel()
        headerLbl.frame = CGRect(x: 15, y: 5, width: tableView.frame.width - (2 * 15), height: 20)
        Common.setFont(to: headerLbl, size : 12, fontType : FontCustom.light)
        let data = Array(filterDataSource.keys)[section]
        headerLbl.text = data//APPLocalize.Cuisines.localized
        headerLbl.textColor = UIColor.black
        headerLbl.textColor = UIColor.lightGray
        headerLbl.textAlignment = .left
        headerView.addSubview(headerLbl)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.FilterCell, for: indexPath) as! FilterCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        let filterObject = Array(filterDataSource.values)[indexPath.section][indexPath.row]
        cell.titleLabel.text = filterObject.name.capitalizingFirstLetter()
        cell.selectButton.isSelected = filterObject.state
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dicKey = Array(filterDataSource)[indexPath.section].key
        let value = Array(filterDataSource)[indexPath.section].value[indexPath.row]
        filterDataSource[dicKey]?[indexPath.row] = FilterItems(name: value.name, state: !value.state, id: value.id, type: dicKey)
        checkFilterSate()
        tableView.reloadData()
    }
}

