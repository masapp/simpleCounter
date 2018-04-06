//
//  ContentCell.swift
//  simpleCounter
//
//  Created by 石川 雅之 on 2018/04/05.
//  Copyright © 2018 masapp. All rights reserved.
//

import UIKit

class ContentCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var plusButton: UIButton!
    @IBOutlet var minusButton: UIButton!
    
    func bind(_ item: Item) {
        titleLabel.text = item.title
        countLabel.text = String(item.count)
        plusButtonEnabled(count: item.count)
        minusButtonEnabled(count: item.count)
    }
    
    func plus(count: Int) -> Int {
        let newCount = count + 1
        countLabel.text = String(newCount)
        plusButtonEnabled(count: newCount)
        minusButtonEnabled(count: newCount)
        
        return newCount
    }
    
    func minus(count: Int) -> Int {
        let newCount = count - 1
        countLabel.text = String(newCount)
        plusButtonEnabled(count: newCount)
        minusButtonEnabled(count: newCount)
        
        return newCount
    }
    
    private func minusButtonEnabled(count: Int) {
        minusButton.isEnabled = count > 0
    }
    
    private func plusButtonEnabled(count: Int) {
        plusButton.isEnabled = count < 9999
    }
}
