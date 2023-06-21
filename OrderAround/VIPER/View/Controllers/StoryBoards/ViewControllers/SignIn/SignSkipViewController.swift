//
//  SignSkipViewController.swift
//  Project
//
//  Created by CSS on 08/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class SignSkipViewController: UIViewController {
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var searchLbl: UILabel!
    @IBOutlet weak var futureBookMarkLbl: UILabel!
    @IBOutlet weak var addPlaceLbl: UILabel!
    @IBOutlet weak var resturantAroundYouLbl: UILabel!
    @IBOutlet weak var bookMarkLbl: UILabel!
    @IBOutlet weak var viewMenuLbl: UILabel!
    @IBOutlet weak var jholdRestLbl: UILabel!
    @IBOutlet weak var discoverNewdishLbl: UILabel!
   
    @IBOutlet weak var freshLbl: UILabel!
    @IBOutlet weak var swapView3: UIView!
    @IBOutlet weak var swapView1: UIView!
    @IBOutlet weak var swapView2: UIView!
    @IBOutlet weak var pageButton2: UIButton!
    @IBOutlet weak var pagebutton3: UIButton!
    @IBOutlet weak var pageButton1: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    var swapedIndex: Int = 0
    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet weak var customPageControlView: OnBoardPageViewControl!
    
    @IBOutlet weak var pageIndexView: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        swapView1.isHidden = false
