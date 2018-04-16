//
//  Item.swift
//  simpleCounter
//
//  Created by masapp on 2018/04/06.
//  Copyright © 2018 masapp. All rights reserved.
//

import UIKit

class Item: NSObject, NSCoding {
    let title: String
    var count: String
    
    init(title: String, count: Int) {
        self.title = title
        self.count = String(count)
    }
    
    required init(coder decoder: NSCoder) {
        self.title = decoder.decodeObject(forKey: "title") as? String ?? ""
        self.count = decoder.decodeObject(forKey: "count") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(title, forKey: "title")
        coder.encode(count, forKey: "count")
    }
}
