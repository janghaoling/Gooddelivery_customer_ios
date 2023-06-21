//
//  HelpViewController.swift
//  Project
//
//  Created by CSS on 24/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var labelHelpDesc: UILabel!
    @IBOutlet weak var labelHelpTitle: UILabel!
    @IBOutlet weak var labelItem: UILabel!
    @IBOutlet weak var labelOrder: UILabel!
    @IBOutlet weak var buttonChat: UIButton!
    @IBOutlet weak var buttonDispute: UIButton!
    
    var orderNumber:String?
    var ItemDetail : String?
    var dispute : Dispute?
    var orderID:Int?
    
    private var cancelView : CancelView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
    }
    
    @IBAction func tapChat() {
        ChatManager.shared.setChannelWithChannelID(channelID: "\(orderID ?? 0)")
        let chatVc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ChatViewConroller) as! ChatViewController
        self.navigationController?.pushViewController(chatVc, animated: true)
    }
    @IBAction func tapDispute() {
        if self.cancelView == nil, let cancelView = Bundle.main.loadNibNamed(XIB.Names.CancelView, owner: self, options: [:])?.first as? CancelView {
            cancelView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            self.cancelView = cancelView
            self.cancelView?.setValues(isDispute: true, orderID: orderNumber ?? "", title: dispute?.name ?? "")
            self.view.addSubview(cancelView)
            self.cancelView?.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(0.5),
                           initialSpringVelocity: CGFloat(1.0),
                           options: .allowUserInteraction,
                           animations: {
                            self.cancelView?.transform = .identity },
                           completion: { Void in()  })
            
        }
        self.cancelView?.onClickClose = {
            self.cancelView?.removeFromSuperview()
            self.cancelView = nil
        }
        self.cancelView?.onClickSubmit = { (reason,disputeTitle) in
            
            var dispute = CreateDispute()
            dispute.order_id = self.orderID
            dispute.status = DisputeStatus.CREATED.rawValue
            dispute.description = reason
            dispute.dispute_type = disputeTitle
            dispute.created_by = UserType.user.rawValue
            dispute.created_to = UserType.user.rawValue
            self.presenter?.post(api: .createDispute, data: dispute.toData())
        }
    }
    @IBAction func backToPreviousScreen(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

//MARK: - Methods

extension HelpViewController {
    
    private func initialLoads() {
        setCustomFont()
        localize()
        buttonDispute.addTarget(self, action: #selector(tapDispute), for: .touchUpInside)
        buttonChat.addTarget(self, action: #selector(tapChat), for: .touchUpInside)
        labelItem.textColor = .lightGray
        buttonChat.setTitleColor(.secondary, for: .normal)
        buttonDispute.setTitleColor(.secondary, for: .normal)
        buttonChat.borderColor = .secondary
        buttonChat.borderLineWidth = 1.0
        buttonDispute.borderColor = .secondary
        buttonDispute.borderLineWidth = 1.0
        self.labelOrder.text = self.orderNumber
        self.labelItem.text = self.ItemDetail
        self.labelHelpTitle.text = dispute?.name
    }
    
    func localize() {
        
        buttonDispute.setTitle(APPLocalize.localizestring.dispute.localize(), for: .normal)
        buttonChat.setTitle(APPLocalize.localizestring.chatUs.localize(), for: .normal)
        labelHelpDesc.text = APPLocalize.localizestring.helpDescription.localize()
        
    }
    
    func setCustomFont() {
        
        Common.setFont(to: buttonDispute, isTitle: true, size: 15, fontType: .semiBold)
        Common.setFont(to: buttonChat, isTitle: true, size: 15, fontType: .semiBold)
        Common.setFont(to: labelHelpTitle, isTitle: true, size: 15, fontType: .semiBold)
        Common.setFont(to: labelOrder, isTitle: true, size: 15, fontType: .semiBold)
        Common.setFont(to: labelItem, isTitle: true, size: 14, fontType: .light)
        Common.setFont(to: labelHelpDesc, isTitle: true, size: 15, fontType: .semiBold)
    }
}

extension HelpViewController:PostViewProtocol {
    func onError(api: Base, message: String, statusCode code: Int) {
        Common.showToast(string: message)
    }
    func getOrders(api: Base, data: OrderList?) {
        self.popOrDismiss(animation: true)
    }
    
}
