//
//  ChatViewController.swift
//  orderAround
//
//  Created by Rajes on 14/02/19.
//  Copyright © 2019 css. All rights reserved.
//

import UIKit


let incommingColor = UIColor.secondary
let outGoingColor = UIColor.darkGray
let messageColor = UIColor.white
let messageFont = UIFont.Regular()
let BubbleLayerName = "BubbleLayer"
let BubbleTag = 100
let placeHolderMessage = "Type a Message"

class ChatViewController: UIViewController {
    
    @IBOutlet weak var chatTabeleView: UITableView!
    
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var textViewContainer: UIView!
    
    var messageDataSource:[MessageDetails]!
    
    
    
    //MARK: - View Controlller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ChatManager.shared.getCurrentRoomChatHistory()
        ChatManager.shared.delegate = self
        tableViewSetup()
        textViewSetup()
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ChatManager.shared.leftFromChatRoom()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        //self.chatTabeleView.frame.origin.y -= 150
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
    
       // let Ypos = (keyboardSize?.height ?? 0 ) + self.textViewContainer.frame.size.height
        UIView.animate(withDuration: 0.2) {
            self.textViewContainer.frame.origin.y -=  keyboardSize?.height ?? 0//Ypos
            let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize?.height ?? 0) - 50 , 0.0)
            self.chatTabeleView.contentInset = contentInsets
            self.chatTabeleView.scrollIndicatorInsets = contentInsets
        }
       
       

    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
         let ypos =  (self.view.frame.size.height - textViewContainer.frame.size.height)
        UIView.animate(withDuration: 0.2) {
            self.textViewContainer.frame.origin.y = ypos
            self.chatTabeleView.contentInset = contentInsets
            self.chatTabeleView.scrollIndicatorInsets = contentInsets
        }
        
    }
    
    func tableViewSetup() {
        chatTabeleView.dataSource = self
        chatTabeleView.register(BubbleMessageCell.self, forCellReuseIdentifier: "cell")
        chatTabeleView.separatorStyle = .none
    }
    
    func textViewSetup(){
        messageTextView.text = placeHolderMessage
        messageTextView.textColor = UIColor.lightGray
        messageTextView.delegate = self
    }
    
    //MARK:- Button Actions
    @IBAction override func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendMessage(sender: UIButton) {
        if messageTextView.text.trimmingCharacters(in: .whitespaces).count > 0 {
            ChatManager.shared.sentMessage(message: messageTextView.text ?? "")
            messageTextView.text = ""
            
        }
    }

}


//MARK:- TextView Delegates

extension ChatViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolderMessage
            textView.textColor = UIColor.lightGray
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
   
}

//MARK:- Message Manager Delegates
extension ChatViewController:ChatProtocol {
    
    func getMessageList(message: [MessageDetails]) {
        self.messageDataSource = message
        chatTabeleView.reloadData()
    }
    
    
}


//MARK:- TableView Delegates
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let messageData = messageDataSource else { return 0 }
        return messageData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BubbleMessageCell
        let messageDetails = messageDataSource[indexPath.row]
        cell.selectionStyle = .none
        cell.resetBubble()
        if messageDetails.type == SenderType.User {
            cell.showOutgoingMessage(text: messageDetails.message ?? "")
        } else {
           cell.showIncomingMessage(text: messageDetails.message ?? "")
        }
       
        return cell
    }
    
    
}

//MARK:- Bubble Message Class & Extension
class BubbleMessageCell:UITableViewCell{}
extension BubbleMessageCell {
    func resetBubble() {
        for bLayer in self.layer.sublayers! {
            if bLayer.name == BubbleLayerName {
                bLayer.removeFromSuperlayer()
            }
        }
        for bubbleLabel in self.subviews {
            if bubbleLabel.tag == BubbleTag{
                bubbleLabel.removeFromSuperview()
            }
        }
    }
    func showOutgoingMessage(text: String) {
        let label =  UILabel()
        label.tag = BubbleTag
        label.numberOfLines = 0
        label.font = messageFont
        label.textColor = messageColor
        label.text = text
        label.textAlignment = .center
        let constraintRect = CGSize(width: 0.66 * self.frame.width,
                                    height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: label.font],
                                            context: nil)
        label.frame.size = CGSize(width: ceil(boundingBox.width),
                                  height: ceil(boundingBox.height))
        
        let bubbleSize = CGSize(width: label.frame.width + 28,
                                height: label.frame.height + 20)
        
