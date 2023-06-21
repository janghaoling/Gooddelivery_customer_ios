//
//  FeedBackViewController.swift
//  Project
//
//  Created by CSS on 25/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class FeedBackController: UIViewController {
    
    
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBOutlet weak var buttonThree: UIButton!
    @IBOutlet weak var buttonFour: UIButton!
    @IBOutlet weak var buttonFive: UIButton!
    
    @IBOutlet weak var labelFeedback: UILabel!
    @IBOutlet weak var labelSubHeading: UILabel!
    @IBOutlet weak var labelHeading: UILabel!
    
    @IBOutlet weak var labelRatingOne: UILabel!
    @IBOutlet weak var labelRatingTwo: UILabel!
    @IBOutlet weak var labelRatingThree: UILabel!
    @IBOutlet weak var labelRatingFour: UILabel!
    @IBOutlet weak var labelRatingFive: UILabel!
    
    @IBOutlet weak var imageRatingOne: UIImageView!
    @IBOutlet weak var imageRatingTwo: UIImageView!
    @IBOutlet weak var imageRatingThree: UIImageView!
    @IBOutlet weak var imageRatingFour: UIImageView!
    @IBOutlet weak var imageRatingFive: UIImageView!
    
    @IBOutlet weak var textViewRating: UITextView!
    
    @IBOutlet weak var bgview: UIView!
    
    var buttonsCollection=[UIButton]()
    var imageCollection=[UIImageView]()
    var labelCollection = [UILabel]()
    var ratingImage = ["ic_rating_one","ic_rating_two","ic_rating_three","ic_rating_four","ic_rating_five"]
    var ratingString = [APPLocalize.localizestring.terrible.localize(),APPLocalize.localizestring.bad.localize(),APPLocalize.localizestring.okay.localize(),APPLocalize.localizestring.good.localize(),APPLocalize.localizestring.superb.localize()]
    
    weak var delegate: FeedBackPopViewViewControllerDelegate?
    var orderId : Int = 0
    var ratingFeedback:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
        hideKeyboardWhenTappedAround()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        enableKeyboardHandling()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        disableKeyboardHandling()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        for image in imageCollection {
            image.makeRoundedCorner()
        }
    }
    
    
    @IBAction func tapRating(_ sender: UIButton) {
        for button in buttonsCollection {
            print(sender.tag)
            print(button.tag)
            let image = imageCollection[button.tag-1]
            if button.tag == sender.tag {
                image.backgroundColor = .secondary
                image.imageTintColor(color1: .white)
            }else{
                image.backgroundColor = .clear
                image.imageTintColor(color1: .lightGray)
            }
            ratingFeedback = sender.tag
        }
    }
    
    @IBAction func tapSubmit(_ sender: UIButton) {
        //NSDictionary * params = @{@"order_id":orderIdStr,@"rating":feedBackRatingStr,@"comment":self.commentTextView.text,@"type":@"transporter"};
        guard  ratingFeedback != 0 else {
            Common.showToast(string: ErrorMessage.list.chooseFeedback.localize())
            return
        }
        var feedBack = Feedback()
        feedBack.order_id = orderId
        feedBack.rating = ratingFeedback
        feedBack.type = UserType.transporter.rawValue
        feedBack.comment = textViewRating.text
        self.presenter?.post(api: .ratings, data: feedBack.toData())
    }
    
}

//MARK: - Methods

extension FeedBackController {
    
    func initialLoads () {
        setCustomFont()
        localize()
        if let window = (UIApplication.shared.delegate?.window)!  {
            window.backgroundColor = UIColor.clear
        }
//        self.bgview.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.view.backgroundColor = .clear
        buttonsCollection = [self.buttonOne,self.buttonTwo,self.buttonThree,self.buttonFour,self.buttonFive]
        imageCollection = [self.imageRatingOne,self.imageRatingTwo,self.imageRatingThree,self.imageRatingFour,self.imageRatingFive]
        labelCollection = [self.labelRatingOne,self.labelRatingTwo,self.labelRatingThree,self.labelRatingFour,self.labelRatingFive]
        buttonSubmit.backgroundColor = .secondary
        for image in imageCollection {
            let tag = image.tag - 1
            image.image = UIImage(named: ratingImage[tag])
            labelCollection[tag].text = ratingString[tag]
        }
    }
    
    func localize() {
        labelHeading.text = APPLocalize.localizestring.feedback.localize()
        labelSubHeading.text = APPLocalize.localizestring.howWasTheDelivery.localize()
        labelFeedback.text = APPLocalize.localizestring.giveSomeFeedbackinWords.localize()
        buttonSubmit.setTitle(APPLocalize.localizestring.submit.localize(), for: .normal)
    }
    
    func setCustomFont() {
        Common.setFont(to: buttonSubmit, isTitle: true, size: 14, fontType: .semiBold)
        Common.setFont(to: labelFeedback, isTitle: true, size: 14, fontType: .semiBold)
        Common.setFont(to: labelSubHeading, isTitle: true, size: 15, fontType: .semiBold)
        Common.setFont(to: labelHeading, isTitle: true, size: 15, fontType: .semiBold)
        Common.setFont(to: buttonOne, isTitle: false, size: 12, fontType: .regular)
        Common.setFont(to: buttonTwo, isTitle: false, size: 12, fontType: .regular)
        Common.setFont(to: buttonThree, isTitle: false, size: 12, fontType: .regular)
        Common.setFont(to: buttonFour, isTitle: false, size: 12, fontType: .regular)
        Common.setFont(to: buttonFive, isTitle: false, size: 12, fontType: .regular)
        Common.setFont(to: labelRatingOne, isTitle: false, size: 12, fontType: .regular)
        Common.setFont(to: labelRatingTwo, isTitle: false, size: 12, fontType: .regular)
        Common.setFont(to: labelRatingThree, isTitle: false, size: 12, fontType: .regular)
        Common.setFont(to: labelRatingFour, isTitle: false, size: 12, fontType: .regular)
        Common.setFont(to: labelRatingFive, isTitle: false, size: 12, fontType: .regular)
    }
    
    
}


extension FeedBackController : PostViewProtocol {
    func onError(api: Base, message: String, statusCode code: Int) {
        Common.showToast(string: message)
    }
    
    func getRatings(api: Base, data: Message) {
        self.dismiss(animated: true, completion: nil)
        delegate?.FeedBackNextScreen()
    }
}
