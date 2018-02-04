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
        print("DetailCollectionViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewFlowLayout.itemSize = .init(width: view.frame.width, height: 88)
        
        self.title = refreshComponentType.title
                
        // MARK: - Normal
        if refreshComponentType == .normal {
            
            // MARK: Header
            normalHeader = ZVRefreshNormalHeader(refreshHandler: { [weak self] in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 , execute: {
                    
                    self?.normalHeader?.endRefreshing()
                    
                    self?.rows = 16
                    self?.collectionView?.reloadData()
                    
                })
            })
            
            normalHeader?.stateLabel?.isHidden = isStateLabelHidden
            normalHeader?.lastUpdatedTimeLabel?.isHidden = isLastUpdateLabelHidden
            collectionView?.refreshHeader = normalHeader
            
            if isAutoFooter {
                
                // MARK: Auto Footer
                normalAutoFooter = ZVRefreshAutoNormalFooter()
                normalAutoFooter?.stateLabel?.isHidden = isStateLabelHidden
                normalAutoFooter?.addTarget(self, action: #selector(refreshFooterHandler(_:)))
                collectionView?.refreshFooter = normalAutoFooter
            } else {
                
                // MARK: Back Footer
                normalBackFooter = ZVRefreshBackNormalFooter(target: self, action: #selector(refreshFooterHandler(_:)))
                normalBackFooter?.stateLabel?.isHidden = isStateLabelHidden
                collectionView?.refreshFooter = normalBackFooter
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
            
        } else if refreshComponentType == .diy {
            
            // MARK: - DIY
            
            // MARK: Header
            diyHeader = ZVRefreshArrowIndicatorHeader(refreshHandler: { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 , execute: {
                    self?.diyHeader?.endRefreshing()
                    
                    self?.rows = 16
                    self?.collectionView?.reloadData()
                })
            })
            diyHeader?.stateLabel?.isHidden = isStateLabelHidden
            diyHeader?.lastUpdatedTimeLabel?.isHidden = isLastUpdateLabelHidden
            collectionView?.refreshHeader = diyHeader
            
            if isAutoFooter {
                // MARK: Auto Footer
                diyAutoFooter = ZVRefreshAutoArrowIndicatorFooter()
                diyAutoFooter?.stateLabel?.isHidden = isStateLabelHidden
                diyAutoFooter?.addTarget(self, action: #selector(refreshFooterHandler(_:)))
                collectionView?.refreshFooter = diyAutoFooter
            } else {
                // MARK: Back Footer
                diyBackFooter = ZVRefreshBackArrowIndicatorFooter(target: self, action: #selector(refreshFooterHandler(_:)))
                diyBackFooter?.stateLabel?.isHidden = isStateLabelHidden
                collectionView?.refreshFooter = diyBackFooter
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
