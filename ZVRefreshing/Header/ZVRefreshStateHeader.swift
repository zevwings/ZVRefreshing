//
//  ZRefreshStateHeader.swift
//
//  Created by zevwings on 16/3/30.
//  Copyright © 2016年 zevwings. All rights reserved.
//

import UIKit

open class ZVRefreshStateHeader: ZVRefreshHeader {
    
    public struct LastUpdatedTimeKey {
        static var `default`: String { return "com.zevwings.refreshing.lastUpdateTime" }
    }
    
    // MARK: - Property
    
    public var labelInsetLeft: CGFloat = 12.0
    
    public var stateTitles: [State : String]?
    public private(set) var stateLabel: UILabel?
    public private(set) var lastUpdatedTimeLabel: UILabel?
    
    private var originalLastUpdatedTimeLabelHidden: Bool?

    // MARK: LastUpdateTime

    var lastUpdatedTime: Date? {
        return UserDefaults.standard.object(forKey: lastUpdatedTimeKey) as? Date
    }
    
    public var lastUpdatedTimeKey: String = LastUpdatedTimeKey.default {
        didSet {
            _didSetLastUpdatedTimeKey(lastUpdatedTimeKey)
        }
    }

    public var lastUpdatedTimeLabelText:((_ date: Date?)->(String))? {
        didSet {
            _didSetLastUpdatedTimeKey(lastUpdatedTimeKey)
        }
    }
    
    // MARK: - Subviews
    
    override open func prepare() {
        super.prepare()
        
        if stateLabel == nil {
            stateLabel = .default
            addSubview(stateLabel!)
        }
        
        if lastUpdatedTimeLabel == nil {
            lastUpdatedTimeLabel = .default
            addSubview(lastUpdatedTimeLabel!)
            lastUpdatedTimeKey = LastUpdatedTimeKey.default
        }
        
        setTitle(localized(string: LocalizedKey.Header.idle), for: .idle)
        setTitle(localized(string: LocalizedKey.Header.pulling), for: .pulling)
        setTitle(localized(string: LocalizedKey.Header.refreshing), for: .refreshing)
    }
    
    override open func placeSubViews() {
        super.placeSubViews()
        
        guard let stateLabel = stateLabel, stateLabel.isHidden == false else {
            originalLastUpdatedTimeLabelHidden = lastUpdatedTimeLabel?.isHidden
            lastUpdatedTimeLabel?.isHidden = true
            return
        }
        
        if let isHidden = originalLastUpdatedTimeLabelHidden, !isHidden {
            lastUpdatedTimeLabel?.isHidden = isHidden
            originalLastUpdatedTimeLabelHidden = nil
        }
        
        if let lastUpdatedTimeLabel = lastUpdatedTimeLabel, !lastUpdatedTimeLabel.isHidden {

            let statusLabelH = frame.size.height * 0.5
            
            if stateLabel.constraints.count == 0 {
                stateLabel.frame.origin.x = 0
                stateLabel.frame.origin.y = 0
                stateLabel.frame.size.width = frame.width
                stateLabel.frame.size.height = statusLabelH
            }
            
            if lastUpdatedTimeLabel.constraints.count == 0 {
                lastUpdatedTimeLabel.frame.origin.x = 0
                lastUpdatedTimeLabel.frame.origin.y = statusLabelH
                lastUpdatedTimeLabel.frame.size.width = frame.width
                lastUpdatedTimeLabel.frame.size.height = frame.height - lastUpdatedTimeLabel.frame.origin.y
            }
        } else {
            if stateLabel.constraints.count == 0 { stateLabel.frame = bounds }
        }
    }
    
    // MARK: - Do On State
    
    override open func doOnAnyState(with oldState: State) {
        super.doOnAnyState(with: oldState)
        
        setCurrentStateTitle()
    }
    
    override open func doOnIdle(with oldState: State) {
        super.doOnIdle(with: oldState)
        
        guard oldState == .refreshing else { return }
        
        UserDefaults.standard.set(Date(), forKey: lastUpdatedTimeKey)
        UserDefaults.standard.synchronize()
        
        _didSetLastUpdatedTimeKey(lastUpdatedTimeKey)
    }
}

// MARK: - Override

extension ZVRefreshStateHeader {
    
    override open var tintColor: UIColor! {
        didSet {
            lastUpdatedTimeLabel?.textColor = tintColor
            stateLabel?.textColor = tintColor
        }
    }
}

// MARK: - Private

private extension ZVRefreshStateHeader {
    
    func _didSetLastUpdatedTimeKey(_ newValue: String) {
        
        if lastUpdatedTimeLabelText != nil {
            lastUpdatedTimeLabel?.text = lastUpdatedTimeLabelText?(lastUpdatedTime)
            return
        }
        
        if let lastUpdatedTime = lastUpdatedTime {
            
            let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
            
            let calendar = Calendar(identifier: .gregorian)
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
            
            lastUpdatedTimeLabel?.text = String(format: "%@ %@ %@",
                                                localized(string: LocalizedKey.State.lastUpdatedTime),
                                                isToday ? localized(string: LocalizedKey.State.dateToday) : "",
                                                timeString)
        } else {
            lastUpdatedTimeLabel?.text = String(format: "%@ %@",
                                                localized(string: LocalizedKey.State.lastUpdatedTime),
                                                localized(string: LocalizedKey.State.noLastTime))
        }
    }
}

// MARK: - ZVRefreshStateComponent

extension ZVRefreshStateHeader: ZVRefreshStateComponentConvertor {}
