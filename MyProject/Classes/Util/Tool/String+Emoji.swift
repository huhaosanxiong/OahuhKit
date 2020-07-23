//
//  String+Emoji.swift
//  MyProject
//
//  Created by huhsx on 2020/7/23.
//  Copyright © 2020 胡浩三雄. All rights reserved.
//

import Foundation
import YYText
import YYImage

extension String {
    
    func emotionString() -> NSMutableAttributedString {
        
        let manager = ChatBarDataManager.shared
        
        let emotions = manager.emojiDataArray

        let font = UIFont.systemFont(ofSize: 14)
        
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(.font, value: font, range: NSRange(location: 0, length: attributeString.length))
        attributeString.yy_lineSpacing = 5
        attributeString.yy_font = font
        let pattern = "\\[[\\u4e00-\\u9fa5]+\\]"
        var re: NSRegularExpression?
        do {
            re = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        } catch let error {
            DLog("error: \(error.localizedDescription)")
        }
        let resultArray = re?.matches(in: self, options: [], range: NSRange(location: 0, length: count)) ?? []
        
        var imageArray: [NSMutableDictionary] = []


        for match in resultArray {
            let range = match.range
            let subStr = NSString(string: self).substring(with: range)

            for i in 0..<emotions.count {
                let emotion = emotions[i]
                if emotion.tag == subStr {
                    
                    let path = "\(manager.bundleName)/\(manager.emojiPath)/\(emotion.file)"
                    if let image = getImage(path: path) {
                        
                        let attachText = NSMutableAttributedString.yy_attachmentString(withContent: image, contentMode: .center, attachmentSize: image.size, alignTo: font, alignment: .center)
                        
                        let imageDic = NSMutableDictionary(dictionary: ["image": attachText, "range": range])
                        imageArray.append(imageDic)
                    }
                }
            }
        }
        
        var i = imageArray.count - 1
        while i >= 0 {
            var range: NSRange?
            let dic = imageArray[i]
            
            if let value = dic["range"] as? NSRange {
                range = value
            }
            
            if let vaildRange = range {
                if let att = dic["image"] as? NSAttributedString {
                    attributeString.replaceCharacters(in: vaildRange, with: att)
                }
            }
            
            i -= 1
        }

        return attributeString
    }
    
    func getImage(path: String) -> UIImage? {
        
        var data: Data?
        
        let image = UIImage(named: path)
        data = image?.pngData()
        
//        do {
//            data = try
//        } catch let error {
//            DLog("error: \(error.localizedDescription)")
//        }
//
        if let imageData = data {
            let image = YYImage(data: imageData, scale: 3)
            image?.preloadAllAnimatedImageFrames = true
            return image
        }
        
        return nil
    }
}
