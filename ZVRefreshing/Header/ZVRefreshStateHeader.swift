//
//  ZRefreshStateHeader.swift
//
//  Created by ZhangZZZZ on 16/3/30.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

open class ZVRefreshStateHeader: ZVRefreshHeader {

    public private(set) lazy var lastUpdatedTimeLabel: UILabel = .default
    public private(set) lazy var stateLabel: UILabel = .default
    public var labelInsetLeft: CGFloat = 24.0

    private var stateTitles: [State : String] = [:]
    private var calendar = Calendar(identifier: .gregorian)

    // MARK: Subviews
    open override func prepare() {
        super.prepare()
        
        if stateLabel.superview == nil {
            addSubview(stateLabel)
        }
        
        if lastUpdatedTimeLabel.superview == nil {
            addSubview(lastUpdatedTimeLabel)
        }
        
        setTitle(localized(string: LocalizedKey.Header.idle), forState: .idle)
        setTitle(localized(string: LocalizedKey.Header.pulling), forState: .pulling)
        setTitle(localized(string: LocalizedKey.Header.refreshing), forState: .refreshing)
    }
    
    open override func placeSubViews() {
        
        super.placeSubViews()
        
        guard stateLabel.isHidden == false else { return }
        
        let noConstrainsOnStatusLabel = stateLabel.constraints.count == 0
        
        if lastUpdatedTimeLabel.isHidden {
            if noConstrainsOnStatusLabel { stateLabel.frame = bounds }
        } else {
            let statusLabelH = frame.size.height * 0.5
            stateLabel.frame.origin.x = 0
            stateLabel.frame.origin.y = 0
            stateLabel.frame.size.width = frame.size.width
            stateLabel.frame.size.height = statusLabelH
            if lastUpdatedTimeLabel.constraints.count == 0 {
                
                lastUpdatedTimeLabel.frame.origin.x = 0
                lastUpdatedTimeLabel.frame.origin.y = statusLabelH
                lastUpdatedTimeLabel.frame.size.width = frame.size.width
                lastUpdatedTimeLabel.frame.size.height = frame.size.height - lastUpdatedTimeLabel.frame.origin.y
            }
        }
    }
    
    // MARK: Getter & Setter
    
    public var lastUpdatedTimeLabelText:((_ date: Date?)->(String))? {
        didSet {
            didSetLastUpdatedTimeKey(lastUpdatedTimeKey)
        }
    }
    
    open override var refreshState: State {
        get {
            return super.refreshState
        }
        set {
            setRefreshState(newValue)
        }
    }
    
    public override var lastUpdatedTimeKey: String {
        
        didSet {
            didSetLastUpdatedTimeKey(lastUpdatedTimeKey)
        }
    }
}


extension ZVRefreshStateHeader {
    
    open override var tintColor: UIColor! {
        didSet {
            lastUpdatedTimeLabel.textColor = tintColor
            stateLabel.textColor = tintColor
        }
    }
}


// MARK: - Public
public extension ZVRefreshStateHeader {
    
    /// 设置状态文本
    public func setTitle(_ title: String, forState state: State) {
        stateTitles.updateValue(title, forKey: state)
        stateLabel.text = stateTitles[refreshState]
    }
}


// MARK: - Private
private extension ZVRefreshStateHeader {
    
    func setRefreshState(_ newValue: State) {
        
        guard checkState(newValue).result == false else { return }
        super.refreshState = newValue
        stateLabel.text = stateTitles[refreshState]
        
        let key = lastUpdatedTimeKey
        lastUpdatedTimeKey = key
    }
    
    func didSetLastUpdatedTimeKey(_ newValue: String) {
        
        guard lastUpdatedTimeLabelText == nil else {
            lastUpdatedTimeLabel.text = lastUpdatedTimeLabelText?(lastUpdatedTime)
            return
        }
        
        if let lastUpdatedTime = lastUpdatedTime {
            
            let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
            
            let cmp1 = calendar.dateComponents(components, from: lastUpdatedTime)
            let cmp2 = calendar.dateComponents(components, from: lastUpdatedTime)
            let formatter = DateFormatter()
            var isToday = false
            if cmp1.day == cmp2.day {
                formatter.dateFormat = "HH:mm"
                isToday = true
            } else if cmp1.year == cmp2.year {
                formatter.dateFormat = "MM-dd HH:mm"
            } else {
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
            }
            let timeString = formatter.string(from: lastUpdatedTime)
            
            lastUpdatedTimeLabel.text = String(format: "%@ %@ %@",
                                                    localized(string: LocalizedKey.State.lastUpdatedTime),
                                                    isToday ? localized(string: LocalizedKey.State.dateToday) : "",
                                                    timeString)
        } else {
            lastUpdatedTimeLabel.text = String(format: "%@ %@",
                                                    localized(string: LocalizedKey.State.lastUpdatedTime),
                                                    localized(string: LocalizedKey.State.noLastTime))
        }
    }
}

