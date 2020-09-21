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
    var sets = [SetsModel]()
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
    
    func initCell(_ sets: [SetsModel]){
        
        self.sets = sets
        
        self.sets = self.sets.sorted(by: { $0.modified! > $1.modified! })
        
        dayStrs.removeAll()
        setDict.removeAll()
        
        for item in self.sets {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
            let date = dateFormatter.date(from:item.modifiedDate)!
            dateFormatter.dateFormat = "dd EEE"
            let dayStr = dateFormatter.string(from: date)
            
            if setDict.keys.contains(dayStr) {
                
                var reps = setDict[dayStr]
                reps! += item.reps
                setDict[dayStr] = reps
            }else{
                setDict[dayStr] = item.reps
                self.dayStrs.append(dayStr)
            }
        }
        var totalReps = 0
        for item in self.sets {
            totalReps += item.reps
        }
        self.lblTotalReps.text = "\(totalReps)"
        
        self.tableView.reloadData()
        
    }

}

extension HistoryContainerTVCell: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.setDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTVCell", for: indexPath) as! HistoryTVCell
        
        cell.lblDay.text = String(self.dayStrs[indexPath.row].split(separator: " ")[0])
        cell.lblWeekday.text = String(self.dayStrs[indexPath.row].split(separator: " ")[1]).uppercased()
        cell.lblReps.text = "\(self.setDict[dayStrs[indexPath.row]] ?? 0)"
        return cell
    }
    
    
}
