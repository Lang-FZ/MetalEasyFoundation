//
//  Default.swift
//  MetalEasyFoundation
//
//  Created by LFZ on 2019/6/1.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

private let kScreen: CGRect = UIScreen.main.bounds
public let kScreenW: CGFloat = kScreen.size.width
public let kScreenH: CGFloat = kScreen.size.height

public var kStatusH: CGFloat { return getStatusHeight() }
public var kNaviBarH: CGFloat { return getNaviHeight() }
public var kTabBarH: CGFloat { return getTabBarHeight() }
public var kTabBarBotH: CGFloat { return getTabBarBottomHeight() }

public func frameMath(_ frame: CGFloat) -> CGFloat {
    return frame/375.0*UIScreen.main.bounds.width
}

private func getStatusHeight() -> CGFloat {
    if isIphoneX() {
        return CGFloat.init(44)
    } else {
        return 20
    }
}
private func getNaviHeight() -> CGFloat {
    if isIphoneX() {
        return CGFloat.init(88)
    } else {
        return CGFloat.init(64)
    }
}

public func getTabBarHeight() -> CGFloat {
    if isIphoneX() {
        return CGFloat.init(83)
    } else {
        return CGFloat.init(49)
    }
}
public func getTabBarBottomHeight() -> CGFloat {
    if isIphoneX() {
        return CGFloat.init(34)
    } else {
        return 0
    }
}

// MARK: - 刘海屏
public func isIphoneX()->Bool {
    if UIApplication.shared.statusBarFrame.height == 44 {
        return true
    } else {
        return false
    }
}

