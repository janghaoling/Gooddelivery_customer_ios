//
//  CancelReasonViewController.swift
//  Project
//
//  Created by CSS on 24/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class CancelView: UIView {

    @IBOutlet weak var buttonShowDispute: UIButton!
    @IBOutlet weak var tableViewDispute: UITableView!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var textViewCancel: UITextView!
    @IBOutlet weak var labelOrderNumber: UILabel!
    @IBOutlet weak var labelDisputeName: UILabel!
    
    @IBOutlet weak var viewDisputeButton: UIView!
    @IBOutlet weak var imageDown: UIImageView!
    
    var onClickClose : (()->Void)?
    var onClickSubmit : ((String,String)->Void)?
    
    var disputeList = [APPLocalize.localizestring.complained.localize().uppercased(),APPLocalize.localizestring.canceled.localize().uppercased(),APPLocalize.localizestring.refund.localize().uppercased()]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
        self.tableViewDispute.register(UITableViewCell.self, forCellReuseIdentifier: XIB.Names.HelpCell)
        self.tableViewDispute.delegate = self
        self.tableViewDispute.dataSource = self
        self.textViewCancel.delegate = self
        self.tableViewDispute.isHidden = true
        self.textViewCancel.text = APPLocalize.localizestring.enterDesc.localize()
        self.textViewCancel.textColor = .lightGray
        self.buttonShowDispute.setTitleColor(.black, for: .normal)
    }
    
    

    @IBAction func tapCancel() {
        onClickClose?()
    }
    
    @IBAction func tapShowDispute() {
        self.textViewCancel.isHidden = true
        self.tableViewDispute.isHidden = false
        
    }
    
    
    @IBAction func tapSubmit() {
        if textViewCancel.text.isEmpty || textViewCancel.text == APPLocalize.localizestring.enterDesc.localize(){
            Common.showToast(string: ErrorMessage.list.enterReason.localize())
            return
        }
        onClickSubmit?(textViewCancel.text,self.buttonShowDispute.titleLabel?.text ?? "")
    }
    
    func setValues(isDispute:Bool,orderID:String,title:String) {
        DispatchQueue.main.async  {
            self.viewDisputeButton.isHidden = !isDispute
            self.labelOrderNumber.text = orderID
            self.labelDisputeName.text = isDispute ? title :APPLocalize.localizestring.cancelOrder.localize()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textViewCancel.endEditing(true)
    }

}

//MARK :- Methods

extension CancelView {
    private func initialLoads() {
        buttonCancel.setTitleColor(.secondary, for: .normal)
        buttonSubmit.setTitleColor(.secondary, for: .normal)
        buttonSubmit.addTarget(self, action: #selector(tapSubmit), for: .touchUpInside)
        buttonCancel.addTarget(self, action: #selector(tapCancel), for: .touchUpInside)
        buttonShowDispute.addTarget(self, action: #selector(tapShowDispute), for: .touchUpInside)
        buttonSubmit.setTitle(APPLocalize.localizestring.submit.localize().uppercased(), for: .normal)
        buttonCancel.setTitle(APPLocalize.localizestring.Cancel.localize().uppercased(), for: .normal)
        buttonShowDispute.setTitle(APPLocalize.localizestring.complained.localize().uppercased(), for: .normal)
        imageDown.image = UIImage(named: "ic_down_arrow")
        imageDown.imageTintColor(color1: .secondary)
        setCustomFont()
        addShadowToTable()
    }
    
    func setCustomFont() {
        Common.setFont(to: buttonShowDispute, isTitle: true, size: 14, fontType: .regular)
        Common.setFont(to: buttonSubmit, isTitle: true, size: 14, fontType: .semiBold)
        Common.setFont(to: buttonCancel, isTitle: true, size: 14, fontType: .semiBold)
        Common.setFont(to: labelDisputeName, isTitle: true, size: 15, fontType: .semiBold)
        Common.setFont(to: labelOrderNumber, isTitle: true, size: 17, fontType: .bold)
    }
    func addShadowToTable() {
        self.tableViewDispute.layer.shadowColor = UIColor.gray.cgColor
        self.tableViewDispute.layer.shadowOpacity = 0.5
        self.tableViewDispute.layer.shadowOffset = CGSize.zero
        self.tableViewDispute.layer.shadowRadius = 6
        self.tableViewDispute.borderColor = .lightGray
        self.tableViewDispute.borderLineWidth = 1
    }
}

//MARK: - Tableview delegate

extension CancelView:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return disputeList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableViewDispute.dequeueReusableCell(withIdentifier: XIB.Names.HelpCell, for: indexPath)
        cell.textLabel?.text = disputeList[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.selectionStyle = .none
        Common.setFont(to: cell.textLabel ?? UILabel(), isTitle: false, size: 14, fontType: .regular)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.buttonShowDispute.setTitle(disputeList[indexPath.row], for: .normal)
        self.textViewCancel.isHidden = false
        self.tableViewDispute.isHidden = true
    }
}

//MARK:- Textview delegate

extension CancelView:UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == APPLocalize.localizestring.enterDesc.localize() {
            textView.text = ""
        }
        textView.textColor = .black
        return true
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
}
