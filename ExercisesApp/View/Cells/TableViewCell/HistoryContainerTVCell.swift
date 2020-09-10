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
    let rowCount = 4
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

}

extension HistoryContainerTVCell: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTVCell", for: indexPath) as! HistoryTVCell
        return cell
    }
    
    
}
