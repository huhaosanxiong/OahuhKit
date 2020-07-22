//
//  ChatBarDataManager.swift
//  MyProject
//
//  Created by huhsx on 2020/7/21.
//  Copyright © 2020 胡浩三雄. All rights reserved.
//

import UIKit
import KakaJSON

struct ChatBarFaceItem {
    
    var file = ""
    var id = ""
    var tag = ""
}

class ChatBarDataManager {
    
    static let shared = ChatBarDataManager()

    let bundleName = "NIMKitResouce.bundle"
    let emojiPath = "Emoticon/Emoji"
    
    //Emoji对象数组
    var emojiDataArray: [ChatBarFaceItem] = []
    
    //Emoji tag数组
    var emojiTagArray: [String] = []
    
    init() {
        
        DispatchQueue.global().async {
            self.parseData()
        }
        
    }
    
    /// 解析emoji
    func parseData() {
        
        guard let bundleURL = Bundle.main.url(forResource: bundleName, withExtension: nil) else { return }
        guard let bundle = Bundle(url: bundleURL) else { return }
        guard let filePath = bundle.path(forResource: "emoji", ofType: "plist", inDirectory: emojiPath) else { return }
        guard let array = NSArray(contentsOfFile: filePath) else { return }
        
        guard let dict = array[0] as? [String: Any] else { return }
        guard let emoticonArray = dict["data"] as? [[String: String]] else { return }
        
        for dic in emoticonArray {
            
            let item = ChatBarFaceItem(file: dic["file"] ?? "",
                                       id: dic["id"] ?? "",
                                       tag: dic["tag"] ?? "")
            emojiDataArray.append(item)
            
            if let tag = dic["tag"] {
                emojiTagArray.append(tag)
            }
            
        }
    }
    
    /// 根据tag判断是否属于表情中的字段
    /// - Parameter tag: [可爱]
    func checkEmojiInSystem(tag: String) -> Bool {
        
        return emojiTagArray.contains(tag)
    }
}

