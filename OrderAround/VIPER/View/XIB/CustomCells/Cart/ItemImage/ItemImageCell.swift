//
//  ItemImageCell.swift
//  Project
//
//  Created by CSS on 22/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class ItemImageCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

   
  
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    var thisWidth:CGFloat = 0
    var itemImage = [Images]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thisWidth = CGFloat(self.collectionView.frame.width)
        pageControl.hidesForSinglePage = true
       
       
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //MARK: - Collectiopn View delegate & Datasource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count = itemImage.count
        pageControl.numberOfPages = count
        pageControl.isHidden = !(count>1)
        return count
    }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XIB.Names.TrendingCell, for: indexPath) as! TrendingCell
           
            cell.trendingProduct.setImage(with: itemImage[indexPath.row].url, placeHolder: #imageLiteral(resourceName: "product_placeholder"))
            return cell
        }
        
        
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            
            return UIEdgeInsetsMake(0, 0, 0, 0)
            
        }
        
        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            
            pageControl.currentPage = indexPath.section
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           
            thisWidth = CGFloat(self.collectionView.frame.width)
            return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
     

    }
    
}
