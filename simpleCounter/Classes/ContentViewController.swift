//
//  ContentViewController.swift
//  simpleCounter
//
//  Created by 石川 雅之 on 2018/04/05.
//  Copyright © 2018 masapp. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var bannerView: GADBannerView!
    @IBOutlet var tableView: UITableView!
    
    private let defaults = UserDefaults.standard
    private var category = ""
    private var items: [Item] = []
    private var times: [Item] = []
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView.adUnitID = AdSettings.unitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onTapAddButton))
        navigationItem.rightBarButtonItem = addButton
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backButton
        navigationItem.title = category
        
        if let data = defaults.object(forKey: category) as? Data {
            if let items = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Item] {
                self.items = items
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.setup(item: items[indexPath.row])
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell") as! ContentCell
        cell.bind(items[indexPath.row], index: indexPath.row)
        
        cell.plusButton.addTarget(self, action: #selector(onTapPlus(_:)), for: .touchUpInside)
        cell.minusButton.addTarget(self, action: #selector(onTapMinus(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            defaults.removeObject(forKey: items[indexPath.row].title)
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()
        }
    }
    
    // MARK: - @objc function
    @objc private func onTapAddButton() {
        let alert = UIAlertController(title: "New Contents", message: "Enter a name for this contents", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Save", style: .default, handler: { action -> Void in
            if let textFields = alert.textFields as Array<UITextField>? {
                for textField in textFields {
                    self.addItems(name: textField.text!)
                }
            }
        })
        addAction.isEnabled = false
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        alert.addTextField(configurationHandler: { textField -> Void in
            textField.placeholder = "Name"
            
            NotificationCenter.default.addObserver(
                forName: .UITextFieldTextDidChange,
                object: textField,
                queue: OperationQueue.main,
                using: { _ in
                    let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                    let isEmpty = textCount == 0
                    addAction.isEnabled = !isEmpty
            })
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func onTapPlus(_ sender: UIButton) {
        let cell = sender.superview?.superview as! ContentCell
        guard let row = self.tableView.indexPath(for: cell)?.row else {
            return
        }
        
        var count = Int(items[row].count)!
        count += 1
        items[row].count = String(count)
        cell.updateLabel(count: count)
        
        saveData()
        saveTime(key: items[row].title, count: count)
    }
    
    @objc private func onTapMinus(_ sender: UIButton) {
        let cell = sender.superview?.superview as! ContentCell
        guard let row = self.tableView.indexPath(for: cell)?.row else {
            return
        }
        
        var count = Int(items[row].count)!
        count -= 1
        items[row].count = String(count)
        cell.updateLabel(count: count)
        
        saveData()
        saveTime(key: items[row].title, count: count)
    }
    
    // MARK: - internal
    func setup(category: String) {
        self.category = category
    }
    
    // MARK: - private
    private func saveData() {
        let data = NSKeyedArchiver.archivedData(withRootObject: items)
        defaults.set(data, forKey: category)
        defaults.synchronize()
    }
    
    private func addItems(name: String) {
        let item = Item(title: name, count: 0)
        items.append(item)
        saveData()
        tableView.reloadData()
    }
    
    private func saveTime(key: String, count: Int) {
        if let data = defaults.object(forKey: key) as? Data {
            if let times = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Item] {
                self.times = times
            }
        }
        
        let item = Item(title: getToday(), count: count)
        self.times.insert(item, at: 0)
        let data = NSKeyedArchiver.archivedData(withRootObject: times)
        defaults.set(data, forKey: key)
        defaults.synchronize()
    }
    
    private func getToday() -> String {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .none
        return f.string(from: Date())
    }
}
