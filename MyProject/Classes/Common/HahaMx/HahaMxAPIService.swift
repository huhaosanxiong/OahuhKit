//
//  HahaMxAPIService.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/11/2.
//  Copyright © 2018 胡浩三雄. All rights reserved.
//

import UIKit

enum HahaMxAPIService {
    /*type
     good 最火
     new 最新
     pic 趣图
     */
    case joke_list(type:String, page: Int, pagesize: Int, id: Int)
    case topic(page: Int)
}

let HahaMxAPIProvider = MoyaProvider<HahaMxAPIService>()

//图片域名
let imageDomain = "http://image.haha.mx/"

//图片质量
enum imageQuality {
    case normal
    case middle
}

extension imageQuality {
    
    var quality: String {
        switch self {
        case .normal:
            return "normal/"
        case .middle:
            return "middle/"
        }
    }
    
}


extension HahaMxAPIService: TargetType {
    
    var baseURL: URL {
        return URL.init(string: "http://www.haha.mx")!
    }
    
    var path: String {
        switch self {
        case .joke_list, .topic:
            return "/mobile_app_data_api.php"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .joke_list, .topic:
            return .post
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case .joke_list(let type, let page, let pagesize, let id):
            var parameter: [String: Any] = [:]
            parameter["r"] = "joke_list"
            parameter["type"] = type
            parameter["offset"] = pagesize
            parameter["page"] = page
            parameter["id"] = id
            return .requestParameters(parameters: parameter, encoding: URLEncoding.default)
            
        case .topic(let page):
            var parameter: [String: Any] = [:]
            parameter["r"] = "topic"
            parameter["type"] = "update"
            parameter["page"] = page
            return .requestParameters(parameters: parameter, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
    
}

