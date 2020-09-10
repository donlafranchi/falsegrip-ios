//
//  AllExercisesVC.swift
//  ExercisesApp
//
//  Created by developer on 9/8/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import AMScrollingNavbar
import RSKCollectionViewRetractableFirstItemLayout

class AllExercisesVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var workoutBtn: GradientButton!
    @IBOutlet weak var lblSelectedCount: UILabel!
    @IBOutlet weak var selectionView: DropShadowView!
    
    var isSelectionMode = false{
        didSet{
            if !isSelectionMode {
                arrCheck = Array.init(repeating: 0, count: 23)
                seletedCount = 0
            }
        }
    }
    var arrCheck = Array.init(repeating: 0, count: 23){
        didSet{
            collectionView.reloadData()
        }
    }
    var seletedCount = 0 {
        didSet{
            selectionView.isHidden = seletedCount == 0
            lblSelectedCount.text = "\(seletedCount) Exercise selected"
        }
    }
    fileprivate var readyForPresentation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "SearchCollectionViewCell.identifier")
        
        if let collectionViewLayout = self.collectionView.collectionViewLayout as? RSKCollectionViewRetractableFirstItemLayout {

            collectionViewLayout.firstItemRetractableAreaInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 8.0, right: 0.0)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

//        if let navigationController = navigationController as? ScrollingNavigationController {
//            navigationController.stopFollowingScrollView()
//        }
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
    
    @IBAction func didTapBack(_ sender: Any) {
        back()
    }
    
    @IBAction func didTapWorkout(_ sender: Any) {
        
        workoutBtn.isSelected = !workoutBtn.isSelected
        self.isSelectionMode = workoutBtn.isSelected
    }
}

extension AllExercisesVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
  
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
            
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell.identifier", for: indexPath) as! SearchCollectionViewCell
            
            cell.searchBar.delegate = self
            cell.searchBar.searchBarStyle = .minimal
            cell.searchBar.placeholder = "Search"
            
            return cell
            
        case 1:
            if indexPath.item % 2 == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExercisesCell1", for: indexPath) as! ExercisesCell1
                if isSelectionMode {
                    cell.overlayView.isHidden = arrCheck[indexPath.item] == 0
                    cell.imgCheck.isHidden = arrCheck[indexPath.item] == 0
                }else{
                    cell.imgCheck.isHidden = true
                    cell.overlayView.isHidden  = true
                }
                
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExercisesCell2", for: indexPath) as! ExercisesCell2
                if isSelectionMode {
                    cell.overlayView.isHidden = arrCheck[indexPath.item] == 0
                    cell.imgCheck.isHidden = arrCheck[indexPath.item] == 0
                }else{
                    cell.overlayView.isHidden = true
                    cell.imgCheck.isHidden = true
                }
                return cell
            }
            
        default:
            assert(false)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
            
        case 0:
            return 1
            
        case 1:
            return 23
            
        default:
            assert(false)
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
            assert(false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
            
        case 0:
            let itemWidth = collectionView.frame.width
            let itemHeight: CGFloat = 44.0
            
            return CGSize(width: itemWidth, height: itemHeight)
        
        case 1:

            
            let numberOfItemsInLine: CGFloat = 2
            
            let inset = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
            
            let itemWidth = (collectionView.frame.width - inset.left - inset.right) / numberOfItemsInLine
            let itemHeight = itemWidth * 1.8
            
            return CGSize(width: itemWidth, height: itemHeight)
            
        default:
            assert(false)
        }
        
        

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if indexPath.section == 1 {
             if isSelectionMode {
                if self.arrCheck[indexPath.item] == 1 {
                    self.arrCheck[indexPath.item] = 0
                }else{
                    self.arrCheck[indexPath.item] = 1
                }
                let countedSet = NSCountedSet(array: arrCheck)
                seletedCount = countedSet.count(for: 1)
             }else{
                let vc = storyboard?.instantiateViewController(withIdentifier: "ExercisesDetailVC") as! ExercisesDetailVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{

        }
              
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        guard scrollView === self.collectionView else {
            
            return
        }
        
        let indexPath = IndexPath(item: 0, section: 0)
        guard let cell = self.collectionView.cellForItem(at: indexPath) as? SearchCollectionViewCell else {
            
            return
        }
        
        guard cell.searchBar.isFirstResponder else {
            
            return
        }
        
        cell.searchBar.resignFirstResponder()
    }
    
}

extension AllExercisesVC: UISearchBarDelegate{
    
    // MARK: - UISearchBarDelegate
     
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         
//         let oldFilteredNames = self.filteredNames!
//         
//         if searchText.isEmpty {
//             
//             self.filteredNames = self.names
//         }
//         else {
//             
//             self.filteredNames = self.names.filter({ (name) -> Bool in
//                 
//                 return name.hasPrefix(searchText)
//             })
//         }
//         
//         self.collectionView.performBatchUpdates({
//             
//             for (oldIndex, oldName) in oldFilteredNames.enumerated() {
//                 
//                 if self.filteredNames.contains(oldName) == false {
//                     
//                     let indexPath = IndexPath(item: oldIndex, section: 1)
//                     self.collectionView.deleteItems(at: [indexPath])
//                 }
//             }
//             
//             for (index, name) in self.filteredNames.enumerated() {
//                 
//                 if oldFilteredNames.contains(name) == false {
//                     
//                     let indexPath = IndexPath(item: index, section: 1)
//                     self.collectionView.insertItems(at: [indexPath])
//                 }
//             }
//             
//         }, completion: nil)
     }
}
