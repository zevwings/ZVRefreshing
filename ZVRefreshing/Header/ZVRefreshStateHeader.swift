//
//  ZRefreshStateHeader.swift
//  ZVRefreshing
//
//  Created by zevwings on 16/3/30.
//  Copyright © 2016年 zevwings. All rights reserved.
//

import UIKit

open class ZVRefreshStateHeader: ZVRefreshHeader {
    
    public struct LastUpdatedTimeKey {
        static var `default`: String { return "com.zevwings.refreshing.lastUpdateTime" }
    }

    public struct LocalizedKey {
        static let idle = "pull down to refresh"
        static let pulling = "release to refresh"
        static let refreshing = "loading"

        static let lastUpdatedTime = "last update"
        static let dateToday = "today"
        static let noLastTime = "no record"
    }

    public typealias LastUpdatedTimeConvertor = (_ date: Date?) -> (String)
    
    // MARK: - Property
    
    public var labelInsetLeft: CGFloat = 12.0
    
    public var stateTitles: [RefreshState : String] = [:]
    public private(set) var stateLabel: UILabel?
    public private(set) var lastUpdatedTimeLabel: UILabel?
    
    private var originalLastUpdatedTimeLabelHidden: Bool?

    // MARK: LastUpdateTime

    var lastUpdatedTime: Date? {
        return UserDefaults.standard.object(forKey: lastUpdatedTimeKey) as? Date
    }
    
    public var lastUpdatedTimeKey: String = LastUpdatedTimeKey.default {
        didSet {
            updateLastUpdatedTime()
        }
    }

    public var lastUpdatedTimeConvertor: LastUpdatedTimeConvertor? {
        didSet {
            updateLastUpdatedTime()
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
        
        setTitle(with: LocalizedKey.idle, for: .idle)
        setTitle(with: LocalizedKey.pulling, for: .pulling)
        setTitle(with: LocalizedKey.refreshing, for: .refreshing)
    }
    
    override open func placeSubViews() {
        super.placeSubViews()
        
        guard let stateLabel = stateLabel, !stateLabel.isHidden else {
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
            
            if stateLabel.constraints.isEmpty {
                stateLabel.frame.origin.x = 0
                stateLabel.frame.origin.y = 0
                stateLabel.frame.size.width = frame.width
                stateLabel.frame.size.height = statusLabelH
            }
            
            if lastUpdatedTimeLabel.constraints.isEmpty {
                lastUpdatedTimeLabel.frame.origin.x = 0
                lastUpdatedTimeLabel.frame.origin.y = statusLabelH
                lastUpdatedTimeLabel.frame.size.width = frame.width
                lastUpdatedTimeLabel.frame.size.height = frame.height - lastUpdatedTimeLabel.frame.origin.y
            }
        } else {
            if stateLabel.constraints.isEmpty { stateLabel.frame = bounds }
        }
    }
    
    // MARK: - State Update

    open override func refreshStateUpdate(
        _ state: ZVRefreshControl.RefreshState,
        oldState: ZVRefreshControl.RefreshState
    ) {
        super.refreshStateUpdate(state, oldState: oldState)

        setTitleForCurrentState()

        switch state {
        case .idle:
            guard oldState == .refreshing else { return }
            UserDefaults.standard.set(Date(), forKey: lastUpdatedTimeKey)
            UserDefaults.standard.synchronize()
            updateLastUpdatedTime()
        default:
            break
        }
    }

    open func setTitle(_ title: String, for state: RefreshState) {
        stateTitles[state] = title
        stateLabel?.text = stateTitles[refreshState]
        setNeedsLayout()
    }

    open func setTitle(with localizedKey: String, for state: RefreshState) {
        let title = ZVLocalizedString(localizedKey)
        setTitle(title, for: state)
    }

    open func setTitleForCurrentState() {
        guard let stateLabel = stateLabel else { return }
        if stateLabel.isHidden && refreshState == .refreshing {
            stateLabel.text = nil
        } else {
            stateLabel.text = stateTitles[refreshState]
        }
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

    var defaultTimeConvertor: LastUpdatedTimeConvertor {
        return { date -> String in

            if let lastUpdatedTime = date {

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
                return String(
                    format: "%@ %@ %@",
                    ZVLocalizedString(LocalizedKey.lastUpdatedTime),
                    isToday ? ZVLocalizedString(LocalizedKey.dateToday) : "",
                    timeString
                )
            } else {
                return String(
                    format: "%@ %@",
                    ZVLocalizedString(LocalizedKey.lastUpdatedTime),
                    ZVLocalizedString(LocalizedKey.noLastTime)
                )
            }
        }
    }

    func updateLastUpdatedTime() {

        let timeConvertor: LastUpdatedTimeConvertor
        if let lastUpdatedTimeConvertor = lastUpdatedTimeConvertor {
            timeConvertor = lastUpdatedTimeConvertor
        } else {
            timeConvertor = defaultTimeConvertor
        }

        lastUpdatedTimeLabel?.text = timeConvertor(lastUpdatedTime)
        setNeedsLayout()
        layoutIfNeeded()
    }
}
