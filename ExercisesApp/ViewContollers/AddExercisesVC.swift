//
//  AddExercisesVC.swift
//  ExercisesApp
//
//  Created by developer on 9/18/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import AMScrollingNavbar
import RSKCollectionViewRetractableFirstItemLayout
import CRRefresh

class AddExercisesVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var workoutBtn: GradientButton!
    @IBOutlet weak var lblSelectedCount: UILabel!
    @IBOutlet weak var selectionView: DropShadowView!
    
    var isSelectionMode = false{
        didSet{
            if !isSelectionMode {
                for item in self.exercises {
                    item.isSelected = false
                }
                self.collectionView.reloadData()
                seletedCount = 0
            }
        }
    }
    var seletedCount = 0 {
        didSet{
            selectionView.isHidden = seletedCount == 0
            lblSelectedCount.text = "\(seletedCount) Exercise selected"
        }
    }
    fileprivate var readyForPresentation = false
    var itemCount = 0
    var pageNum = 1
    var nextPage = ""
    var exercises = [Exercise]()
    var selectedExercises = [Exercise]()
    var workout = WorkoutModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        getAllExercises()
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
    
    func setupCollectionView(){
        
        self.collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "SearchCollectionViewCell.identifier")
        
        if let collectionViewLayout = self.collectionView.collectionViewLayout as? RSKCollectionViewRetractableFirstItemLayout {

            collectionViewLayout.firstItemRetractableAreaInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 8.0, right: 0.0)
        }
        
        collectionView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self?.pageNum = 1
            self?.getAllExercises()
        }

        
        collectionView.cr.addFootRefresh(animator: NormalFooterAnimator()) { [weak self] in
            
            if (self?.exercises.count)! < self!.itemCount {
                self?.getAllExercises()
            }else{
                self!.collectionView.cr.noticeNoMoreData()
            }
             
        }
    }
    
    func getAllExercises(){
        self.showHUD()
        let params = [
            "order_by": "-created"] as [String : Any]
        ApiService.getAllExercises(page: pageNum, params: params) { (success, data) in
            self.dismissHUD()
            if success {
                if self.pageNum == 1 {
                    self.seletedCount = 0
                    self.exercises.removeAll()
                }
                
                if let next = data!["next"] as? String, !next.isEmpty {
                    self.pageNum += 1
                }
                
                if let count = data!["count"] as? Int {
                    self.itemCount = count
                }
                
                if let results = data!["results"] as? [[String:Any]] {
                   
                    if results.count == 0 {
                        self.collectionView.cr.noticeNoMoreData()
                    }else{
                        self.collectionView.cr.resetNoMore()
                    }
                    
                    for item in results {
                        let exerciceItem = Exercise(item)
                        var isContain = false
                        for item1 in self.selectedExercises {
                            if item1.id == exerciceItem.id {
                                isContain = true
                                break
                            }
                        }
                        
                        if !isContain {
                            self.exercises.append(exerciceItem)
                        }                        
                    }                    
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    self.collectionView.cr.endHeaderRefresh()
                    self.collectionView.cr.endLoadingMore()
                    if let next = data!["next"] as? String, !next.isEmpty {
                        self.getAllExercises()
                    }else{
                        self.collectionView.cr.noticeNoMoreData()
                    }
                    

                    
                }else{
                    self.collectionView.cr.endHeaderRefresh()
                    self.collectionView.cr.endLoadingMore()
                    self.collectionView.cr.noticeNoMoreData()
                }
            }else{
                self.collectionView.cr.endHeaderRefresh()
                self.collectionView.cr.endLoadingMore()
                self.collectionView.cr.noticeNoMoreData()
            }
        }
    }
    
    private func addToWorkout(){
        
        self.showHUD()
        
        var ids = [String]()
        
        for item in self.selectedExercises {
            ids.append(item.id)
        }
        
        for item in self.exercises {
            if item.isSelected {
                ids.append(item.id)
            }
        }
        
        let params = [
            "datetime": self.workout.datetime,
            "title": self.workout.title,
            "body_weight": self.workout.body_weight,
            "energy_level": self.workout.energy_level,
            "comments": self.workout.comments,
            "exercises":ids] as [String : Any]
        
        ApiService.updateWorkout(id: self.workout.id,params: params) { (success, data) in
            self.dismissHUD()
            if success {
                let nc = NotificationCenter.default
                nc.post(name: Notification.Name("addToWorkoutNotification"), object: nil)
                nc.post(name: Notification.Name("workoutUpdated"), object: nil)
                self.back()
            }
        }
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
        
        if !self.isSelectionMode {
            self.workoutBtn.isSelected = !self.workoutBtn.isSelected
            self.isSelectionMode = workoutBtn.isSelected
        }else{
            if self.seletedCount == 0 {
                self.workoutBtn.isSelected = !self.workoutBtn.isSelected
                self.isSelectionMode = workoutBtn.isSelected
            }else{
                addToWorkout()
            }
        }
        

    }
}

extension AddExercisesVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
  
    
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
                
                cell.initCell(self.exercises[indexPath.item])
                if !isSelectionMode {
                    cell.imgCheck.isHidden = true
                    cell.overlayView.isHidden  = true
                }
                
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExercisesCell2", for: indexPath) as! ExercisesCell2
                cell.initCell(self.exercises[indexPath.item])
                if !isSelectionMode {
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
            return self.exercises.count
            
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
            let itemHeight: CGFloat = 1.0
            
            return CGSize(width: itemWidth, height: itemHeight)
        
        case 1:

            
            let numberOfItemsInLine: CGFloat = 2
            
            let inset = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
            
            let itemWidth = (collectionView.frame.width - inset.left - inset.right) / numberOfItemsInLine
            let itemHeight = itemWidth * 1.75
            
            return CGSize(width: itemWidth, height: itemHeight)
            
        default:
            assert(false)
        }
        
        

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if indexPath.section == 1 {
             if isSelectionMode {
                
                self.exercises[indexPath.item].isSelected = !self.exercises[indexPath.item].isSelected
                self.collectionView.reloadItems(at: [indexPath])
                
                var count = 0
                for item in self.exercises {
                    if item.isSelected {
                        count += 1
                    }
                }
                seletedCount = count
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

extension AddExercisesVC: UISearchBarDelegate{
    
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