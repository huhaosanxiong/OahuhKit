//
//  MessageCell.swift
//  MyProject
//
//  Created by huhsx on 2020/7/23.
//  Copyright © 2020 胡浩三雄. All rights reserved.
//

import UIKit
import YYText

class MessageCell: BaseTableViewCell {
    
    var msgModel: MessageModel = MessageModel(message: Message()) {
        
        didSet {
            
            notiView.notiLabel.frame = msgModel.notiFrame
            notiView.notiLabel.text = msgModel.time
            
            let maskPath = UIBezierPath(roundedRect: notiView.notiLabel.bounds, byRoundingCorners: [.topRight, .bottomRight, .bottomLeft, .topLeft], cornerRadii: CGSize(width: 3, height: 3))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = notiView.notiLabel.bounds
            maskLayer.path = maskPath.cgPath
            notiView.notiLabel.layer.mask = maskLayer
            
            
            headImageView.frame = msgModel.avatarFrame
            headImageView.image = UIImage(named: "IMG_1145")
            
            let contentViewOriginY = msgModel.notiFrame.height > 0 ? msgModel.notiFrame.height + 20 : 0
            let contentViewHeight = msgModel.cellHeight - contentViewOriginY
            
            userContentView.frame = CGRect(x: 0, y: contentViewOriginY, width: SCREEN_WIDTH, height: contentViewHeight)
            
        }
    }
    
    //用户信息view（除了时间和通知的view的父视图）
    var userContentView: UIView!
    //系统通知或者时间view
    var notiView: MessageNotifyContentView!
    var bubbleView: UIView!
    var headImageView: UIImageView!
    

    override func configureUI() {
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        selectionStyle = .none
            
        //1.通知或者时间
        notiView = MessageNotifyContentView(frame: .zero)
        
        //2.内容view
        userContentView = UIView()
        
        //3.头像
        headImageView = UIImageView()
        headImageView.layer.cornerRadius = iconWidth / 2.0
        headImageView.layer.masksToBounds = true
        headImageView.isUserInteractionEnabled = true
        headImageView.contentMode = .scaleAspectFill

        
        contentView.addSubview(notiView)
        contentView.addSubview(userContentView)
        userContentView.addSubview(headImageView)
        
        
    }

}


/// 通知或时间view
class MessageNotifyContentView: UIView {
    
    var notiLabel: YYLabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        notiLabel = YYLabel()
        notiLabel.textAlignment = .center
        notiLabel.font = UIFont.systemFont(ofSize: 12)
        notiLabel.numberOfLines = 0
        notiLabel.textColor = .black
        notiLabel.backgroundColor = ColorHex("#D8D8D8")
        
        addSubview(notiLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// Content基类
class MessageBaseContentView: UIView {
    
    var bubbleImageView: UIImageView!
    
    var msgModel: MessageModel = MessageModel(message: Message())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bubbleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        
        addSubview(bubbleImageView)
        
        bubbleImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }


    }
    
    func setBubbleFrame(msgModel: MessageModel) {
        
//        bubbleImageView.frame = CGRect(x: 0, y: 0, width: msgModel.contentFrame.width, height: msgModel.contentFrame.height)
        
        bubbleImageView.image = resizeImage(imgName: msgModel.message.isOutgoingMsg ? "bubble_box_right_n" : "bubble_box_left_n")
    }
    
    func resizeImage(imgName: String) -> UIImage {
        
        var sendImg = UIImage(named: imgName)!

        let top = (sendImg.size.height) * 0.8 // 顶端盖高度
        let bottom = (sendImg.size.height) * 0.2 - 1 // 底端盖高度
        let left: CGFloat = 10 // 左端盖宽度
        let right: CGFloat = 10 // 右端盖宽度
        let insets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        // 指定为拉伸模式，伸缩后重新赋值
        sendImg = sendImg.resizableImage(withCapInsets: insets, resizingMode: .stretch)

        return sendImg
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


