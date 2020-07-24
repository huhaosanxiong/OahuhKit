//
//  MessageCustomObject.swift
//  MyProject
//
//  Created by huhsx on 2020/7/24.
//  Copyright © 2020 胡浩三雄. All rights reserved.
//

import Foundation

/**
 *  消息体协议
 */
protocol MessageObject {
    
    var messageType: MessageType { get }
}


class MessageImageObject: MessageObject {
    
    var messageType: MessageType = .image
    /**
    *  文件展示名
    */
    var displayName: String = ""
    /**
    *  图片本地路径
    *  @discussion 目前 SDK 没有提供下载大图的方法,但推荐使用这个地址作为图片下载地址,APP 可以使用自己的下载类或者 SDWebImage 做图片的下载和管理
    */
    var path: String = ""
    /**
    *  缩略图本地路径
    */
    var thumbPath: String = ""
    /**
    *  图片远程路径
    */
    var url: String = ""
    /**
    *  缩略图远程路径
    */
    var thumbUrl: String = ""
    /**
    *  图片尺寸
    */
    var size: CGSize = .zero
    /**
    *  文件大小
    */
    var fileLength: Int = 0
    
    var image: UIImage?
}

