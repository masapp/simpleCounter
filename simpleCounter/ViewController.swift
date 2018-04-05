//
//  ViewController.swift
//  simpleCounter
//
//  Created by 石川 雅之 on 2018/04/05.
//  Copyright © 2018 masapp. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController {

    @IBOutlet var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView.adSize = kGADAdSizeBanner
        bannerView.adUnitID = Constant.unitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