        let width = bubbleSize.width
        let height = bubbleSize.height
        let outgoingMessageLayer = CAShapeLayer()
        outgoingMessageLayer.path = getOutGoingBubbleBezierPath(size: bubbleSize).cgPath
        let boxframe = self.frame.size.width - (boundingBox.width + 50)
        outgoingMessageLayer.frame = CGRect(x: boxframe,
                                            y: 0,
                                            width: width,
                                            height: height)
        outgoingMessageLayer.fillColor = outGoingColor.cgColor
        label.frame = outgoingMessageLayer.frame
        outgoingMessageLayer.name = BubbleLayerName
        self.layer.addSublayer(outgoingMessageLayer)
        self.addSubview(label)
    }
    
    func showIncomingMessage(text: String) {
        let label =  UILabel()
        label.tag = BubbleTag
        label.numberOfLines = 0
        label.font = messageFont
        label.textColor = messageColor
        label.text = text
        label.textAlignment = .center
        let constraintRect = CGSize(width: 0.66 * self.frame.width,
                                    height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: label.font],
                                            context: nil)
        label.frame.size = CGSize(width: ceil(boundingBox.width),
                                  height: ceil(boundingBox.height))
        
        let bubbleSize = CGSize(width: label.frame.width + 28,
                                height: label.frame.height + 20)
        
        let width = bubbleSize.width
        let height = bubbleSize.height
        
        let outgoingMessageLayer = CAShapeLayer()
        outgoingMessageLayer.path = getIncommingBubbleBezierPath(size: bubbleSize).cgPath
        outgoingMessageLayer.frame = CGRect(x: 10,
                                            y: 0,
                                            width: width,
                                            height: height)
        outgoingMessageLayer.fillColor = incommingColor.cgColor
        label.frame = outgoingMessageLayer.frame
        outgoingMessageLayer.name = BubbleLayerName
        self.layer.addSublayer(outgoingMessageLayer)
        self.addSubview(label)
    }
    
    
     func getIncommingBubbleBezierPath(size:CGSize) -> UIBezierPath{
        let width = size.width
        let height = size.height
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 22, y: height))
        bezierPath.addLine(to: CGPoint(x: width - 17, y: height))
        bezierPath.addCurve(to: CGPoint(x: width, y: height - 17), controlPoint1: CGPoint(x: width - 7.61, y: height), controlPoint2: CGPoint(x: width, y: height - 7.61))
        bezierPath.addLine(to: CGPoint(x: width, y: 17))
        bezierPath.addCurve(to: CGPoint(x: width - 17, y: 0), controlPoint1: CGPoint(x: width, y: 7.61), controlPoint2: CGPoint(x: width - 7.61, y: 0))
        bezierPath.addLine(to: CGPoint(x: 21, y: 0))
        bezierPath.addCurve(to: CGPoint(x: 4, y: 17), controlPoint1: CGPoint(x: 11.61, y: 0), controlPoint2: CGPoint(x: 4, y: 7.61))
        bezierPath.addLine(to: CGPoint(x: 4, y: height - 11))
        bezierPath.addCurve(to: CGPoint(x: 0, y: height), controlPoint1: CGPoint(x: 4, y: height - 1), controlPoint2: CGPoint(x: 0, y: height))
        bezierPath.addLine(to: CGPoint(x: -0.05, y: height - 0.01))
        bezierPath.addCurve(to: CGPoint(x: 11.04, y: height - 4.04), controlPoint1: CGPoint(x: 4.07, y: height + 0.43), controlPoint2: CGPoint(x: 8.16, y: height - 1.06))
        bezierPath.addCurve(to: CGPoint(x: 22, y: height), controlPoint1: CGPoint(x: 16, y: height), controlPoint2: CGPoint(x: 19, y: height))
        bezierPath.close()
        return bezierPath
    }
    
    private func getOutGoingBubbleBezierPath(size:CGSize) -> UIBezierPath {
        let width = size.width
        let height = size.height
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 10, y: height))
        bezierPath.addLine(to: CGPoint(x: 17, y: height))
        bezierPath.addCurve(to: CGPoint(x: 0, y: height - 17), controlPoint1: CGPoint(x: 7.61, y: height), controlPoint2: CGPoint(x: 0, y: height - 7.61))
        bezierPath.addLine(to: CGPoint(x: 0, y: 17))
        bezierPath.addCurve(to: CGPoint(x: 17, y: 0), controlPoint1: CGPoint(x: 0, y: 7.61), controlPoint2: CGPoint(x: 7.61, y: 0))
        bezierPath.addLine(to: CGPoint(x: width - 21, y: 0))
        bezierPath.addCurve(to: CGPoint(x: width - 4, y: 17), controlPoint1: CGPoint(x: width - 11.61, y: 0), controlPoint2: CGPoint(x: width - 4, y: 7.61))
        bezierPath.addLine(to: CGPoint(x: width - 4, y: height - 11))
        bezierPath.addCurve(to: CGPoint(x: width, y: height), controlPoint1: CGPoint(x: width - 4, y: height - 1), controlPoint2: CGPoint(x: width, y: height))
        bezierPath.addLine(to: CGPoint(x: width + 0.05, y: height - 0.01))
        bezierPath.addCurve(to: CGPoint(x: width - 11.04, y: height - 4.04), controlPoint1: CGPoint(x: width - 4.07, y: height + 0.43), controlPoint2: CGPoint(x: width - 8.16, y: height - 1.06))
        bezierPath.addCurve(to: CGPoint(x: width - 22, y: height), controlPoint1: CGPoint(x: width - 16, y: height), controlPoint2: CGPoint(x: width - 19, y: height))
        bezierPath.close()
        return bezierPath
    }
}
