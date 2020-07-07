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

