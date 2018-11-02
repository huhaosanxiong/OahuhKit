//
//  HahaMaxModel.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/11/2.
//  Copyright © 2018 胡浩三雄. All rights reserved.
//

import Foundation

struct JokeListModel: HandyJSON {
    var page: String = ""
    var joke: [JokeModel] = []
    
}

struct JokeModel: HandyJSON {
    
    var id: Int = 0
    var content: String = ""
    var time: String = ""
    var pic: JokePicModel = JokePicModel()
    var user_name: String = ""
    var user_pic: String = ""
}

struct JokePicModel: HandyJSON {
    var path: String = ""
    var name: String = ""
    var width: Float = 0
    var height: Float = 0
    var animated: Bool = false
}


struct JokeListSection {
    
    var items: [Item]
    
}

extension JokeListSection: SectionModelType {
    
    typealias Item = JokeModel
    
    init(original: JokeListSection, items: [Item]) {
        self = original
        self.items = items
    }
}
