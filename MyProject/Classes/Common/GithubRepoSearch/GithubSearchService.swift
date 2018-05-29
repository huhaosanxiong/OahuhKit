//
//  GithubSearchService.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/5/29.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//
/*
 {
 "current_user_url": "https://api.github.com/user",
 "current_user_authorizations_html_url": "https://github.com/settings/connections/applications{/client_id}",
 "authorizations_url": "https://api.github.com/authorizations",
 "code_search_url": "https://api.github.com/search/code?q={query}{&page,per_page,sort,order}",
 "commit_search_url": "https://api.github.com/search/commits?q={query}{&page,per_page,sort,order}",
 "emails_url": "https://api.github.com/user/emails",
 "emojis_url": "https://api.github.com/emojis",
 "events_url": "https://api.github.com/events",
 "feeds_url": "https://api.github.com/feeds",
 "followers_url": "https://api.github.com/user/followers",
 "following_url": "https://api.github.com/user/following{/target}",
 "gists_url": "https://api.github.com/gists{/gist_id}",
 "hub_url": "https://api.github.com/hub",
 "issue_search_url": "https://api.github.com/search/issues?q={query}{&page,per_page,sort,order}",
 "issues_url": "https://api.github.com/issues",
 "keys_url": "https://api.github.com/user/keys",
 "notifications_url": "https://api.github.com/notifications",
 "organization_repositories_url": "https://api.github.com/orgs/{org}/repos{?type,page,per_page,sort}",
 "organization_url": "https://api.github.com/orgs/{org}",
 "public_gists_url": "https://api.github.com/gists/public",
 "rate_limit_url": "https://api.github.com/rate_limit",
 "repository_url": "https://api.github.com/repos/{owner}/{repo}",
 "repository_search_url": "https://api.github.com/search/repositories?q={query}{&page,per_page,sort,order}",
 "current_user_repositories_url": "https://api.github.com/user/repos{?type,page,per_page,sort}",
 "starred_url": "https://api.github.com/user/starred{/owner}{/repo}",
 "starred_gists_url": "https://api.github.com/gists/starred",
 "team_url": "https://api.github.com/teams",
 "user_url": "https://api.github.com/users/{user}",
 "user_organizations_url": "https://api.github.com/user/orgs",
 "user_repositories_url": "https://api.github.com/users/{user}/repos{?type,page,per_page,sort}",
 "user_search_url": "https://api.github.com/search/users?q={query}{&page,per_page,sort,order}"
 }
 */

import Foundation

enum GithubAPI {
    case repositories(String) //查询
}

let GithubProvider = MoyaProvider<GithubAPI>()


extension GithubAPI: TargetType {
    
    var baseURL: URL {
        return URL.init(string: "http://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .repositories:
            return "/search/repositories"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .repositories:
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case .repositories(let str):
            var param: [String: Any] = [:]
            param["q"] = str
            param["sort"] = "stars"
            param["order"] = "desc"
//            param["per_page"] = 20
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
    
}
