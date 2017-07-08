// swiftlint:disable trailing_whitespace
//
//  HomeTableViewController.swift
//  Example
//
//  Created by zevwings on 2017/7/5.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit
import ZVRefreshing

class RootTableViewController: UITableViewController {
    
    var numberOfRows = 20
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let footer = RefreshAutoNormalFooter {
//            print("refreshHeader.refreshHandler")
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                print("refreshHeader.endRefreshing()")
//                self.tableView.footer?.endRefreshing()
//                self.numberOfRows += 10
//                self.tableView.reloadData()
//            }
//        }
//        self.tableView.footer = footer
//
//        let refreshHeader = RefreshNormalHeader(frame: .zero)
//        refreshHeader.addTarget(self, action: #selector(self.refreshAction(_:)))
////        refreshHeader.refreshHandler = {
////            print("refreshHeader.refreshHandler")
////            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
////                print("refreshHeader.endRefreshing()")
////                self.numberOfRows = 20
////                refreshHeader.endRefreshing()
////            }
////        }
//        tableView.addSubview(refreshHeader)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath)

        cell.textLabel?.text = "\(indexPath.row)"

        return cell
    }
    
//    func refreshAction(_ sender: RefreshComponent) {
//        
//        print("refreshAction")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            print("refreshAction.endRefreshing")
//            sender.endRefreshing()
//        }
//    }
}
