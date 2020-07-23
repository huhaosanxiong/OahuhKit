//
//  ToolObject.swift
//  MyProject
//
//  Created by huhsx on 2020/7/7.
//  Copyright © 2020 胡浩三雄. All rights reserved.
//

import Foundation

func ColorHex(_ color: String, _ alpha: CGFloat = 1.0) -> UIColor {
    
    var cstr = color.trimmingCharacters(in:  CharacterSet.whitespacesAndNewlines).uppercased() as NSString;
    if(cstr.length < 6){
        return UIColor.clear;
    }
    if(cstr.hasPrefix("0x")){
        cstr = cstr.substring(from: 2) as NSString
    }
    if(cstr.hasPrefix("#")){
        cstr = cstr.substring(from: 1) as NSString
    }
    if(cstr.length != 6){
        return UIColor.clear;
    }
    var range = NSRange.init()
    range.location = 0
    range.length = 2
    //r
    let rStr = cstr.substring(with: range);
    //g
    range.location = 2;
    let gStr = cstr.substring(with: range)
    //b
    range.location = 4;
    let bStr = cstr.substring(with: range)
    var r :UInt32 = 0x0;
    var g :UInt32 = 0x0;
    var b :UInt32 = 0x0;
    Scanner.init(string: rStr).scanHexInt32(&r);
    Scanner.init(string: gStr).scanHexInt32(&g);
    Scanner.init(string: bStr).scanHexInt32(&b);
    return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha);
}

/// 计算文字高度
/// - Parameters:
///   - font: 字体大小
///   - text: 文字
///   - maxWidth: 最大宽度
/// - Returns: 文本高度
func resizeLabelFrame(font: UIFont, text: String = "", maxWidth: CGFloat) -> CGSize {
    
    let attributes = [NSAttributedString.Key.font: font]
    
    let size = NSString(string: text).boundingRect(
        with: CGSize(width: maxWidth, height: CGFloat(MAXFLOAT)),
        options: [.truncatesLastVisibleLine, .usesLineFragmentOrigin, .usesFontLeading],
        attributes: attributes,
        context: nil).size
    
    return size
}

let PhoneRegex = "\\d{3}-\\d{8}|\\d{3}-\\d{7}|\\d{4}-\\d{8}|\\d{4}-\\d{7}|1+[34578]+\\d{9}|\\d{8}|\\d{7}"
let WebRegex = "((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+,?:_/=<>]*)?)|([a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+,?:_/=<>]*)?)"
let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"

/// 会话文字正则验证
/// - Parameter string: 要验证的字符串
/// - Returns: range数组
func wordVerifyValidation(_ string: String) -> [NSRange] {

    var regex: NSRegularExpression?
    do {
        regex = try NSRegularExpression(
            pattern: "(\(PhoneRegex))|(\(WebRegex))|(\(emailRegex))",
            options: .caseInsensitive)
    } catch let error{
        DLog("error = \(error.localizedDescription)")
    }
    
    guard let arrayOfAllMatches = regex?.matches(in: string, options: [], range: NSRange(location: 0, length: string.count)) else {
        return []
    }

    var arrM: [NSRange] = []

    for match in arrayOfAllMatches {

        let substringForMatch = (string as NSString).substring(with: match.range)

        arrM.append(match.range)

        DLog("匹配: \(substringForMatch)")
    }
    
    return arrM
}
