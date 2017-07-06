//
//  HomeTableViewController.swift
//  Example
//
//  Created by zevwings on 2017/7/5.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import ZVRefreshing

class RootTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let footer = RefreshBackNormalFooter {
            print("refreshHeader.refreshHandler")
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                print("refreshHeader.endRefreshing()")
                self.tableView.footer?.endRefreshing()
            }
        }
        self.tableView.footer = footer        
//        let refreshHeader = RefreshNormalHeader(frame: .zero)
//        refreshHeader.refreshHandler = {
//            print("refreshHeader.refreshHandler")
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                print("refreshHeader.endRefreshing()")
//                refreshHeader.endRefreshing()
//            }
//        }
//        tableView.addSubview(refreshHeader)
//        refreshHeader.beginRefreshing()
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
        return 14
    }
    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath)

        cell.textLabel?.text = "\(indexPath.row)"

        return cell
    }
}
