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
        self.tableView.refreshHeader = nil
        self.tableView.refreshFooter = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = refreshComponentType.title
        
        if refreshComponentType == .normal {
            
            normalHeader = ZVRefreshNormalHeader(refreshHandler: { [weak self] in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 , execute: {
                    
                    self?.normalHeader?.endRefreshing()
                    
                    self?.rows += 16
                    self?.tableView.reloadData()

                })
            })

            normalBackFooter = ZVRefreshBackNormalFooter(target: self, action: #selector(refreshHeaderHandler(_:)))

            normalAutoFooter = ZVRefreshAutoNormalFooter()
            normalAutoFooter?.addTarget(self, action: #selector(refreshHeaderHandler(_:)))

            tableView.refreshHeader = normalHeader
            tableView.refreshFooter = normalBackFooter

        } else if refreshComponentType == .animation {

            animationHeader = ZVRefreshCustomAnimationHeader(refreshHandler: { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 , execute: {
                    self?.animationHeader?.endRefreshing()
                    
                    self?.rows += 16
                    self?.tableView.reloadData()
                })
            })

            animationBackFooter = ZVRefreshBackCustomAnimationFooter(target: self, action: #selector(refreshHeaderHandler(_:)))

            animationAutoFooter = ZVRefreshAutoCustomAnimationFooter()
            animationAutoFooter?.addTarget(self, action: #selector(refreshHeaderHandler(_:)))

            tableView.refreshHeader = animationHeader
            tableView.refreshFooter = animationBackFooter

        } else if refreshComponentType == .diy {

            diyHeader = ZVRefreshArrowIndicatorHeader(refreshHandler: { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 , execute: {
                    self?.diyHeader?.endRefreshing()
                    
                    self?.rows += 16
                    self?.tableView.reloadData()
                })
            })

            diyBackFooter = ZVRefreshBackArrowIndicatorFooter(target: self, action: #selector(refreshHeaderHandler(_:)))

            diyAutoFooter = ZVRefreshAutoArrowIndicatorFooter()
            diyAutoFooter?.addTarget(self, action: #selector(refreshHeaderHandler(_:)))

            tableView.refreshHeader = diyHeader
            tableView.refreshFooter = diyBackFooter
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func refreshHeaderHandler(_ refreshHeader: ZVRefreshHeader?) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 , execute: { [weak self] in
            refreshHeader?.endRefreshing()
            
            self?.rows += 16
            self?.tableView.reloadData()
        })
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            
            switch refreshComponentType {
            case .normal:
                tableView.refreshFooter = normalAutoFooter
                break
            case .animation:
                tableView.refreshFooter = animationAutoFooter
                break
            case .diy:
                tableView.refreshFooter = diyAutoFooter
                break
            }
            
        } else if sender.selectedSegmentIndex == 1 {
            
            switch refreshComponentType {
            case .normal:
                tableView.refreshFooter = normalBackFooter
                break
            case .animation:
                tableView.refreshFooter = animationBackFooter
                break
            case .diy:
                tableView.refreshFooter = diyBackFooter
                break
            }
            
        }
    }
    
    @IBAction func lastUpdatedLabelHiddenValueChanged(_ sender: UISwitch) {
        switch refreshComponentType {
        case .normal:
            normalHeader?.lastUpdatedTimeLabel?.isHidden = !sender.isOn
            normalHeader?.placeSubViews()
            break
        case .animation:
            animationHeader?.lastUpdatedTimeLabel?.isHidden = !sender.isOn
            animationHeader?.placeSubViews()
            break
        case .diy:
            diyHeader?.lastUpdatedTimeLabel?.isHidden = !sender.isOn
            diyHeader?.placeSubViews()
            break
        }
    }
    
    @IBAction func stateLabelHieddenValueChanged(_ sender: UISwitch) {
        
        switch refreshComponentType {
        case .normal:
            normalHeader?.stateLabel?.isHidden = !sender.isOn
            normalHeader?.placeSubViews()
            
            normalAutoFooter?.stateLabel?.isHidden = !sender.isOn
            normalAutoFooter?.placeSubViews()

            normalBackFooter?.stateLabel?.isHidden = !sender.isOn
            normalBackFooter?.placeSubViews()
            
            break
        case .animation:
            animationHeader?.stateLabel?.isHidden = !sender.isOn
            animationHeader?.placeSubViews()

            animationAutoFooter?.stateLabel?.isHidden = !sender.isOn
            animationBackFooter?.stateLabel?.isHidden = !sender.isOn
            break
        case .diy:
            diyHeader?.stateLabel?.isHidden = !sender.isOn
            diyHeader?.placeSubViews()

            diyAutoFooter?.stateLabel?.isHidden = !sender.isOn
            diyBackFooter?.stateLabel?.isHidden = !sender.isOn
            break
        }
        
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

