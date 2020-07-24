//
//  Message.swift
//  MyProject
//
//  Created by huhsx on 2020/7/23.
//  Copyright © 2020 胡浩三雄. All rights reserved.
//

import Foundation
import SwiftDate
import YYText

/// 消息内容类型枚举
enum MessageType: Int {
    /**
     *  文本类型消息
     */
    case text           = 0
    /**
     *  图片类型消息
     */
    case image          = 1
    /**
     *  声音类型消息
     */
    case audio          = 2
    /**
     *  视频类型消息
     */
    case video          = 3
    /**
     *  位置类型消息
     */
    case location       = 4
    /**
     *  通知类型消息
     */
    case notification   = 5
    /**
     *  文件类型消息
     */
    case file           = 6
    /**
     *  提醒类型消息
     */
    case tip            = 10
    /**
     *  自定义类型消息
     */
    case custom         = 100
}




/// 消息结构
class Message {
    
    ///消息类型
    var messageType: MessageType!
    
    /// 消息来源
    var from = ""
    
    /// 消息所属会话
    var session: Session?
    
    /// 消息ID,唯一标识
    var messageId = ""
    
    /// 消息文本
    var text = ""
    
    /// 消息附件内容
    var messageObject: MessageObject?
    
    /// 消息推送文案,长度限制200字节
    var apnsContent = ""
    
    /// 消息发送时间
    var timestamp: TimeInterval = 0.0
    
    /// 是否是往外发的消息
    var isOutgoingMsg: Bool = true
    
    /// 对端是否已读
    var isRemoteRead: Bool = false
    
}

/// 头像宽高
public let iconWidth: CGFloat = 38

class MessageModel {
    
    /// 消息数据
    var message: Message!
    
    /// 转换后的时间
    var time: String = ""
    
    /// 是否隐藏时间
    var hideTimeLabel = false
    
    /// 是否隐藏内容（消息通知等需要隐藏）
    var hideContentView = false
    
    /// 时间frame
    var timeFrame: CGRect = .zero
    
    /// 通知frame
    var notiFrame: CGRect = .zero
    
    /// 头像frame
    var avatarFrame: CGRect = .zero
    
    /// 昵称frame
    var nameFrame: CGRect = .zero
    
    /// 内容frame
    var contentFrame: CGRect = .zero
    
    /// 转圈&重新发送按钮的frame
    var activityFrame: CGRect = .zero
    
    /// cell高度
    var cellHeight: CGFloat = 0.0
    
    /// 处理后的富文本
    var attributeText: NSMutableAttributedString = NSMutableAttributedString()
    
    /// 可点击文本的dic
    var dictM: NSMutableDictionary = NSMutableDictionary()
    
    var space: CGFloat = 8
    
    var padding: CGFloat = 15
    
    init(message: Message) {
        
        self.message = message
        self.time = Date(timeIntervalSince1970: message.timestamp).convertTo(region: .current).toFormat("yyyy年MM月dd日 HH:mm")
    }
    
    func setTextHighlight() {
        
        //把"高亮"属性设置到某个文本范围
        let phoneArray = wordVerifyValidation(attributeText.string)
        
        for highlightRange in phoneArray {
            
            let border = YYTextBorder(fill: UIColor(white: 0, alpha: 0.22), cornerRadius: 3.0)
            let highlight = YYTextHighlight()
            highlight.setColor(.white)
            highlight.setBackgroundBorder(border)
            
            attributeText.yy_setTextHighlight(highlight, range: highlightRange)
            attributeText.yy_setColor(ColorHex("#507daf"), range: highlightRange)
        }
    }
    
