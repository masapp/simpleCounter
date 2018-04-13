//
//  DetailCell.swift
//  simpleCounter
//
//  Created by 石川 雅之 on 2018/04/12.
//  Copyright © 2018 masapp. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var labelColor: UIView!
    
    private let defaults = UserDefaults.standard
    
    // MARK: - internal
    func bind(_ item: Item, index: Int) {
        dateLabel.text = item.title
        countLabel.text = String(item.count)
        
        var colorIndex = index
        if ColorSettings.colorArray.count <= index {
            colorIndex -= ColorSettings.colorArray.count
        }
        labelColor.backgroundColor = ColorSettings.colorArray[colorIndex]
    }
}
