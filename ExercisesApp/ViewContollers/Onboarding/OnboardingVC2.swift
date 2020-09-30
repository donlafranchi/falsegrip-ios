//
//  OnboardingVC2.swift
//  ExercisesApp
//
//  Created by developer on 9/30/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import RSKCollectionViewRetractableFirstItemLayout
import TTGTagCollectionView
import SwiftyGif


protocol OnboardingVC2Delegate {
    func tapExercise()
}

class OnboardingVC2: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tagView: TTGTextTagCollectionView!
    @IBOutlet weak var constraint: NSLayoutConstraint!
    @IBOutlet weak var gifView: UIImageView!

    fileprivate var readyForPresentation = false
    var exercise = Exercise()
    var categories: [String] = ["Push","Pull","Legs","Core"]
    var delegate: OnboardingVC2Delegate?


    override func viewDidLoad() {
        super.viewDidLoad()

        initTagView()
        setupCollectionView()
        let gif = try? UIImage(gifName: "up_arrow.gif")
        self.gifView.setGifImage(gif!, loopCount: -1)
    }
    

    
    func initTagView(){
        
        let configure = TTGTextTagConfig()
        configure.textFont = UIFont(name: "Mulish-Medium.ttf", size: 16)
        configure.textColor = UIColor(red: 0.17, green: 0.17, blue: 0.22, alpha: 0.7)
        configure.selectedTextColor = .white
        configure.selectedBackgroundColor = COLOR2
        configure.borderColor = .clear
        configure.cornerRadius = 4
        configure.backgroundColor = UIColor(red: 239.0/255, green: 240.0/255, blue: 239.0/255, alpha: 0.5)
        configure.borderWidth = 0
        configure.extraSpace = CGSize(width: 40, height: 15)
        configure.exactHeight = 32
        configure.shadowColor = .clear
        tagView.defaultConfig = configure
        tagView.scrollDirection = .vertical
        tagView.enableTagSelection = true
        tagView.showsHorizontalScrollIndicator = false
        tagView.horizontalSpacing = 16
        tagView.addTags(categories)
        tagView.isHidden = true
        
    }
    
    func setupCollectionView(){
        
        self.collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "SearchCollectionViewCell.identifier")
        
        if let collectionViewLayout = self.collectionView.collectionViewLayout as? RSKCollectionViewRetractableFirstItemLayout {

            collectionViewLayout.firstItemRetractableAreaInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 8.0, right: 0.0)
        }
       
    }
    
    @IBAction func tapBackground(_ sender: Any) {
        UserInfo.shared.setUserInfo(.showOnboarding2, value: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Layout
    
    internal override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        guard self.readyForPresentation == false else {
            
            return
        }
        
        self.readyForPresentation = true
        
        let searchItemIndexPath = IndexPath(item: 0, section: 0)
        self.collectionView.contentOffset = CGPoint(x: 0.0, y: self.collectionView(self.collectionView, layout: self.collectionView.collectionViewLayout, sizeForItemAt: searchItemIndexPath).height)
    }

}

extension OnboardingVC2: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
            
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell.identifier", for: indexPath) as! SearchCollectionViewCell
            cell.searchBar.searchBarStyle = .minimal
            cell.searchBar.placeholder = "Search"
            
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExercisesCell1", for: indexPath) as! ExercisesCell1
                cell.initCell(exercise)
            return cell
            
        default:
            return UICollectionViewCell()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
            
        case 0:
            return 1
            
        case 1:
            return 1
            
        default:
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 2
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        switch section {

        case 0:
            return UIEdgeInsets.zero

        case 1:
            return UIEdgeInsets.zero

        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
            
        case 0:
            let itemWidth = collectionView.frame.width
            let itemHeight: CGFloat = 1.0
            
            return CGSize(width: itemWidth, height: itemHeight)
        
        case 1:

            
            let numberOfItemsInLine: CGFloat = 2
            
            let inset = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
            
            let itemWidth = (collectionView.frame.width - inset.left - inset.right) / numberOfItemsInLine
            let itemHeight = itemWidth * 1.75
            constraint.constant = itemHeight - 30
            return CGSize(width: itemWidth, height: itemHeight)
            
        default:
            return .zero
        }
        
        

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        UserInfo.shared.setUserInfo(.showOnboarding2, value: true)
        delegate?.tapExercise()
        self.dismiss(animated: true, completion: nil)
    }
}
