//
//  ChangeLanguageViewController.swift
//  orderAround
//
//  Created by Thiru on 14/03/19.
//  Copyright © 2019 css. All rights reserved.
//

import UIKit

class ChangeLanguageViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageListTableView: UITableView!
    
    // Variable
    var selectedIndex = -1
    
    private var selectedLanguage : Language = .english {
        didSet{
            setLocalization(language: selectedLanguage)
        }
    }
    
    //View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialLoad()
        
    }
}

extension ChangeLanguageViewController {
    
    private func initialLoad() {
        
        languageListTableView.tableFooterView = UIView()
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        if let lang = UserDefaults.standard.value(forKey: Keys.list.language) as? String, let language = Language(rawValue: lang) {
            selectedLanguage = language
        }
        
        titleLabel.text = APPLocalize.localizestring.changeLanguage.localize()
        
    }
    private func switchSettingPage() {
        self.navigationController?.isNavigationBarHidden = true // For Changing backbutton direction on RTL Changes
        guard let transitionView = self.navigationController?.view else {return}
        let settingVc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.BaseTabController)
        UIView.beginAnimations("anim", context: nil)
        UIView.setAnimationDuration(0.8)
        UIView.setAnimationCurve(.easeInOut)
        UIView.setAnimationTransition(selectedLanguage == .arabic ? .flipFromLeft : .flipFromRight, for: transitionView, cache: false)
        self.navigationController?.pushViewController(settingVc, animated: true)
        //self.navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = true
        UIView.commitAnimations()
        if Int.removeNil(navigationController?.viewControllers.count) > 2 {
            self.navigationController?.viewControllers.remove(at: 1)
        }
    }
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: Tableview Datasource and Delegate
// UItableView Datasource
extension ChangeLanguageViewController: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Language.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingPageCell", for: indexPath) as! settingPageCell
        cell.textLabel?.textAlignment = .left
        
        cell.textLabel?.text = Language.allCases[indexPath.row].title.localize()
        cell.accessoryType = selectedLanguage == Language.allCases[indexPath.row] ? .checkmark : .none
        Common.setFont(to: cell.textLabel!)
        
        return cell
    }
    
}

// UItableView Delegate
extension ChangeLanguageViewController: UITableViewDelegate {
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let language = Language.allCases[indexPath.row]
        //   var languageObject = LocalizationEntity()
        //   languageObject.language = language
        //     self.presenter?.post(api: .updateLanguage, data: languageObject.toData()) // Sending selected language to backend
        guard language != self.selectedLanguage else {return}
        self.selectedLanguage = language
        UserDefaults.standard.set(self.selectedLanguage.rawValue, forKey: Keys.list.language)
        self.languageListTableView.reloadRows(at: (0..<Language.allCases.count).map({IndexPath(row: $0, section: 0)}), with: .automatic)
        selectedIndex = indexPath.row
        self.languageListTableView.reloadData()
        self.switchSettingPage()
       
    }
}

class settingPageCell : UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
