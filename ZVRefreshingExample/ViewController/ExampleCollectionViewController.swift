//
//  DetailCollectionViewController.swift
//  Example
//
//  Created by zevwings on 2017/7/10.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit
import ZVRefreshing

private let reuseIdentifier = "DetailCell"

class ExampleCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
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

    
    deinit {
        collectionView.removeAllRefreshControls()
        print("DetailCollectionViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewFlowLayout.itemSize = CGSize(width: view.frame.width, height: 88)
        
        self.title = refreshComponentType.title
        
        // MARK: - Normal
        if refreshComponentType == .flat {
            
            // MARK: Header
            flatHeader = ZVRefreshFlatHeader(refreshHandler: { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 , execute: {
                    self?.flatHeader?.endRefreshing()
                    self?.rows = 16
                    self?.collectionView?.reloadData()
                })
            })
            
            flatHeader?.stateLabel?.isHidden = isStateLabelHidden
            flatHeader?.lastUpdatedTimeLabel?.isHidden = isLastUpdateLabelHidden
            
            // MARK: SetTitile
            flatHeader?.setTitle("下拉开始刷新数据", for: .idle)
            flatHeader?.setTitle("释放开始刷新数据", for: .pulling)
            flatHeader?.setTitle("正在刷新数据", for: .refreshing)
            
            flatHeader?.lastUpdatedTimeConvertor = { date in
                
                guard let _date = date else { return "暂无刷新时间" }
                
                let formmater = DateFormatter()
                formmater.dateFormat = "yyyy-MM-dd"
                return String(format: "刷新时间: %@", formmater.string(from: _date))
                
            }
            
            collectionView?.refreshHeader = flatHeader
            
            if isAutoFooter {
                
                // MARK: Auto Footer
                flatAutoFooter = ZVRefreshAutoFlatFooter()
                flatAutoFooter?.stateLabel?.isHidden = isStateLabelHidden
                flatAutoFooter?.addTarget(self, action: #selector(refreshFooterHandler(_:)))
                
                // MARK: SetTitile
                flatAutoFooter?.setTitle("点击或上拉加载更多数据" , for: .idle)
                flatAutoFooter?.setTitle("正在刷新数据", for: .refreshing)
                flatAutoFooter?.setTitle("没有更多数据", for: .noMoreData)
                
                collectionView?.refreshFooter = flatAutoFooter
            } else {
                
                // MARK: Back Footer
                flatBackFooter = ZVRefreshBackFlatFooter(target: self, action: #selector(refreshFooterHandler(_:)))
                flatBackFooter?.stateLabel?.isHidden = isStateLabelHidden
                
                // MARK: SetTitile
                flatBackFooter?.setTitle("上拉加载更多数据", for: .idle)
                flatBackFooter?.setTitle("释放开始加载数据", for: .pulling)
                flatBackFooter?.setTitle("正在刷新数据", for: .refreshing)
                flatBackFooter?.setTitle("没有更多数据", for: .noMoreData)
                
                collectionView?.refreshFooter = flatBackFooter
            }
            
        } else if refreshComponentType == .animation {
            
            // MARK: - Animation
            
            // MARK: Header
            
            animationHeader = ZVRefreshCustomAnimationHeader(refreshHandler: { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 , execute: {
                    self?.animationHeader?.endRefreshing()
                    
                    self?.rows = 16
                    self?.collectionView?.reloadData()
                })
            })
            
            animationHeader?.stateLabel?.isHidden = isStateLabelHidden
            animationHeader?.lastUpdatedTimeLabel?.isHidden = isLastUpdateLabelHidden
            collectionView?.refreshHeader = animationHeader
            
            if isAutoFooter {
                // MARK: Auto Footer
                animationAutoFooter = ZVRefreshAutoCustomAnimationFooter()
                animationAutoFooter?.stateLabel?.isHidden = isStateLabelHidden
                animationAutoFooter?.addTarget(self, action: #selector(refreshFooterHandler(_:)))
                collectionView?.refreshFooter = animationAutoFooter
            } else {
                // MARK: Back Footer
                animationBackFooter = ZVRefreshBackCustomAnimationFooter(target: self, action: #selector(refreshFooterHandler(_:)))
                animationBackFooter?.stateLabel?.isHidden = isStateLabelHidden
                collectionView?.refreshFooter = animationBackFooter
            }
            
        } else if refreshComponentType == .native {
            
            // MARK: - DIY
            
            // MARK: Header
            nativeHeader = ZVRefreshNativeHeader(refreshHandler: { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 , execute: {
                    self?.nativeHeader?.endRefreshing()
                    
                    self?.rows = 16
                    self?.collectionView?.reloadData()
                })
            })
            nativeHeader?.tintColor = .black
            nativeHeader?.stateLabel?.isHidden = isStateLabelHidden
            nativeHeader?.lastUpdatedTimeLabel?.isHidden = isLastUpdateLabelHidden
            collectionView?.refreshHeader = nativeHeader
            
            if isAutoFooter {
                // MARK: Auto Footer
                nativeAutoFooter = ZVRefreshAutoNativeFooter()
                nativeAutoFooter?.stateLabel?.isHidden = isStateLabelHidden
                nativeAutoFooter?.addTarget(self, action: #selector(refreshFooterHandler(_:)))
                collectionView?.refreshFooter = nativeAutoFooter
            } else {
                // MARK: Back Footer
                nativeBackFooter = ZVRefreshBackNativeFooter(target: self, action: #selector(refreshFooterHandler(_:)))
                nativeBackFooter?.stateLabel?.isHidden = isStateLabelHidden
                collectionView?.refreshFooter = nativeBackFooter
            }
        }

    }

    @objc func refreshFooterHandler(_ refreshFooter: ZVRefreshFooter?) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 , execute: { [weak self] in
            refreshFooter?.endRefreshing()
            
            self?.rows += 16
            self?.collectionView?.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ExampleCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rows
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = UIColor(white: 222.0 / 255.0, alpha: 1.0)
        return cell
    }
}

extension ExampleCollectionViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
