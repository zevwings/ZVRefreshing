//
//  DetailViewController.swift
//  Example
//
//  Created by zevwings on 2017/7/8.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit
import ZVRefreshing

class DetailTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var rows: Int = 16
    
    var refreshComponentType: ZVRefreshComponentType = .normal
    
    private var normalHeader: ZVRefreshNormalHeader?
    private var normalBackFooter: ZVRefreshBackNormalFooter?
    private var normalAutoFooter: ZVRefreshAutoNormalFooter?
    
    private var animationHeader: ZVRefreshCustomAnimationHeader?
    private var animationBackFooter: ZVRefreshBackCustomAnimationFooter?
    private var animationAutoFooter: ZVRefreshAutoCustomAnimationFooter?
    
    private var diyHeader: ZVRefreshArrowIndicatorHeader?
    private var diyBackFooter: ZVRefreshBackArrowIndicatorFooter?
    private var diyAutoFooter: ZVRefreshAutoArrowIndicatorFooter?
    
    deinit {
        print("DetailTableViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = refreshComponentType.title
        
        if refreshComponentType == .normal {
            
            normalHeader = ZVRefreshNormalHeader(refreshHandler: { [unowned self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 , execute: {
                    self.normalHeader?.endRefreshing()
                })
            })

//            normalBackFooter = ZVRefreshBackNormalFooter(target: self, action: #selector(refreshHeaderHandler(_:)))

            normalAutoFooter = ZVRefreshAutoNormalFooter()
            normalAutoFooter?.addTarget(self, action: #selector(refreshHeaderHandler(_:)))

            tableView.refreshHeader = normalHeader
            tableView.refreshFooter = normalAutoFooter

        } else if refreshComponentType == .animation {

            animationHeader = ZVRefreshCustomAnimationHeader(refreshHandler: { [unowned self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 , execute: {
                    self.animationHeader?.endRefreshing()
                })
            })

//            animationBackFooter = ZVRefreshBackCustomAnimationFooter(target: self, action: #selector(refreshHeaderHandler(_:)))
//
            animationAutoFooter = ZVRefreshAutoCustomAnimationFooter()
//            animationAutoFooter?.addTarget(self, action: #selector(refreshHeaderHandler(_:)))
//
            tableView.refreshHeader = animationHeader
            tableView.refreshFooter = animationAutoFooter

        } else if refreshComponentType == .diy {

            diyHeader = ZVRefreshArrowIndicatorHeader(refreshHandler: { [unowned self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 , execute: {
                    self.diyHeader?.endRefreshing()
                })
            })

//            diyBackFooter = ZVRefreshBackArrowIndicatorFooter(target: self, action: #selector(refreshHeaderHandler(_:)))
//
            diyAutoFooter = ZVRefreshAutoArrowIndicatorFooter()
//            diyAutoFooter?.addTarget(self, action: #selector(refreshHeaderHandler(_:)))
//
            tableView.refreshHeader = diyHeader
            tableView.refreshFooter = diyAutoFooter
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func refreshHeaderHandler(_ refreshHeader: ZVRefreshHeader) {
//        DispatchQueue.main.async {
//
//        }
    }
    
}

extension DetailTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        
        if indexPath.row < 9 {
            cell.textLabel?.text = "Row: 00\(indexPath.row + 1)    Data : \(arc4random())"
        } else if indexPath.row < 100 {
            cell.textLabel?.text = "Row: 0\(indexPath.row + 1)    Data : \(arc4random())"
        } else {
            cell.textLabel?.text = "Row: \(indexPath.row + 1)    Data : \(arc4random())"
        }
        
        cell.backgroundColor = .white
        return cell
    }
}

// MARK: - Override
extension DetailTableViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

