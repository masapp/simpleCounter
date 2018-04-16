//
//  CategoryCell.swift
//  simpleCounter
//
//  Created by masapp on 2018/04/05.
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
        categoryLabel.text = category
        
        var count = 0
        if let data = defaults.object(forKey: category) as? Data {
            if let items = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Item] {
                count = items.count
            }
        }
        countLabel.text = String(count)
        
        var colorIndex = index
        while ColorSettings.colorArray.count <= colorIndex {
            colorIndex -= ColorSettings.colorArray.count
        }
        labelColor.backgroundColor = ColorSettings.colorArray[colorIndex]
    }
}
