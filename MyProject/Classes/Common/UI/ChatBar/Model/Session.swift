//
//  Session.swift
//  MyProject
//
//  Created by huhsx on 2020/7/23.
//  Copyright © 2020 胡浩三雄. All rights reserved.
//

import Foundation

/**
*  会话类型
*/
enum SessionType: Int {
    /**
    *  点对点
    */
    case p2p    = 0
    /**
    *  群组
    */
    case team   = 1
}

class Session {
    
    var sessionId = ""
    
    var sessionType: SessionType!
}
