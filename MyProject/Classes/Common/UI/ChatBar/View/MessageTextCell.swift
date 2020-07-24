//
//  MessageTextCell.swift
//  MyProject
//
//  Created by huhsx on 2020/7/24.
//  Copyright © 2020 胡浩三雄. All rights reserved.
//

import Foundation
import YYText

class MessageTextViewCell: MessageCell {
    
    var baseContentView: MessageTextContentView!

    override var msgModel: MessageModel {
        
        didSet {
            
            // 文本
            baseContentView.frame = msgModel.contentFrame
            baseContentView.msgModel = msgModel
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        //4.内容
        baseContentView = MessageTextContentView(frame: .zero)
        userContentView.addSubview(baseContentView)
    }
}

/// 文本类型view
class MessageTextContentView: MessageBaseContentView {
    
    var textLabel: YYLabel!
    
    override var msgModel: MessageModel {
        
        didSet {

            setBubbleFrame(msgModel: msgModel)
            
            textLabel.attributedText = msgModel.attributeText
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textLabel = YYLabel()
        textLabel.font = UIFont.systemFont(ofSize: 14)
        textLabel.numberOfLines = 0
        textLabel.textColor = ColorHex("#333333")
        textLabel.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        addSubview(textLabel)
        
        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
