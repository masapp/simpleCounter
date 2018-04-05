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
    
    func bind(title: String, count: Int) {
        titleLabel.text = title
        countLabel.text = String(count)
        plusButtonEnabled(count: count)
        minusButtonEnabled(count: count)
    }
    
    func plus(count: Int) {
        let newCount = count + 1
        countLabel.text = String(newCount)
        plusButtonEnabled(count: newCount)
        minusButtonEnabled(count: newCount)
    }
    
    func minus(count: Int) {
        let newCount = count - 1
        countLabel.text = String(newCount)
        plusButtonEnabled(count: newCount)
        minusButtonEnabled(count: newCount)
    }
    
    private func minusButtonEnabled(count: Int) {
        minusButton.isEnabled = count > 0
    }
    
    private func plusButtonEnabled(count: Int) {
        plusButton.isEnabled = count < 9999
    }
}
