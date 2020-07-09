//
//  GithubViewModel.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/5/29.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import HandyJSON

class GithubViewModel {
    
    /** 输入部分 **/
    //查询行为
    fileprivate let searchAction: Driver<String>
    
    /** 输出部分 **/
    //所有的查询结果
    let searchResult: Driver<GithubResultModel>
    
    //查询结果里的资源列表
    let repositories: Driver<[GithubListSection]>
    
    //清空操作
    let cleanResult: Driver<Void>
    
    //导航栏标题
    let navigationTitle: Driver<String>
    
    //ViewModel初始化（根据输入实现对应的输出）
    init(searchAction: Driver<String>) {
        self.searchAction = searchAction
        
        //生成查询结果序列
        self.searchResult = searchAction.filter{!$0.isEmpty}
            .flatMapLatest{
                
                GithubProvider.rx.request(.repositories($0))
                    .filterSuccessfulStatusCodes()
                    .mapJSON()
                    .asObservable()
                    .map{ json in
                        DLog("\(json)")
                        let object = JSONDeserializer<GithubResultModel>.deserializeFrom(dict: json as? [String: Any])
                        return object!
                    }.asDriver(onErrorDriveWith: Driver.empty())
        }
        
        //生成清空结果序列
        self.cleanResult = searchAction.filter{$0.isEmpty}.map{_ in }
        
        //生成结果
        self.repositories = Driver.merge(
            searchResult.map{ [GithubListSection(items: $0.items)]},
            cleanResult.map{ [GithubListSection(items: [])]})
        
        //导航栏
        self.navigationTitle = Driver.merge(
            searchResult.map{"共有 \($0.total_count)个结果"},
            cleanResult.map{"查询"})
    }
}


