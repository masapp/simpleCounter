//
//  DetailViewController.swift
//  simpleCounter
//
//  Created by masapp on 2018/04/12.
//  Copyright © 2018 masapp. All rights reserved.
//

import UIKit
import GoogleMobileAds

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var bannerView: GADBannerView!
    @IBOutlet var tableView: UITableView!
    
    private let defaults = UserDefaults.standard
    private var content = ""
    private var count = ""
    private var times: [Item] = []
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView.adUnitID = AdSettings.unitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = content
        if let data = defaults.object(forKey: content) as? Data {
            if let times = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Item] {
                self.times = times
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as! DetailCell
        cell.bind(times[indexPath.row], index: indexPath.row)
        return cell
    }
    
    // MARK: - internal
    func setup(item: Item) {
        self.content = item.title
        self.count = item.count
    }
}
