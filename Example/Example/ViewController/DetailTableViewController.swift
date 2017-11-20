//
//  DetailViewController.swift
//  Example
//
//  Created by zevwings on 2017/7/8.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit
import ZVRefreshing

class DetailTableViewController: UITableViewController {

    var header: ZVRefreshHeader?
    var footer: ZVRefreshFooter?
    var rows: Int = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _addBarButton()
       
        // selector, this way is equal to header?.refreshHandler = {}
        header?.addTarget(self, action: #selector(isRefreshingValueChange(_:)), for: .valueChanged)
        self.tableView.refreshHeader = header
        
        // callback
        footer?.refreshHandler = {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.rows += 16
                self.tableView.reloadData()
                if self.rows > 100 {
                    self.tableView.refreshFooter?.endRefreshingWithNoMoreData()
                } else {
                    self.tableView.refreshFooter?.endRefreshing()
                }
            })
        }
        
        self.tableView.refreshFooter = footer
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        cell.textLabel?.text = "Row: \(indexPath.row + 1)　　　Data : \(arc4random())"
        return cell
    }
    
    func refreshAction(_ sender: ZVRefreshComponent) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.tableView.refreshFooter?.isNoMoreData = false
            self.rows = 16
            self.tableView.reloadData()
            self.tableView.refreshHeader?.endRefreshing()

        })
    }
    
    @objc func isRefreshingValueChange(_ sender: ZVRefreshComponent) {
        if sender.isRefreshing {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.tableView.refreshFooter?.isNoMoreData = false
                self.rows = 16
                self.tableView.reloadData()
                self.tableView.refreshHeader?.endRefreshing()
                
            })
        } else {
            
        }
    }
    
    fileprivate func _addBarButton() {
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

extension DetailTableViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

