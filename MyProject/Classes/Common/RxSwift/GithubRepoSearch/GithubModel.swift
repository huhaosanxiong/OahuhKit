//
//  GithubModel.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/5/29.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import Foundation

struct GithubResultModel: HandyJSON {

    var total_count: Int = 0
    var incomplete_results: Bool = false
    var items: [GithubRepository] = []

}

//单个仓库模型
struct GithubRepository: HandyJSON {
    var id: Int!
    var name: String!
    var full_name: String!
    var html_url: String!
    var description: String!
    var owner: [String: Any]!
    
}


struct GithubListSection {
    
    var items: [Item]
}


extension GithubListSection: SectionModelType {
    
    typealias Item = GithubRepository
    
    init(original: GithubListSection, items: [GithubRepository]) {
        self = original
        self.items = items
    }
}
