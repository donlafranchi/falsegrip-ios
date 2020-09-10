//
//  AddSetVC.swift
//  ExercisesApp
//
//  Created by developer on 9/10/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit

protocol AddSetVCDelegate {
    func cancel()
    func done(_ reps: [Int])
}

class AddSetVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var repes = [6,4,8,0]{
        didSet{
            tableView.reloadData()
        }
    }
    var delegate: AddSetVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func didTapCancel(_ sender: Any) {
        delegate?.cancel()
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        delegate?.done(repes)
    }
    
    @IBAction func didTapAddMore(_ sender: Any) {
        self.repes.append(0)
        self.tableView.scrollToBottom()
    }
    
    @IBAction func didTapMinuse(_ sender: UIButton) {
        
        if self.repes[sender.tag] < 1 {
            return
        }
        
        self.repes[sender.tag] -= 1
    }
    
    @IBAction func didTapPlus(_ sender: UIButton) {
        
         self.repes[sender.tag] += 1
    }
    
}

extension AddSetVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddSetTVCell", for: indexPath) as! AddSetTVCell
        cell.lblSet.text = "\(indexPath.row + 1) Set"
        cell.minuseBtn.isHidden = indexPath.row < repes.count - 1
        cell.plusBtn.isHidden = indexPath.row < repes.count - 1
        cell.lblReps.text = "\(repes[indexPath.row])"
        cell.plusBtn.tag = indexPath.row
        cell.minuseBtn.tag = indexPath.row
        
        if repes[indexPath.row] > 1 {
            cell.lblSub.text = "reps"
        }else{
            cell.lblSub.text = "rep"
        }
        
        if indexPath.row < repes.count - 1{
            cell.lblSet.font = UIFont(name: "Mulish-SemiBold", size: 16)
        }else{
            cell.lblSet.font = UIFont(name: "Mulish-Bold", size: 16)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