//        swapView2.isHidden = true
//        swapView3.isHidden = true
//
//        pageButton1.backgroundColor = UIColor(hex: "AAAAAA")
//        pageButton2.backgroundColor = UIColor(hex: "FFFFFF")
//        pagebutton3.backgroundColor = UIColor(hex: "FFFFFF")
        
      //  addingSwapGesture()
       // signInButton.isUserInteractionEnabled = true
        localize()
        design()
        customPageControlView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            pageIndexView.subviews.forEach {
                $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
    
    }
    
    func localize() {
        self.skipButton.setTitle( APPLocalize.localizestring.skip.localize(), for: .normal)
       
        self.signInButton.setTitle( APPLocalize.localizestring.signIn.localize(), for: .normal)
        self.signUpButton.setTitle( APPLocalize.localizestring.signUp.localize(), for: .normal)
        
//        self.freshLbl.text = Constants.string.fresh.localize()
//        self.discoverNewdishLbl.text = Constants.string.discoverNewDish.localize() + " " + Constants.string.restaurantsAroundYou.localize()
//        self.jholdRestLbl.text = Constants.string.holdFavRest.localize()
//
//        self.searchLbl.text = Constants.string.search.localize()
//        self.viewMenuLbl.text = Constants.string.viewMenus.localize()
//       // self.resturantAroundYouLbl.text = Constants.string.restaurantsAroundYou.localize()
//
//
//        self.bookMarkLbl.text = Constants.string.bookMark.localize()
//        self.addPlaceLbl.text = Constants.string.addPlcaeWantToVisit.localize()
//        self.futureBookMarkLbl.text = Constants.string.futureBookMark.localize()
    }
    
    func design() {
        Common.setFont(to: skipButton, isTitle: true, size: 18, fontType: .semiBold)
        Common.setFont(to: signInButton, isTitle: true, size: 18, fontType: .semiBold)
         Common.setFont(to: signUpButton, isTitle: true, size: 18, fontType: .semiBold)
        
//          Common.setFont(to: freshLbl, isTitle: true, size: 23, fontType: .semiBold)
//          Common.setFont(to: discoverNewdishLbl, isTitle: true, size: 16, fontType: .semiBold)
//          Common.setFont(to: jholdRestLbl, isTitle: true, size: 16, fontType: .semiBold)
//
//        Common.setFont(to: searchLbl, isTitle: true, size: 23, fontType: .semiBold)
//        Common.setFont(to: discoverNewdishLbl, isTitle: true, size: 16, fontType: .semiBold)
//        Common.setFont(to: jholdRestLbl, isTitle: true, size: 16, fontType: .semiBold)
//
//        Common.setFont(to: bookMarkLbl, isTitle: true, size: 23, fontType: .semiBold)
//        Common.setFont(to: addPlaceLbl, isTitle: true, size: 16, fontType: .semiBold)
//        Common.setFont(to: futureBookMarkLbl, isTitle: true, size: 16, fontType: .semiBold)
        
       
    }
    
    func addingSwapGesture() {
        
        let swipeLeft1 = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwapOnPopUpView))
        swipeLeft1.direction = UISwipeGestureRecognizerDirection.left
        self.swapView1.addGestureRecognizer(swipeLeft1)
        
        let swipeLeft2 = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwapOnPopUpView))
        swipeLeft2.direction = UISwipeGestureRecognizerDirection.left
        self.swapView2.addGestureRecognizer(swipeLeft2)
        
        let swipeLeft3 = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwapOnPopUpView))
        swipeLeft3.direction = UISwipeGestureRecognizerDirection.left
        self.swapView3.addGestureRecognizer(swipeLeft3)
        
        let swipeRight1 = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwapOnPopUpView))
        swipeRight1.direction = UISwipeGestureRecognizerDirection.right
        self.swapView1.addGestureRecognizer(swipeRight1)
        
        let swipeRight2 = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwapOnPopUpView))
        swipeRight2.direction = UISwipeGestureRecognizerDirection.right
        self.swapView2.addGestureRecognizer(swipeRight2)

        let swipeRight3 = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwapOnPopUpView))
        swipeRight3.direction = UISwipeGestureRecognizerDirection.right
        self.swapView3.addGestureRecognizer(swipeRight3)
        
    }
    
    @objc private dynamic func handleSwapOnPopUpView(gesture: UISwipeGestureRecognizer) {
        
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.left:
            
            if swapedIndex == 0 {
                UIView.animate(withDuration: 0.5,
                               delay: 0.1,
                               options: UIViewAnimationOptions.transitionFlipFromBottom,
                               animations: { () -> Void in
                                
                                self.swapView1.isHidden = true
                                self.swapView2.isHidden = false
                                self.swapView3.isHidden = true
                                self.pageButton1.backgroundColor = UIColor(hex: "FFFFFF")
                                self.pageButton2.backgroundColor = UIColor(hex: "AAAAAA")
                                self.pagebutton3.backgroundColor = UIColor(hex: "FFFFFF")
                                self.swapedIndex = 1
                                
                }, completion: { (finished) -> Void in
                    
                })
            } else if swapedIndex == 1 {
                UIView.animate(withDuration: 0.5,
                               delay: 0.1,
                               options: UIViewAnimationOptions.transitionFlipFromBottom,
                               animations: { () -> Void in
                                
                                self.swapView1.isHidden = true
                                self.swapView2.isHidden = true
                                self.swapView3.isHidden = false
                                self.pageButton1.backgroundColor = UIColor(hex: "FFFFFF")
                                self.pageButton2.backgroundColor = UIColor(hex: "FFFFFF")
                                self.pagebutton3.backgroundColor = UIColor(hex: "AAAAAA")
                                self.swapedIndex = 2
                                
                }, completion: { (finished) -> Void in
                    
                })
                
            } else {
                
            }
            
        case UISwipeGestureRecognizerDirection.right:
            
            if swapedIndex == 2 {
                
                UIView.animate(withDuration: 0.5,
                               delay: 0.1,
                               options: UIViewAnimationOptions.transitionFlipFromBottom,
                               animations: { () -> Void in
                            
                                self.swapView1.isHidden = true
                                self.swapView2.isHidden = false
                                self.swapView3.isHidden = true
                                self.pageButton1.backgroundColor = UIColor(hex: "FFFFFF")
                                self.pageButton2.backgroundColor = UIColor(hex: "AAAAAA")
                                self.pagebutton3.backgroundColor = UIColor(hex: "FFFFFF")
                                self.swapedIndex = 1
                                
                }, completion: { (finished) -> Void in
                    
                })
                
            } else if swapedIndex == 1 {
                
                UIView.animate(withDuration: 0.5,
                               delay: 0.1,
                               options: UIViewAnimationOptions.transitionFlipFromBottom,
                               animations: { () -> Void in
                                
                                self.swapView1.isHidden = false
                                self.swapView2.isHidden = true
                                self.swapView3.isHidden = true
                                self.pageButton1.backgroundColor = UIColor(hex: "AAAAAA")
                                self.pageButton2.backgroundColor = UIColor(hex: "FFFFFF")
                                self.pagebutton3.backgroundColor = UIColor(hex: "FFFFFF")
                                self.swapedIndex = 0
                                
                }, completion: { (finished) -> Void in
                    
                })
                
            } else {
                
            }
        default:
            break
        }
    }


    @IBAction func signInClickEvent(_ sender: UIButton) {
        print(#function)
        
        appDelegate.isSkip = false
        let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SignInViewController) as! SignInViewController
        self.navigationController?.pushViewController(vc, animated: true)
//        let signIn = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.SignInViewController) as! SignInViewController
//        self.navigationController?.pushViewController(signIn, animated: true)
        
    }
    
    @IBAction func signUpClickEvent(_ sender: UIButton) {
        print(#function)
        appDelegate.isSkip = false
        let mobileVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.MobileViewController) as! MobileViewController
        self.navigationController?.pushViewController(mobileVC, animated: true)
       
    }
    
    @IBAction func skipclickEvent(_ sender: UIButton) {
        appDelegate.isSkip = true
        let baseHomeVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.BaseTabController)
        self.navigationController?.pushViewController(baseHomeVC, animated: true)
    }
    
}

extension SignSkipViewController : PostViewProtocol {

    func onError(api: Base, message: String, statusCode code: Int) {
        
    }
}

extension SignSkipViewController: OnBoardPageViewDelegate {
    func visibleIndex(index: Int) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: UIViewAnimationOptions.transitionFlipFromBottom,
                       animations: { () -> Void in
                        
                      self.pageIndexView.currentPage = index
                        
        }, completion: { (finished) -> Void in
            
        })
    }
}


