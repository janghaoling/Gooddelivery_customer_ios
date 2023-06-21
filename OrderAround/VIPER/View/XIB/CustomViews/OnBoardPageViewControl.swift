//
//  OnBoardPageViewControl.swift
//  orderAround
//
//  Created by CSS on 19/01/19.
//  Copyright © 2019 css. All rights reserved.
//

import UIKit

struct WalKThroughData {
    var image: UIImage?
    var title: String?
    var description: String?
}
class OnBoardPageViewControl: UIView {

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var onboardCollectionView: UICollectionView!
    
    var delegate: OnBoardPageViewDelegate!
    
    var dataSource: [WalKThroughData]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    
    }

    private func initialSetup() {
        Bundle.main.loadNibNamed(XIB.Names.PageViewXib, owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(contentView)
        collectionViewBasicSetup()
        
    }
    
    private func collectionViewBasicSetup() {
        dataSource = generateCustomObject()
        onboardCollectionView.register(UINib(nibName: XIB.Names.PageViewCellXib, bundle: Bundle.main), forCellWithReuseIdentifier: ViewXib.ids.PageControlCell)
        onboardCollectionView.dataSource = self
        onboardCollectionView.delegate = self
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = onboardCollectionView.contentOffset
        visibleRect.size = onboardCollectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = onboardCollectionView.indexPathForItem(at: visiblePoint) else { return }
        
        if let _ = delegate {
            delegate.visibleIndex(index: indexPath.row)
        }
    }
    
    private func generateCustomObject() -> [WalKThroughData] {
        var dataList = [WalKThroughData]()
        let fresh = WalKThroughData(image: #imageLiteral(resourceName: "welcome1"), title: APPLocalize.localizestring.fresh.localize(), description: APPLocalize.localizestring.discoverNewDish.localize() + " " +  APPLocalize.localizestring.restaurantsAroundYou.localize())
        let search = WalKThroughData(image: #imageLiteral(resourceName: "welcome2"), title:  APPLocalize.localizestring.search.localize(), description:  APPLocalize.localizestring.viewMenus.localize() + " " +  APPLocalize.localizestring.futureBookMark.localize())
        let bookMark = WalKThroughData(image: #imageLiteral(resourceName: "welcome3"), title:  APPLocalize.localizestring.bookMark.localize(), description:  APPLocalize.localizestring.addPlcaeWantToVisit.localize() + " " +  APPLocalize.localizestring.futureBookMark.localize())
        dataList.append(fresh)
        dataList.append(search)
        dataList.append(bookMark)
        return dataList
    }
}

extension OnBoardPageViewControl: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         guard let data = dataSource else { return 0 }
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewXib.ids.PageControlCell, for: indexPath) as? OnBoardPageViewCell
            else { return UICollectionViewCell() }
        cell.setData(data: dataSource[indexPath.row])
        return cell
        
    }
    
    
}


extension OnBoardPageViewControl: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
   
}

