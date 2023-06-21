//
//  CustomTableViewCell.swift
//  sample
//
//  Created by ARJUN's MacBook Pro on 27/05/18.
//  Copyright © 2018 tranxit. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var InnerTableView: UITableView!
    var listarray = NSArray()
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listarray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewAddressTableViewCell", for: indexPath) as! ViewAddressTableViewCell
        return cell
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
