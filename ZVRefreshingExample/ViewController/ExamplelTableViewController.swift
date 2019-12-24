//
//  DetailViewController.swift
//  Example
//
//  Created by zevwings on 2017/7/8.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit
import ZVRefreshing

/**
 RxSwift support @see ZVRefreshing+Rx.swift
 import RxSwift
 import RxCocoa
 */

class ExamplelTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var rows: Int = 16
    
    var isAutoFooter: Bool = true
    var isStateLabelHidden: Bool = false
    var isLastUpdateLabelHidden: Bool = false
    var refreshComponentType: ZVRefreshControlType = .flat
    
    private var flatHeader: ZVRefreshFlatHeader?
    private var flatBackFooter: ZVRefreshBackFlatFooter?
    private var flatAutoFooter: ZVRefreshAutoFlatFooter?
    
    private var animationHeader: ZVRefreshCustomAnimationHeader?
    private var animationBackFooter: ZVRefreshBackCustomAnimationFooter?
    private var animationAutoFooter: ZVRefreshAutoCustomAnimationFooter?
    
    private var nativeHeader: ZVRefreshNativeHeader?
    private var nativeBackFooter: ZVRefreshBackNativeFooter?
    private var nativeAutoFooter: ZVRefreshAutoNativeFooter?
    
    /**
    private var disposeBag = DisposeBag()
    */
    
    deinit {
        tableView.removeRefreshControl()
        print("ExamplelTableViewController : \(#function)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = refreshComponentType.title
        
        // MARK: - Normal
        if refreshComponentType == .flat {
            
            // MARK: Header
            flatHeader = ZVRefreshFlatHeader(refreshHandler: { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 , execute: {
                    self?.flatHeader?.endRefreshing()
                    self?.rows = 16
                    self?.tableView.reloadData()
                })
            })

            flatHeader?.stateLabel?.isHidden = isStateLabelHidden
            flatHeader?.lastUpdatedTimeLabel?.isHidden = isLastUpdateLabelHidden
            
            // MARK: SetTitile
            flatHeader?.setTitle("下拉开始刷新数据", for: .idle)
            flatHeader?.setTitle("释放开始刷新数据", for: .pulling)
            flatHeader?.setTitle("正在刷新数据", for: .refreshing)
            
            flatHeader?.lastUpdatedTimeLabelText = { date in
                
                guard let _date = date else { return "暂无刷新时间" }
                
                let formmater = DateFormatter()
                formmater.dateFormat = "yyyy-MM-dd"
                return String(format: "刷新时间: %@", formmater.string(from: _date))
                
            }
            
            tableView.refreshHeader = flatHeader
            
            if isAutoFooter {
                
                // MARK: Auto Footer
                flatAutoFooter = ZVRefreshAutoFlatFooter()
                flatAutoFooter?.stateLabel?.isHidden = isStateLabelHidden
                flatAutoFooter?.addTarget(self, action: #selector(refreshFooterHandler(_:)))
                /**
                 WARNING:
                 the self must be weak, if not, the associated object can't be released.
                */
                flatAutoFooter?.addHander { [weak self] in
                    print("\(String(describing: self))")
                }

                // MARK: SetTitile
                flatAutoFooter?.setTitle("点击或上拉加载更多数据" , for: .idle)
                flatAutoFooter?.setTitle("正在刷新数据", for: .refreshing)
                flatAutoFooter?.setTitle("没有更多数据", for: .noMoreData)
                
                tableView.refreshFooter = flatAutoFooter
            } else {
            
                // MARK: Back Footer
                flatBackFooter = ZVRefreshBackFlatFooter(target: self, action: #selector(refreshFooterHandler(_:)))
                flatBackFooter?.stateLabel?.isHidden = isStateLabelHidden
                
                // MARK: SetTitile
                flatBackFooter?.setTitle("上拉加载更多数据", for: .idle)
                flatBackFooter?.setTitle("释放开始加载数据", for: .pulling)
                flatBackFooter?.setTitle("正在刷新数据", for: .refreshing)
                flatBackFooter?.setTitle("没有更多数据", for: .noMoreData)

                tableView.refreshFooter = flatBackFooter
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

        } else if refreshComponentType == .native {

        // MARK: - DIY
            
            // MARK: Header
            nativeHeader = ZVRefreshNativeHeader(refreshHandler: { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 , execute: {
                    self?.nativeHeader?.endRefreshing()
                    
                    self?.rows = 16
                    self?.tableView.reloadData()
                })
            })
            nativeHeader?.tintColor = .black
            nativeHeader?.stateLabel?.isHidden = isStateLabelHidden
            nativeHeader?.lastUpdatedTimeLabel?.isHidden = isLastUpdateLabelHidden
            tableView.refreshHeader = nativeHeader

            if isAutoFooter {
                // MARK: Auto Footer
                nativeAutoFooter = ZVRefreshAutoNativeFooter()
                nativeAutoFooter?.stateLabel?.isHidden = isStateLabelHidden
                nativeAutoFooter?.addTarget(self, action: #selector(refreshFooterHandler(_:)))
                tableView.refreshFooter = nativeAutoFooter
            } else {
                // MARK: Back Footer
                nativeBackFooter = ZVRefreshBackNativeFooter(target: self, action: #selector(refreshFooterHandler(_:)))
                nativeBackFooter?.stateLabel?.isHidden = isStateLabelHidden
                tableView.refreshFooter = nativeBackFooter
            }
        }
        
        /**
         
         Also support RxSwift
         
         
        DispatchQueue.main.async { [weak self] in
            Observable.just(true)
                .asDriver(onErrorJustReturn: false)
                .drive(self!.flatHeader!.rx.isRefreshing)
                .disposed(by: self!.disposeBag)
        }
        
        flatHeader?.rx.refresh
            .subscribe(onNext: { isRefreshing in
                print("onNext isRefreshing : \(isRefreshing)")
            }, onError: { err in
                print("err : \(err)")
            }, onCompleted: {
                print("completed")
            }, onDisposed: {
                print("disposed")
            }).disposed(by: disposeBag)
         */

    }

    // MARK: - Life Circle
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Event Action
    
    @objc func refreshFooterHandler(_ refreshFooter: ZVRefreshFooter?) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 , execute: { [weak self] in
            refreshFooter?.endRefreshing()
            
            self?.rows += 16
            self?.tableView.reloadData()
        })
    }
    
}

// MARK: - UITableViewDataSource
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

