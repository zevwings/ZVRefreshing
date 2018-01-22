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

    var header: ZVRefreshHeader?
    var footer: ZVRefreshFooter?
    var rows: Int = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        _addBarButton()
        
        header?.refreshHandler = {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.collectionView?.refreshFooter?.isNoMoreData = false
                self.rows = 16
                self.collectionView?.reloadData()
                self.collectionView?.refreshHeader?.endRefreshing()
                
            })
        }
        
        self.collectionView?.refreshHeader = header
        
        footer?.refreshHandler = {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.rows += 16
                self.collectionView?.reloadData()
                if self.rows > 100 {
                    self.collectionView?.refreshFooter?.endRefreshingWithNoMoreData()
                } else {
                    self.collectionView?.refreshFooter?.endRefreshing()
                }
            })
        }
        self.collectionView?.refreshFooter = footer

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

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
    
    func refreshAction(_ sender: ZVRefreshComponent) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.collectionView?.refreshFooter?.isNoMoreData = false
            self.rows = 16
            self.collectionView?.reloadData()
            self.collectionView?.refreshHeader?.endRefreshing()
            
        })
    }
    
    private func _addBarButton() {
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 64, height: 44)
        backButton.titleLabel?.font = .systemFont(ofSize: 14.0)
        backButton.setTitle("Back", for: .normal)
        backButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -24, bottom: 0, right: 0)
        backButton.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
    }
    
    @objc func backAction(_ sender: Any?) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DetailCollectionViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
