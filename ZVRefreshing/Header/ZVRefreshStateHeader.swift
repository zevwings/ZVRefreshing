
//
//  ZRefreshStateHeader.swift
//
//  Created by ZhangZZZZ on 16/3/30.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

open class ZVRefreshStateHeader: ZVRefreshHeader {

    public fileprivate(set) lazy var lastUpdatedTimeLabel: UILabel = .default
    public fileprivate(set) lazy var stateLabel: UILabel = .default
    public var labelInsetLeft: CGFloat = 24.0

    fileprivate var stateTitles: [State : String] = [:]
    fileprivate var calendar = Calendar(identifier: .gregorian)
    public var lastUpdatedTimeLabelText:((_ date: Date?)->(String))? {
        didSet {
            let key = self.lastUpdatedTimeKey
            self.lastUpdatedTimeKey = key
        }
    }
    
    open override var tintColor: UIColor! {
        get {
            return super.tintColor
        }
        set {
            super.tintColor = newValue
            self.lastUpdatedTimeLabel.textColor = newValue
            self.stateLabel.textColor = newValue
        }
    }
    
    override open var state: State {
        get {
            return super.state
        }
        set {
            if self.checkState(newValue).result { return }
            super.state = newValue
            self.stateLabel.text = self.stateTitles[self.state]
            
            let key = self.lastUpdatedTimeKey
            self.lastUpdatedTimeKey = key
        }
    }
    
    public override var lastUpdatedTimeKey: String {
        
        didSet {
            if self.lastUpdatedTimeLabelText != nil {
                self.lastUpdatedTimeLabel.text = self.lastUpdatedTimeLabelText?(lastUpdatedTime)
                return
            }
            
            if let lastUpdatedTime = self.lastUpdatedTime {
                let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]

                let cmp1 = self.calendar.dateComponents(components, from: lastUpdatedTime)
                let cmp2 = self.calendar.dateComponents(components, from: lastUpdatedTime)
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
                
                self.lastUpdatedTimeLabel.text = String(format: "%@ %@ %@",
                                                        localized(string: Constants.State.lastUpdatedTime),
                                                        isToday ? localized(string: Constants.State.dateToday) : "",
                                                        timeString)
            } else {
                self.lastUpdatedTimeLabel.text = String(format: "%@ %@",
                                                        localized(string: Constants.State.lastUpdatedTime),
                                                        localized(string: Constants.State.noLastTime))
            }
        }
    }
}

public extension ZVRefreshStateHeader {
    
    /// 设置状态文本
    public func setTitle(_ title: String, forState state: State) {
        self.stateTitles.updateValue(title, forKey: state)
        self.stateLabel.text = self.stateTitles[self.state]
    }
}

extension ZVRefreshStateHeader {
    
    override open func prepare() {
        super.prepare()
        
        if self.stateLabel.superview == nil {
            self.addSubview(self.stateLabel)
        }
        
        if self.lastUpdatedTimeLabel.superview == nil {
            self.addSubview(lastUpdatedTimeLabel)
        }
        
        self.setTitle(localized(string: Constants.Header.idle), forState: .idle)
        self.setTitle(localized(string: Constants.Header.pulling), forState: .pulling)
        self.setTitle(localized(string: Constants.Header.refreshing), forState: .refreshing)
    }
    
    override open func placeSubViews() {
        super.placeSubViews()
        
        guard self.stateLabel.isHidden == false else { return }
        
        let noConstrainsOnStatusLabel = self.stateLabel.constraints.count == 0
        
        if self.lastUpdatedTimeLabel.isHidden {
            if noConstrainsOnStatusLabel { self.stateLabel.frame = self.bounds }
        } else {
            let statusLabelH = self.height * 0.5
            self.stateLabel.x = 0
            self.stateLabel.y = 0
            self.stateLabel.width = self.width
            self.stateLabel.height = statusLabelH
            if self.lastUpdatedTimeLabel.constraints.count == 0 {
                
                self.lastUpdatedTimeLabel.x = 0
                self.lastUpdatedTimeLabel.y = statusLabelH
                self.lastUpdatedTimeLabel.width = self.width
                self.lastUpdatedTimeLabel.height = self.height - self.lastUpdatedTimeLabel.y
            }
        }
    }
}
