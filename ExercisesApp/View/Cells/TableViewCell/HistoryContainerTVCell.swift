//
//  HistoryContainerTVCell.swift
//  ExercisesApp
//
//  Created by developer on 9/9/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit

class HistoryContainerTVCell: UITableViewCell {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTotalReps: UILabel!
    
    let rowCount = 4
    var sets = [[String:Any]]()
    var dayStrs = [String]()
    var setDict = [String: Int]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.frame = CGRect(x: 0, y: tableView.frame.origin.y, width: tableView.frame.width, height: CGFloat(rowCount * 32))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "HistoryTVCell", bundle: nil), forCellReuseIdentifier: "HistoryTVCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initCell(_ sets: [[String: Any]]){
        
        self.sets = sets
        
        if self.sets.count > 1 {
            for i in 0...self.sets.count - 2 {
                
                for j in i+1...self.sets.count - 1  {
                    
                    if Int((self.sets[i].keys.first?.components(separatedBy: " ").first)!)! <= Int((self.sets[j].keys.first?.components(separatedBy: " ").first)!)!{
                        self.sets.swapAt(i, j)
                    }
                }
            }
        }                        
        
        var totalReps = 0
        for item in self.sets {
            
            let reps = item.values.first as! Int
            totalReps += reps
        }
        
        self.lblTotalReps.text = "\(totalReps)"
        
        self.tableView.reloadData()
        
    }

}

extension HistoryContainerTVCell: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTVCell", for: indexPath) as! HistoryTVCell
        
        
        cell.lblDay.text = String(((self.sets[indexPath.row]).keys.first)!.split(separator: " ")[0])
        cell.lblWeekday.text = String(((self.sets[indexPath.row]).keys.first)!.split(separator: " ")[1]).uppercased()
        cell.lblReps.text = "\((self.sets[indexPath.row]).values.first as! Int)"
        return cell
    }
    
    
}
