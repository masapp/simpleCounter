//
//  ContentCell.swift
//  simpleCounter
//
//  Created by masapp on 2018/04/05.
//  Copyright © 2018 masapp. All rights reserved.
//

import UIKit

class ContentCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var plusButton: UIButton!
    @IBOutlet var minusButton: UIButton!
    @IBOutlet var labelColor: UIView!
    
    // MARK: - internal
    func bind(_ item: Item, index: Int) {
        titleLabel.text = item.title
        countLabel.text = item.count
        
        var colorIndex = index
        while ColorSettings.colorArray.count <= colorIndex {
            colorIndex -= ColorSettings.colorArray.count
        }
        labelColor.backgroundColor = ColorSettings.colorArray[colorIndex]
        
        plusButtonEnabled(count: Int(item.count)!)
        minusButtonEnabled(count: Int(item.count)!)
    }
    
    func updateLabel(count: Int) {
        countLabel.text = String(count)
        plusButtonEnabled(count: count)
        minusButtonEnabled(count: count)
    }
    
    // MARK: - private
    private func minusButtonEnabled(count: Int) {
        minusButton.isEnabled = count > 0
    }
    
    private func plusButtonEnabled(count: Int) {
        plusButton.isEnabled = count < 9999
    }
}
