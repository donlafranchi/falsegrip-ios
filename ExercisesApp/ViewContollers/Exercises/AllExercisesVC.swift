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
import TTGTagCollectionView
import CRNotifications


class AllExercisesVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var workoutBtn: GradientButton!
    @IBOutlet weak var lblSelectedCount: UILabel!
    @IBOutlet weak var selectionView: DropShadowView!
    @IBOutlet weak var tagView: TTGTextTagCollectionView!
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            self.searchBar.searchTextField.textColor = MAIN_COLOR
            self.searchBar.searchTextField.leftView?.tintColor = MAIN_COLOR
            self.searchBar.tintColor = MAIN_COLOR
            self.searchBar.isHidden = true
            self.searchBar.delegate = self
            self.searchBar.searchTextField.delegate = self
        }
    }
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!{
        didSet{
            searchBarHeight.constant = 0
        }
    }
    
    var seletedCount = 0 {
        didSet{
            selectionView.isHidden = seletedCount == 0
            workoutBtn.isHidden = seletedCount == 0
            lblSelectedCount.text = "\(seletedCount) Exercise selected"
        }
    }
    fileprivate var readyForPresentation = false
    var itemCount = 0
    var pageNum = 1
    var nextPage = ""
    var exercises = [Exercise]()
    var filteredExercises = [Exercise]()
    var selectedExercises = [Exercise]()

    var isFromDetail = false
    var categoryField = DropDown()
    var selectedCategory = ""{
        didSet{
            if selectedCategory.isEmpty {
                self.navigationItem.title = "All Exercises"
            }else{
                self.navigationItem.title = "Exercises"
            }
        }
    }
    var query = ""
    var categories: [String] = ["Push","Pull","Legs","Core"]
    override func viewDidLoad() {
        super.viewDidLoad()
        initTagView()
        setupCollectionView()
        getAllExercises()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.showIntro()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

//        if let navigationController = navigationController as? ScrollingNavigationController {
//            navigationController.stopFollowingScrollView()
//        }
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
        tagView.delegate = self
        tagView.addTags(categories)
        
    }
    
    func showIntro(){
        
        if !UserInfo.shared.showOnboarding2{
            DispatchQueue.main.async {
                self.showOnboarding()
            }
        }else{
            if !UserInfo.shared.showOnboarding3 && self.filteredExercises.count > 0{
                DispatchQueue.main.async {
                    self.filteredExercises[0].isSelected = true
                    self.collectionView.reloadItems(at: [IndexPath(item: 0, section: 1)])
                    
                    var count = 0
                    for item in self.filteredExercises {
                        if item.isSelected {
                            count += 1
                        }
                    }
                    self.seletedCount = count
                    self.showOnboarding3()
                }
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
//        self.showHUD()
        let params = [
            "order_by": "-created",
            "active": true,
            "category": selectedCategory,
            "q": query] as [String : Any]
        ApiService.getAllExercises(page: pageNum, params: params) { [self] (success, data) in
//            self.dismissHUD()
            if success {
                if self.pageNum == 1 {
//                    self.seletedCount = 0
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
                    
                    self.collectionView.reloadData()
                    self.collectionView.cr.endHeaderRefresh()
                    self.collectionView.cr.endLoadingMore()
                    
                }else{
                    self.collectionView.cr.endHeaderRefresh()
                    self.collectionView.cr.endLoadingMore()
                    self.collectionView.cr.noticeNoMoreData()
                }
            }else{
                self.pageNum = 1
                self.exercises.removeAll()
                self.filteredExercises.removeAll()
                self.showFailureAlert()
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
        for item in self.selectedExercises {
            if !item.category.isEmpty && !titles.contains(item.category) {
                titles.append(item.category)
            }
            ids.append(item.id)
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
                
                for item in self.filteredExercises {
                    item.isSelected = false
                }
                self.seletedCount = 0
                self.selectedExercises.removeAll()
                self.collectionView.reloadData()
                
                let nc = NotificationCenter.default
                if self.isFromDetail {
                    
                    if let id = data!["id"] as? String {
                        let dict: [String : String] = ["id" : id]
                        nc.post(name: Notification.Name("addToWorkoutNotification"), object: nil,userInfo: dict)
                        nc.post(name: Notification.Name("workoutUpdated"), object: nil)
                    }
                    
                }else{
                    nc.post(name: Notification.Name("WorkoutCreated"), object: nil)
                    CRNotifications.showNotification(textColor: MAIN_COLOR!, backgroundColor: BACKGROUND_COLOR!, image: UIImage(named: "success"), title: "Success!", message: "You successfully created Workout.", dismissDelay: 2.0)
                    
                    if let id = data!["id"] as? String {
                        let vc = self.storyboard?.instantiateViewController(identifier: "WorkoutDetailVC") as! WorkoutDetailVC
                        vc.workoutID = id
                        vc.isFromCreate = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }else{
                self.showFailureAlert()
            }
        }
    }
    
    func showOnboarding(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OnboardingVC2") as! OnboardingVC2
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func showOnboarding3(){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OnboardingVC3") as! OnboardingVC3
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
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
     
            if self.seletedCount > 0 {
                createWorkout()
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
            cell.searchBar.text = query
            cell.searchBar.searchTextField.delegate = self
            return cell
            
        case 1:
            if indexPath.item % 2 == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExercisesCell1", for: indexPath) as! ExercisesCell1
                
                for item in self.selectedExercises {
                    if self.filteredExercises[indexPath.item].id == item.id {
                        self.filteredExercises[indexPath.item].isSelected = true
                        break
                    }
                }
                
                cell.initCell(self.filteredExercises[indexPath.item])
               
                
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExercisesCell2", for: indexPath) as! ExercisesCell2
                
                for item in self.selectedExercises {
                    if self.filteredExercises[indexPath.item].id == item.id {
                        self.filteredExercises[indexPath.item].isSelected = true
                        break
                    }
                }
                
                cell.initCell(self.filteredExercises[indexPath.item])
                
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
            let itemHeight: CGFloat = 0.1
            
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
            self.filteredExercises[indexPath.item].isSelected = !self.filteredExercises[indexPath.item].isSelected
            
            
            for item in self.filteredExercises {
                if item.isSelected {
                    if !self.selectedExercises.contains(item) {
                        self.selectedExercises.append(item)
                    }
                }else{
                    self.selectedExercises.removeAll{ $0.id == item.id}
                }
            }
            self.collectionView.reloadItems(at: [indexPath])
            seletedCount = self.selectedExercises.count
        }else{

        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        guard scrollView === self.collectionView else {
            
            return
        }
        
        self.searchBar.isHidden = false
        self.searchBarHeight.constant = 44
        
        let indexPath = IndexPath(item: 0, section: 0)
        guard let cell = self.collectionView.cellForItem(at: indexPath) as? SearchCollectionViewCell else {
            
            return
        }
        
        guard cell.searchBar.isFirstResponder else {
            
            return
        }
        

//        cell.searchBar.resignFirstResponder()
    }
    
}

extension AllExercisesVC: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.query = searchBar.searchTextField.text!
        self.pageNum = 1
        self.getAllExercises()
        self.view.endEditing(true)
    }
}

extension AllExercisesVC: UITextFieldDelegate{
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.query = ""
        self.pageNum = 1
        self.getAllExercises()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let str = textField.text,
            let textRange = Range(range, in: str) {
            let updatedText = str.replacingCharacters(in: textRange,
                                                       with: string)
           
            self.query = updatedText
            self.pageNum = 1
            self.getAllExercises()
        
        }
        return true
    }
}

extension AllExercisesVC: TTGTextTagCollectionViewDelegate {
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool, tagConfig config: TTGTextTagConfig!) {
        
        for i in 0...self.tagView.allTags()!.count - 1 {
            
            if i != index {
                self.tagView.setTagAt(UInt(i), selected: false)
            }
            
        }
        
        if selected {
            self.selectedCategory = tagText
            self.pageNum = 1
            self.getAllExercises()
        }else{
            self.selectedCategory = ""
            self.pageNum = 1
            self.getAllExercises()
        }
    }
}

extension AllExercisesVC: OnboardingVC2Delegate {
    
    func tapExercise(){
        
        self.filteredExercises[0].isSelected = true
        self.selectedExercises.append(self.filteredExercises[0])
        self.collectionView.reloadItems(at: [IndexPath(item: 0, section: 1)])
        seletedCount = 1
        self.showOnboarding3()
        
    }
    
}

extension AllExercisesVC: OnboardingVC3Delegate {
    func tapStart() {
        self.didTapWorkout(self)
    }
    
}