    /**
     计算frame
     */
    func getFrame() {
        
        //1.通知或时间
        var notiHeight: CGFloat = 0.0
        
        if !hideTimeLabel {
            
            let timeW = resizeLabelFrame(font: UIFont.systemFont(ofSize: 12), text: time, maxWidth: SCREEN_WIDTH - 2 * space).width + 2 * space
            
            notiFrame = CGRect(x: (SCREEN_WIDTH - timeW) / 2.0,
                               y: 10,
                               width: timeW,
                               height: 20)
            notiHeight = 40
            
        }
        
        //2.正文
        
        var textX: CGFloat = 0.0
        let textY: CGFloat = 0.0
        
        switch message.messageType {
        case .text:
            //文本消息
            attributeText = message.text.emotionString()
            
            setTextHighlight()
            
            let container = YYTextContainer(size: CGSize(width: 0.6 * SCREEN_WIDTH, height: CGFloat(MAXFLOAT)))
            let layout = YYTextLayout(container: container, text: attributeText)
            var size = layout?.textBoundingSize ?? CGSize.zero
            
            size.width = max(size.width, 14)
            let afterSize = CGSize(width: size.width + 30, height: size.height + 30)
            
            if message.isOutgoingMsg {
                // 自己发的
                textX = SCREEN_WIDTH - 1.5 * padding - iconWidth - afterSize.width
            }else {
                //别人发的
                textX = 1.5 * padding + iconWidth
            }
            
            contentFrame = CGRect(x: textX, y: textY, width: afterSize.width, height: afterSize.height)
            
        case .image:
            //图片消息
            let size = imageContentSize(cellWidth: SCREEN_WIDTH)
            
            let afterSize = CGSize(width: size.width + 20, height: size.height + 20)
            
            if message.isOutgoingMsg {
                // 自己发的
                textX = SCREEN_WIDTH - 1.5 * padding - iconWidth - afterSize.width
            }else {
                //别人发的
                textX = 1.5 * padding + iconWidth
            }
            
            contentFrame = CGRect(x: textX, y: textY, width: afterSize.width, height: afterSize.height)
            
        default:
            break
            
        }
        
        // 3.头像
        
        var iconX: CGFloat = 0
        let iconY: CGFloat = 5
        let iconW: CGFloat = iconWidth
        let iconH: CGFloat = iconWidth
        
        if message.isOutgoingMsg {
            // 自己发的
            iconX = SCREEN_WIDTH - padding - iconWidth
        }else {
            //别人发的
            iconX = padding
        }
        
        avatarFrame = CGRect(x: iconX, y: iconY, width: iconW, height: iconH)
        
        // 4.昵称
        //...
        
        let iconMaxY = avatarFrame.maxY
        let textMaxY = contentFrame.maxY
        
        //加个10 cell高度太小 、太挤
        cellHeight = max(iconMaxY, textMaxY) + notiHeight
    }
    
    
    
}

extension MessageModel {
    
    func imageContentSize(cellWidth: CGFloat) -> CGSize {
        
        let attachmentImageMinWidth  = cellWidth/2.0
        let attachmentImageMinHeight = cellWidth/2.0
        let attachmemtImageMaxWidth  = cellWidth/2.0
        let attachmentImageMaxHeight = cellWidth/2.0
        
        guard let imgObject = message.messageObject as? MessageImageObject else { return .zero }
        
        var imageSize: CGSize = .zero
        
        imageSize = imgObject.size
        
        let contentSize = resizeImage(originSize: imageSize,
                                      imageMinSize: CGSize(width: attachmentImageMinWidth, height: attachmentImageMinHeight),
                                      imageMaxSize: CGSize(width: attachmemtImageMaxWidth, height: attachmentImageMaxHeight))
        
        return contentSize
    }
    
    func resizeImage(originSize: CGSize, imageMinSize: CGSize, imageMaxSize: CGSize) -> CGSize{
        
        var size: CGSize = .zero
        let imageWidth = originSize.width
        let imageHeight = originSize.height
        let imageMinWidth = imageMinSize.width
        let imageMinHeight = imageMinSize.height
        let imageMaxWidth = imageMaxSize.width
        let imageMaxHeight = imageMaxSize.height
        
        //宽图
        if imageWidth > imageHeight {
            size.height = imageMinHeight //高度取最小高度
            size.width = imageWidth * imageMinHeight / imageHeight
            if size.width > imageMaxWidth {
                size.width = imageMaxWidth

                if imageWidth > 3 * imageHeight {
                    //图片过宽
                    //不按等比例缩放
                    size.height = imageMaxWidth / 3.0
                }else {
                    size.height = imageMaxWidth * imageHeight / imageWidth
                }
            }
        }else if imageWidth < imageHeight {
            //高图
            size.width = imageMinWidth
            size.height = imageHeight * imageMinWidth / imageWidth
            if size.height > imageMaxHeight {
                size.height = imageMaxHeight

                if imageHeight > 3 * imageWidth {
                    //图片过高
                    //不按等比例缩放,以防很窄
                    size.width = imageMaxHeight / 3.0
                } else {
                    size.width = imageMaxHeight * imageWidth / imageHeight
                }
            }
        }else {
            //方图
            if imageWidth > imageMaxWidth {
                
                size.width = imageMaxWidth
                size.height = imageMaxHeight
                
            } else if imageWidth > imageMinWidth {
                
                size.width = imageWidth
                size.height = imageHeight
                
            } else {
                
                size.width = imageMinWidth
                size.height = imageMinHeight
            }
        }
        
        return size
    }
    
}
