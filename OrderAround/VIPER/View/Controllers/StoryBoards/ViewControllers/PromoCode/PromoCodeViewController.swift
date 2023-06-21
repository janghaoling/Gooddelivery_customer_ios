//
//  PromoCodeViewController.swift
//  Project
//
//  Created by CSS on 17/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class PromoCodeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelHeader: UILabel!
    weak var delegate: promoCodeApplyDelegate?

    
    var promoCodeData = [PromoCodeEntity]()
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    var emptyData:EmptyDataView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewWillAppearCustom()
    }
   
    @IBAction func backToPreviousScreen(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

//MARK: - Methods

extension PromoCodeViewController {
    
    private func initialLoads() {
        tableView.register(UINib(nibName: XIB.Names.PromoCode, bundle: nil), forCellReuseIdentifier: XIB.Names.PromoCode)
        tableView.separatorStyle = .none
        localize()
        setFont()
    }
    
    private func localize() {
        labelHeader.text = APPLocalize.localizestring.promoCode.localize()
    }
    
    private func setFont() {
        Common.setFont(to: labelHeader)
    }
    
    private func viewWillAppearCustom() {
        
        self.presenter?.get(api: .getPromocode, data: nil)
    }
}

//MARK: UITableView Delegate & UItableView Datasource

extension PromoCodeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.promoCodeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return self.getCell(for: indexPath)
    }
    
    private func getCell(for indexPath:IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: XIB.Names.PromoCode, for: indexPath) as! PromoCode
        cell.labelPromoCodeName.text = self.promoCodeData[indexPath.row].promo_code
        let expireDate = Formatter.shared.formatDateToString(dateString: self.promoCodeData[indexPath.row].expiration ?? "", fromFormat: DateFormat.list.yyyy_mm_dd_HH_MM_ss, toFormat: DateFormat.list.dd_MM_yyyy)
        cell.labelExpiryDate.text = APPLocalize.localizestring.expireOn.localize() + " " + (expireDate ?? "")
        cell.buttonApply.setTitle(APPLocalize.localizestring.apply.localize(), for: .normal)
        cell.buttonApply.addTarget(self, action: #selector(tapApply(_:)), for: .touchUpInside)
        cell.buttonApply.tag = indexPath.row
        return cell
    }
    
    @objc func tapApply(_ sender:UIButton) {
        self.loader.isHidden = false
        var applyPromoCode = ApplyPromoCode()
        applyPromoCode.promocode_id = self.promoCodeData[sender.tag].id
        let userDefaults = UserDefaults.standard
        userDefaults.set(self.promoCodeData[sender.tag].id, forKey: "promoCodeId")
        self.presenter?.get(api: .applyPromocode, data: applyPromoCode.toData())
    }
}


extension PromoCodeViewController:PostViewProtocol {
    func onError(api: Base, message: String, statusCode code: Int) {
        Common.showToast(string: message)
        let userDefaults = UserDefaults.standard
        userDefaults.set(0, forKey: "promoCodeId")
        
    }
    
    func getPromoCode(api: Base, data: [PromoCodeEntity]?) {
        if data?.count == 0 {
            self.tableView.setBackgroundImageAndTitle(imageName: EmptyImage.promoCodeEmpty.rawValue, title: APPLocalize.localizestring.noPromoTitle.localize(), description: APPLocalize.localizestring.noPromoContent.localize())
        }else{
            self.tableView.backgroundView = nil
            self.promoCodeData = data ?? []
            self.tableView.reloadInMainThread()
        }
        
        
    }
    
    func getApplyPromocode(api: Base, data: CartList?) {
        
        Common.showToast(string: APPLocalize.localizestring.promoApplied.localize())
        self.delegate?.setPromoApply(isValue: true)
        self.popOrDismiss(animation: true)
    }
}


protocol promoCodeApplyDelegate: class { 
    func setPromoApply(isValue: Bool)

}
