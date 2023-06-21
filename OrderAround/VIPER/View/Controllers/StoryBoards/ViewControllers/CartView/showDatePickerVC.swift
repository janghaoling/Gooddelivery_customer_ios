//
//  showDatePickerVC.swift
//  orderAround
//
//  Created by CSS on 21/02/19.
//  Copyright © 2019 css. All rights reserved.
//

import UIKit

class showDatePickerVC: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scheduleAtLabel: UILabel!
    weak var delegate: showDatePickerVCDelegate?
    
    var notes = String()
    var useWallet = Int()
    var addressId = Int()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        let strDate = dateFormatter.string(from: DatePicker.date)
        timeLabel.text = strDate
        DatePicker.minimumDate = Date()

    }
    
    @IBAction func dateValueChange(_ sender: Any) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        let strDate = dateFormatter.string(from: DatePicker.date)
        timeLabel.text = strDate
    }
    @IBAction func onDoneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.doneAction(isschedule: true, isscheduleDate: timeLabel.text ?? "", notes: self.notes, useWallet: self.useWallet, addressId: self.addressId)

    }
    
    @IBAction func onDissmissEvent(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
protocol showDatePickerVCDelegate: class {
    func doneAction(isschedule: Bool,isscheduleDate: String,notes: String,useWallet: Int,addressId: Int)

}
