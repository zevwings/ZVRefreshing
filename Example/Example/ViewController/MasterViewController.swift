//
//  MasterViewController.swift
//  Example
//
//  Created by zevwings on 2017/7/8.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit
import ZVRefreshing

class MasterViewController: UITableViewController {
    
    var numberOfRows = 20
    
    private var _header: RefreshHeader?
    private var _footer: RefreshFooter?
    
    private var sections = ["UITableView", "UICollectionView"]
    private var rows     = ["默认", "隐藏时间", "隐藏时间和状态", "自定义文字", "动画"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath)
        
        cell.textLabel?.text = rows[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 14.0)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let baseView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 32.0))
        baseView.backgroundColor = UIColor.lightGray
        let label = UILabel(frame: CGRect(x: 12.0, y: 0, width: self.view.frame.width - 36, height: 32.0))
        label.font = .boldSystemFont(ofSize: 14.0)
        label.text = sections[section]
        baseView.addSubview(label)
        return baseView
    }
    
    //  swiftlint:disable function_body_length
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPath = self.tableView.indexPathForSelectedRow
                
        let destViewController = segue.destination as? DetailTableViewController
        let row = indexPath?.row ?? 0
        switch row {
        case 0:
            // 设置标题
            destViewController?.title = self.rows[0]
            
            // 设置Header
            let header = RefreshNormalHeader()
            destViewController?.header = header

            // 设置Footer
            let footer = RefreshBackNormalFooter()
            destViewController?.footer = footer
            break
        case 1:
            // 设置标题
            destViewController?.title = self.rows[1]
            
            // 设置 Header
            let header = RefreshStateHeader()
            header.lastUpdatedTimeLabel.isHidden = true
            destViewController?.header = header
            
            // 设置 Footer
            let footer = RefreshAutoNormalFooter()
            destViewController?.footer = footer
            break
        case 2:
            // 设置标题
            destViewController?.title = self.rows[2]
            
            // 设置 Header
            let header = RefreshNormalHeader()
            header.stateLabel.isHidden = true
            header.lastUpdatedTimeLabel.isHidden = true
            destViewController?.header = header
            
            // 设置 Footer
            let footer = RefreshBackNormalFooter()
            footer.stateLabel.isHidden = true
            destViewController?.footer = footer
            break
        case 3:
            // 设置标题
            destViewController?.title = self.rows[3]
            
            // 设置 Header
            let header = RefreshNormalHeader()
            header.setTitle("下拉后更新...", forState: .idle)
            header.setTitle("释放立即更新...", forState: .pulling)
            header.setTitle("正在刷新数据...", forState: .refreshing)
            
            header.lastUpdatedTimeLabelText = { date in
                
                if let d = date {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    return "最后更新时间：\(formatter.string(from: d))"
                }
                
                return "暂无刷新纪录"
            }
            
            destViewController?.header = header
            
            // 设置 Footer
            let footer = RefreshBackNormalFooter()
            footer.setTitle("上拉加载更多数据...", forState: .idle)
            footer.setTitle("释放立即更新...", forState: .pulling)
            footer.setTitle("正在刷新数据...", forState: .refreshing)
            footer.setTitle("没有数据啦", forState: .noMoreData)
            destViewController?.footer = footer
            
            header.tintColor = .black
            footer.tintColor = .black
            
            break
        case 4:
            destViewController?.title = self.rows[4]
            
            let header = RefreshCustomAnimationHeader()
            destViewController?.header = header
            
            let footer = RefreshBackCustomAnimationFooter()
            destViewController?.footer = footer
            break
        default:
            break
        }
    }
}
