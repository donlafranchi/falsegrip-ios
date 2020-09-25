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
import CRRefresh

class AllExercisesVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var workoutBtn: GradientButton!
    @IBOutlet weak var lblSelectedCount: UILabel!
    @IBOutlet weak var selectionView: DropShadowView!
    
    var isSelectionMode = true{
        didSet{
            if !isSelectionMode {
                for item in self.filteredExercises {
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
    var filteredExercises = [Exercise]()

    var isFromDetail = false
    var categoryField = DropDown()
    var selectedCategory = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
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
    
    func initView(){
        
        categoryField = DropDown(frame: CGRect(x: 0, y: 0, width: 20, height: 40))
        categoryField.sizeToFit()
        categoryField.text = "All Exercises"
        categoryField.textColor = MAIN_COLOR
        categoryField.arrowColor = MAIN_COLOR!
        categoryField.font = UIFont(name: "Mulish-Bold", size: 18)
        categoryField.isSearchEnable = false
//        categoryField.optionArray = ["push","pull"]
        categoryField.checkMarkEnabled = false
        categoryField.selectedRowColor = COLOR4!
        categoryField.rowHeight = 40
        categoryField.textAlignment = .center
        self.navigationItem.titleView = categoryField
        
        categoryField.didSelect { (category, index, id) in
            
            if index > 0 {
                self.selectedCategory = category
                var exercises: [Exercise] = []
                for item in self.filteredExercises {
                    if item.primary_muscle == category {
                        exercises.append(item)
                    }
                }
                self.filteredExercises = exercises
                self.collectionView.reloadData()
            }else{
                self.filteredExercises = self.exercises
                self.selectedCategory = ""
                self.collectionView.reloadData()
            }
        }
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
                    self.filteredExercises.removeAll()
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
                        self.exercises.append(Exercise(item))
                        self.filteredExercises.append(Exercise(item))
                    }
                    
                    if !self.selectedCategory.isEmpty {
                        var exercises: [Exercise] = []
                        for item in self.filteredExercises {
                            if item.primary_muscle == self.selectedCategory {
                                exercises.append(item)
                            }
                        }
                        self.filteredExercises = exercises
                    }
                    
                    var categories: [String] = []
                    categories.append("All Exercises")
                    for item in self.filteredExercises {
                        if !categories.contains(item.primary_muscle) {
                            categories.append(item.primary_muscle)
                        }
                    }
                    self.categoryField.optionArray = categories
                    
                    self.collectionView.reloadData()
                    self.collectionView.cr.endHeaderRefresh()
                    self.collectionView.cr.endLoadingMore()
                    
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
    
    private func createWorkout(){
        
        self.showHUD()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateTime = dateFormatter.string(from: Date())
        
        var titles = [String]()
        var ids = [String]()
        for item in self.filteredExercises {
            if item.isSelected && !item.primary_muscle.isEmpty {
                titles.append(item.primary_muscle)
            }
            if item.isSelected {
                ids.append(item.id)
            }
        }
        
        var title = ""
        if titles.count > 0 {
            title = titles.joined(separator: "/")
        }
        
        let params = [
            "datetime": dateTime,
            "title": title,
            "body_weight": 0,
            "energy_level": 0,
            "comments": "",
            "exercises":ids] as [String : Any]
        
        ApiService.createWorkout(params: params) { (success, data) in
            self.dismissHUD()
            if success {
                let nc = NotificationCenter.default
                if self.isFromDetail {
                    
                    if let id = data!["id"] as? String {
                        let dict: [String : String] = ["id" : id]
                        nc.post(name: Notification.Name("addToWorkoutNotification"), object: nil,userInfo: dict)
                        nc.post(name: Notification.Name("workoutUpdated"), object: nil)
                    }
                    
                }else{
                    nc.post(name: Notification.Name("WorkoutCreated"), object: nil)
                }
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
                createWorkout()
            }
        }
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
                
                cell.initCell(self.filteredExercises[indexPath.item])
                if !isSelectionMode {
                    cell.imgCheck.isHidden = true
                    cell.overlayView.isHidden  = true
                }
                
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExercisesCell2", for: indexPath) as! ExercisesCell2
                cell.initCell(self.filteredExercises[indexPath.item])
                if !isSelectionMode {
                    cell.overlayView.isHidden = true
                    cell.imgCheck.isHidden = true
                }
                return cell
            }
            
        default:
            return UICollectionViewCell()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
            
        case 0:
            return 1
            
        case 1:
            return self.filteredExercises.count
            
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
            
            return CGSize(width: itemWidth, height: itemHeight)
            
        default:
            return .zero
        }
        
        

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if indexPath.section == 1 {
             if isSelectionMode {
                
                self.filteredExercises[indexPath.item].isSelected = !self.filteredExercises[indexPath.item].isSelected
                self.collectionView.reloadItems(at: [indexPath])
                
                var count = 0
                for item in self.filteredExercises {
                    if item.isSelected {
                        count += 1
                    }
                }
                seletedCount = count
             }else{
                let vc = storyboard?.instantiateViewController(withIdentifier: "ExercisesDetailVC") as! ExercisesDetailVC
                vc.exercise = self.filteredExercises[indexPath.item]
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
