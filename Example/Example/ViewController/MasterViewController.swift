//
//  MasterViewController.swift
//  Example
//
//  Created by zevwings on 2017/7/8.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit
import ZVRefreshing

enum ZVRefreshComponentType : Int {
    case normal
    case animation
    case diy
}

extension ZVRefreshComponentType {
    var title : String {
        switch self {
        case .normal:
            return "Normal"
        case .animation:
            return "Animation"
        case .diy:
            return "DIY"
        }
    }
}

class MasterViewController: UIViewController {
    
    private var isAutoFooter: Bool = true
    private var isStateLabelHidden: Bool = false
    private var isLastUpdateLabelHidden: Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    
    private var sections = ["UITableView", "UICollectionView"]
    private var rows = ["Default", "Animation", "DIY"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Control Action
    
    @IBAction func setFooterType(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            isAutoFooter = true
            break
        case 1:
            isAutoFooter = false
            break
        default:
            break
        }
    }
    
    @IBAction func setLastUpdatedLabelHidden(_ sender: UISwitch) {
        isLastUpdateLabelHidden = sender.isOn
    }
    
    @IBAction func setStateLabelHidden(_ sender: UISwitch) {
        isStateLabelHidden = sender.isOn
    }
}

// MARK: - UITableViewDataSource

extension MasterViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZVTableCell", for: indexPath)
        cell.textLabel?.text = rows[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 16.0)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MasterViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let titleLabel = UILabel(frame: CGRect(x: 12.0, y: 0, width: self.view.frame.width - 36, height: 44.0))
        titleLabel.font = .boldSystemFont(ofSize: 16.0)
        titleLabel.text = sections[section]
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = UIColor(white: 222.0 / 255.9, alpha: 1.0)
        return titleLabel
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DetailTableViewController") as! DetailTableViewController
            vc.refreshComponentType = ZVRefreshComponentType(rawValue: indexPath.row)!
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 1 {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DetailCollectionViewController") as! DetailCollectionViewController
            vc.refreshComponentType = ZVRefreshComponentType(rawValue: indexPath.row)!
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - Override

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
