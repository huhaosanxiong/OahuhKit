//
//  MessageImageCell.swift
//  MyProject
//
//  Created by huhsx on 2020/7/24.
//  Copyright © 2020 胡浩三雄. All rights reserved.
//

import Foundation

class MessageImageCell: MessageCell {
    
    var baseContentView: MessageImageContentView!

    override var msgModel: MessageModel {
        
        didSet {
            
            // 图片
            baseContentView.frame = msgModel.contentFrame
            baseContentView.msgModel = msgModel
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        //4.内容
        baseContentView = MessageImageContentView(frame: .zero)
        userContentView.addSubview(baseContentView)
    }
}

/// 图片类型view
class MessageImageContentView: MessageBaseContentView {
    
    var imageView: UIImageView!
    
    override var msgModel: MessageModel {
        
        didSet {

            setBubbleFrame(msgModel: msgModel)
            
            imageView.frame = CGRect(x: 10, y: 10, width: msgModel.contentFrame.width - 20, height: msgModel.contentFrame.height - 20)
            
            if let messageObject = msgModel.message.messageObject as? MessageImageObject {
                imageView.image = messageObject.image
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView()
        imageView.backgroundColor = ColorHex("#E0E0E0")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        
        addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
