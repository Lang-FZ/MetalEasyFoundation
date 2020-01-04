//
//  BaseListNode.swift
//  MetalEasyFoundation
//
//  Created by LFZ on 2019/6/3.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit
import AsyncDisplayKit

// MARK: -

class BaseListNode: ASCellNode {
    
    /** 属性 */
    lazy var title: ASTextNode = {
        let title = ASTextNode()
        title.maximumNumberOfLines = 1
        return title
    }()
    let title_attributes : [NSAttributedString.Key : Any] = [
        .font : UIFont.custom(FontName.PFSC_Light, 15),
        .foregroundColor : UIColor.init("#323232")]
    
    lazy var sub_title: ASTextNode = {
        let sub_title = ASTextNode()
        sub_title.maximumNumberOfLines = 1
        return sub_title
    }()
    let sub_title_attributes : [NSAttributedString.Key : Any] = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        let sub_title_attributes : [NSAttributedString.Key : Any] = [
            .font : UIFont.custom(FontName.PFSC_Light, 15),
            .foregroundColor : UIColor.init("#323232"),
            .paragraphStyle : paragraphStyle]
        return sub_title_attributes
    }()
    
    private lazy var separator: ASDisplayNode = {
        let separator = ASDisplayNode()
        separator.backgroundColor = UIColor.init("#D2D2D2")
        return separator
    }()
    
    public var isLast:Bool = false {
        didSet {
            if isLast {
                separator.alpha = 0
            } else {
                separator.alpha = 1
            }
        }
    }
    
    
    // MARK: - setModel
    public var model: BaseListModel = BaseListModel.init([:]) {
        didSet {
            title.attributedText = NSAttributedString(string: LocalizationTool.getStr(model.title), attributes: title_attributes)
            sub_title.attributedText = NSAttributedString(string: LocalizationTool.getStr(model.sub_title), attributes: sub_title_attributes)
        }
    }
    var title_text:String = "" {
        didSet {
            title.attributedText = NSAttributedString(string: title_text, attributes: title_attributes)
        }
    }
    var sub_title_text:String = "" {
        didSet {
            sub_title.attributedText = NSAttributedString(string: sub_title_text, attributes: sub_title_attributes)
        }
    }
    
    override init() {
        super.init()
        
        selectionStyle = .none
        backgroundColor = UIColor.white
        automaticallyManagesSubnodes = true
    }
    override func didLoad() {
        super.didLoad()
    }
}

extension BaseListNode {
    
    // MARK: - 约束
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let cell_size = CGSize.init(width: kScreenW, height: frameMath(60))
        
        let title_stack = ASStackLayoutSpec.init(direction: .vertical, spacing: 0, justifyContent: .center, alignItems: .start, children: [title])
        title_stack.style.layoutPosition.x = frameMath(15)
        title_stack.style.preferredSize = CGSize.init(width: cell_size.width-frameMath(30), height: cell_size.height)
        
        let sub_title_stack = ASStackLayoutSpec.init(direction: .vertical, spacing: 0, justifyContent: .center, alignItems: .end, children: [sub_title])
        sub_title_stack.style.layoutPosition.x = frameMath(15)
        sub_title_stack.style.preferredSize = CGSize.init(width: cell_size.width-frameMath(30), height: cell_size.height)

        separator.style.preferredSize = CGSize.init(width: cell_size.width-frameMath(30), height: 0.5)
        let separator_stack = ASStackLayoutSpec.init(direction: .vertical, spacing: 0, justifyContent: .end, alignItems: .center, children: [separator])
        separator_stack.style.preferredSize = CGSize.init(width: cell_size.width-frameMath(30), height: cell_size.height)
        separator_stack.style.layoutPosition.x = frameMath(15)
        
        let absoluteLayout = ASAbsoluteLayoutSpec.init(children: [title_stack, sub_title_stack, separator_stack])
        absoluteLayout.style.preferredSize = cell_size

        return absoluteLayout
    }
}
