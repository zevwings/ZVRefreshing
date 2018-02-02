//
//  DetailCollectionViewController.swift
//  Example
//
//  Created by zevwings on 2017/7/10.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit
import ZVRefreshing

private let reuseIdentifier = "DetailCell"

class DetailCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var rows: Int = 16
    
    var refreshComponentType: ZVRefreshComponentType = .normal
    
    deinit {
        print("DetailCollectionViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewFlowLayout.itemSize = .init(width: view.frame.width, height: 88)
        
        self.title = refreshComponentType.title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension DetailCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rows
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = UIColor(white: 222.0 / 255.0, alpha: 1.0)
        return cell
    }
}

extension DetailCollectionViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
