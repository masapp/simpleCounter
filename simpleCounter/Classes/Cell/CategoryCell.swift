//
//  CategoryCell.swift
//  simpleCounter
//
//  Created by 石川 雅之 on 2018/04/05.
//  Copyright © 2018 masapp. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet var lable: UILabel!
    
    // MARK: - internal
    func bind(_ text: String) {
        lable.text = text
    }
}
