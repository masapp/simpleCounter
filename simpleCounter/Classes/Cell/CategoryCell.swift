//
//  CategoryCell.swift
//  simpleCounter
//
//  Created by 石川 雅之 on 2018/04/05.
//  Copyright © 2018 masapp. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var labelColor: UIView!
    
    private let defaults = UserDefaults.standard
    
    // MARK: - internal
    func bind(_ category: String, index: Int) {
        accessoryType = .disclosureIndicator
        categoryLabel.text = category
        
        var count = 0
        if let data = defaults.object(forKey: category) as? Data {
            if let items = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Item] {
                count = items.count
            }
        }
        countLabel.text = String(count)
        
        labelColor.backgroundColor = ColorSettings.colorArray[index]
    }
}
