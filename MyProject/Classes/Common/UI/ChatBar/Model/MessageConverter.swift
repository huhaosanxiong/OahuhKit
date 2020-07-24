//
//  MessageConverter.swift
//  MyProject
//
//  Created by huhsx on 2020/7/24.
//  Copyright © 2020 胡浩三雄. All rights reserved.
//

import Foundation
import SwiftDate

/// 消息构造器
class MessageConverter {
    
    /// 构造文本消息
    /// - Parameter text: text
    /// - Returns: Message
    class func messageWithText(text: String) -> Message {
        
        let msg = Message()
        msg.messageType = .text
        msg.text = text
        msg.apnsContent = text
        msg.timestamp = Date().timeIntervalSince1970
        
        return msg
    }
    
    /// 构造图片消息
    /// - Parameter image: image
    /// - Returns: Message
    class func messageWithImage(image: UIImage) -> Message {
        
        let imageObject = MessageImageObject()
        imageObject.displayName = "图片发送于\(Date().convertTo(region: .current).toFormat("yyyy年MM月dd日 HH:mm"))"
        imageObject.image = image
        imageObject.size = image.size
        
        let msg = Message()
        msg.messageType = .image
        msg.messageObject = imageObject
        msg.apnsContent = "发来了一张图片"
        msg.timestamp = Date().timeIntervalSince1970
        
        return msg
    }
}
