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

    var header: RefreshHeader?
    
    var footer: RefreshFooter?
    
    var rows: Int = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()

        header?.refreshHandler = {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.tableView.footer?.isNoMoreData = false
                self.rows = 15
                self.tableView.reloadData()
                self.tableView.header?.endRefreshing()

            })
        }
        self.tableView.header = header
        
        footer?.refreshHandler = {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.rows += 15
                self.tableView.reloadData()
                if self.rows > 100 {
                    self.tableView.footer?.endRefreshingWithNoMoreData()
                } else {
                    self.tableView.footer?.endRefreshing()
                }
            })
        }
        self.tableView.footer = footer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        cell.textLabel?.text = "行数: \(indexPath.row + 1)　　　数据 : \(arc4random())"
        return cell
    }

}
