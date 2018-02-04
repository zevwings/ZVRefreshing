//
//  DetailViewController.swift
//  Example
//
//  Created by zevwings on 2017/7/8.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit
import ZVRefreshing

class ExamplelTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var rows: Int = 16
    
    var isAutoFooter: Bool = true
    var isStateLabelHidden: Bool = false
    var isLastUpdateLabelHidden: Bool = false
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = refreshComponentType.title
        
        // MARK: - Normal
        if refreshComponentType == .normal {
            
            // MARK: Header
            normalHeader = ZVRefreshNormalHeader(refreshHandler: { [weak self] in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 , execute: {
                    
                    self?.normalHeader?.endRefreshing()
                    
                    self?.rows = 16
                    self?.tableView.reloadData()

                })
            })

            normalHeader?.stateLabel?.isHidden = isStateLabelHidden
            normalHeader?.lastUpdatedTimeLabel?.isHidden = isLastUpdateLabelHidden
            
            // MARK: SetTitile
            normalHeader?.setTitle("下拉开始刷新数据", for: .idle)
            normalHeader?.setTitle("释放开始刷新数据", for: .pulling)
            normalHeader?.setTitle("正在刷新数据", for: .refreshing)
            
            normalHeader?.lastUpdatedTimeLabelText = { date in
                
                guard let _date = date else { return "暂无刷新时间" }
                
                let formmater = DateFormatter()
                formmater.dateFormat = "yyyy-MM-dd"
                return String(format: "刷新时间: %@", formmater.string(from: _date))
                
            }
            
            tableView.refreshHeader = normalHeader
            
            if isAutoFooter {
                
                // MARK: Auto Footer
                normalAutoFooter = ZVRefreshAutoNormalFooter()
                normalAutoFooter?.stateLabel?.isHidden = isStateLabelHidden
                normalAutoFooter?.addTarget(self, action: #selector(refreshFooterHandler(_:)))
                
                // MARK: SetTitile
                normalAutoFooter?.setTitle("点击或上拉加载更多数据" , for: .idle)
                normalAutoFooter?.setTitle("正在刷新数据", for: .refreshing)
                normalAutoFooter?.setTitle("没有更多数据", for: .noMoreData)
                
                tableView.refreshFooter = normalAutoFooter
            } else {
            
                // MARK: Back Footer
                normalBackFooter = ZVRefreshBackNormalFooter(target: self, action: #selector(refreshFooterHandler(_:)))
                normalBackFooter?.stateLabel?.isHidden = isStateLabelHidden
                
                // MARK: SetTitile
                normalBackFooter?.setTitle("上拉加载更多数据", for: .idle)
                normalBackFooter?.setTitle("释放开始加载数据", for: .pulling)
                normalBackFooter?.setTitle("正在刷新数据", for: .refreshing)
                normalBackFooter?.setTitle("没有更多数据", for: .noMoreData)

                tableView.refreshFooter = normalBackFooter
            }

        } else if refreshComponentType == .animation {
        
        // MARK: - Animation
            
            // MARK: Header
            
            animationHeader = ZVRefreshCustomAnimationHeader(refreshHandler: { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 , execute: {
                    self?.animationHeader?.endRefreshing()
                    
                    self?.rows = 16
                    self?.tableView.reloadData()
                })
            })

            animationHeader?.stateLabel?.isHidden = isStateLabelHidden
            animationHeader?.lastUpdatedTimeLabel?.isHidden = isLastUpdateLabelHidden
            tableView.refreshHeader = animationHeader
            
            if isAutoFooter {
                // MARK: Auto Footer
                animationAutoFooter = ZVRefreshAutoCustomAnimationFooter()
                animationAutoFooter?.stateLabel?.isHidden = isStateLabelHidden
                animationAutoFooter?.addTarget(self, action: #selector(refreshFooterHandler(_:)))
                tableView.refreshFooter = animationAutoFooter
            } else {
                // MARK: Back Footer
                animationBackFooter = ZVRefreshBackCustomAnimationFooter(target: self, action: #selector(refreshFooterHandler(_:)))
                animationBackFooter?.stateLabel?.isHidden = isStateLabelHidden
                tableView.refreshFooter = animationBackFooter
            }

        } else if refreshComponentType == .diy {

        // MARK: - DIY
            
            // MARK: Header
            diyHeader = ZVRefreshArrowIndicatorHeader(refreshHandler: { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 , execute: {
                    self?.diyHeader?.endRefreshing()
                    
                    self?.rows = 16
                    self?.tableView.reloadData()
                })
            })
            diyHeader?.stateLabel?.isHidden = isStateLabelHidden
            diyHeader?.lastUpdatedTimeLabel?.isHidden = isLastUpdateLabelHidden
            tableView.refreshHeader = diyHeader

            if isAutoFooter {
                // MARK: Auto Footer
                diyAutoFooter = ZVRefreshAutoArrowIndicatorFooter()
                diyAutoFooter?.stateLabel?.isHidden = isStateLabelHidden
                diyAutoFooter?.addTarget(self, action: #selector(refreshFooterHandler(_:)))
                tableView.refreshFooter = diyAutoFooter
            } else {
                // MARK: Back Footer
                diyBackFooter = ZVRefreshBackArrowIndicatorFooter(target: self, action: #selector(refreshFooterHandler(_:)))
                diyBackFooter?.stateLabel?.isHidden = isStateLabelHidden
                tableView.refreshFooter = diyBackFooter
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func refreshFooterHandler(_ refreshFooter: ZVRefreshFooter?) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 , execute: { [weak self] in
            refreshFooter?.endRefreshing()
            
            self?.rows += 16
            self?.tableView.reloadData()
        })
    }
    
}

extension ExamplelTableViewController: UITableViewDataSource {
    
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
extension ExamplelTableViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

