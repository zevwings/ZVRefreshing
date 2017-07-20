//
//  MasterViewController.swift
//  Example
//
//  Created by zevwings on 2017/7/8.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit
import ZVRefreshing

class MasterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var numberOfRows = 20
    
    private var _header: ZVRefreshHeader?
    private var _footer: ZVRefreshFooter?
    private var _isAutoFooter: Bool = true
    
    @IBOutlet weak var tableView: UITableView!
    
    private var sections = ["UITableView", "UICollectionView"]
    private var rows     = ["默认", "隐藏时间", "隐藏时间和状态", "自定义文字", "动画", "DIY 箭头"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "TableViewTargetCell", for: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "CollectionViewTargetCell", for: indexPath)
        }
        
        cell?.textLabel?.text = rows[indexPath.row]
        cell?.textLabel?.font = .systemFont(ofSize: 14.0)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let baseView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 32.0))
        baseView.backgroundColor = UIColor(white: 222.0 / 255.0, alpha: 1.0)
        let label = UILabel(frame: CGRect(x: 12.0, y: 0, width: self.view.frame.width - 36, height: 32.0))
        label.font = .boldSystemFont(ofSize: 14.0)
        label.text = sections[section]
        baseView.addSubview(label)
        return baseView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPath = self.tableView.indexPathForSelectedRow
                
        let row = indexPath?.row ?? 0
        let section = indexPath?.section ?? 0
        switch row {
        case 0:
            segue.destination.title = self.rows[0]
            
            let header = ZVRefreshNormalHeader()
            var footer: ZVRefreshFooter?
            if _isAutoFooter {
                footer = ZVRefreshAutoNormalFooter()
            } else {
                footer = ZVRefreshBackNormalFooter()
            }

            _set(for: section, viewController: segue.destination, header: header, footer: footer)
            break
        case 1:
            segue.destination.title = self.rows[1]
            
            let header = ZVRefreshNormalHeader()
            header.lastUpdatedTimeLabel.isHidden = true
            
            var footer: ZVRefreshFooter?
            if _isAutoFooter {
                footer = ZVRefreshAutoNormalFooter()
            } else {
                footer = ZVRefreshBackNormalFooter()
            }
            
            _set(for: section, viewController: segue.destination, header: header, footer: footer)
            break
        case 2:
            segue.destination.title = self.rows[2]
            
            let header = ZVRefreshNormalHeader(refreshHandler: { 
                
            })
            header.stateLabel.isHidden = true
            header.lastUpdatedTimeLabel.isHidden = true
            
            var footer: ZVRefreshFooter?
            if _isAutoFooter {
                footer = ZVRefreshAutoNormalFooter()
            } else {
                footer = ZVRefreshBackNormalFooter()
                (footer as? ZVRefreshBackNormalFooter)?.stateLabel.isHidden = true
            }

            _set(for: section, viewController: segue.destination, header: header, footer: footer)
            break
        case 3:
            // 设置标题
            segue.destination.title = self.rows[3]
            
            // 设置 Header
            let header = ZVRefreshNormalHeader()
            
            header.setTitle("下拉后更新...", forState: .idle)
            header.setTitle("释放立即更新...", forState: .pulling)
            header.setTitle("正在刷新数据...", forState: .refreshing)
            header.tintColor = .black
            header.lastUpdatedTimeLabelText = { date in
                
                if let d = date {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    return "最后更新时间：\(formatter.string(from: d))"
                }
                return "暂无刷新纪录"
            }
            
            // 设置 Footer
            if _isAutoFooter {
                
                let footer = ZVRefreshAutoNormalFooter()
                footer.setTitle("上拉加载更多数据...", forState: .idle)
                footer.setTitle("释放立即更新...", forState: .pulling)
                footer.setTitle("正在刷新数据...", forState: .refreshing)
                footer.setTitle("没有数据啦", forState: .noMoreData)
                footer.tintColor = .black
                
                _set(for: section,
                     viewController: segue.destination,
                     header: header, footer: footer)
            } else {
                
                let footer = ZVRefreshBackNormalFooter()
                footer.setTitle("上拉加载更多数据...", forState: .idle)
                footer.setTitle("释放立即更新...", forState: .pulling)
                footer.setTitle("正在刷新数据...", forState: .refreshing)
                footer.setTitle("没有数据啦", forState: .noMoreData)
                footer.tintColor = .black
                
                _set(for: section,
                     viewController: segue.destination,
                     header: header, footer: footer)
            }
            break
        case 4:
            segue.destination.title = self.rows[4]
            
            let header = ZVRefreshCustomAnimationHeader()
            let footer: ZVRefreshFooter?
            if _isAutoFooter {
                footer = ZVRefreshAutoCustomAnimationFooter()
            } else {
                footer = ZVRefreshBackCustomAnimationFooter()
            }
            _set(for: section, viewController: segue.destination, header: header, footer: footer)
            break
        case 5:
            segue.destination.title = self.rows[5]
            
            let header = ZVRefreshDIYHeader()
            let footer: ZVRefreshFooter?
                
            if _isAutoFooter {
                footer = ZVRefreshAutoDIYFooter()
            } else {
                footer = ZVRefreshBackDIYFooter()
            }
            
            _set(for: section, viewController: segue.destination, header: header, footer: footer)

            break
        default:
            break
        }
    }
    
    private func _set(for section: Int,
                      viewController: UIViewController,
                      header: ZVRefreshHeader?,
                      footer: ZVRefreshFooter?) {
        if section == 0 {
            let target = viewController as? DetailTableViewController
            target?.header = header
            target?.footer = footer
        } else {
            let target = viewController as? DetailCollectionViewController
            target?.header = header
            target?.footer = footer
        }
    }
    
    @IBAction func setFooterType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            _isAutoFooter = true
            break
        case 1:
            _isAutoFooter = false
            break
        default:
            break
        }
    }
    
}

extension MasterViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension UINavigationController {
    
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
}
