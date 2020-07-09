//
//  RepoListViewModel.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/10/26.
//  Copyright © 2018 胡浩三雄. All rights reserved.
//

import UIKit

class RepoListViewModel: NSObject, RefreshProtocol{
    
    let rxDataSource: Variable<[GithubListSection]> = Variable([])
    
    var refreshStatus: Variable<RefreshStatus> = Variable<RefreshStatus>(.none)
    
    let disposeBag = DisposeBag()
    
    var page = 1

    //网络请求
    func loadData(pullDown: Bool) {
        
        page = pullDown ? 1 : page
        
        DLog("page = \(page)")
        
        GithubProvider.rx
            .request(.searchRepo(page: page))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .mapObject(type: GithubResultModel.self)
            .subscribe(onNext: {[weak self] model in
                
                self?.rxDataSource.value = pullDown ? [GithubListSection(items: model.items)] : [GithubListSection(items: (self?.rxDataSource.value.first?.items ?? []) + model.items)]
                
                self?.refreshStatus.value = pullDown ? .endHeaderRefresh : .endFooterRefresh
                
                if model.items.count == 0 {
                    //无更多数据
                    self?.refreshStatus.value = .noMoreData
                }else{
                    self?.page += 1
                }
                
            }, onError: {[weak self] error in
                
                //处理异常
                DLog(error.localizedDescription)
                
                self?.refreshStatus.value = pullDown ? .endHeaderRefresh : .endFooterRefresh
                
                guard let rxError = error as? RxSwiftMoyaError else {
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                    return
                }
                
                switch rxError {
                case .UnexpectedResult(let resultCode, let resultMsg):
                    SVProgressHUD.showError(withStatus: "code = \(resultCode!),msg = \(resultMsg!)")
                case .ParseJSONError:
                    SVProgressHUD.showError(withStatus: "ParseJSONError")
                default:
                    SVProgressHUD.showError(withStatus: "网络故障")
                }
                    
            }).disposed(by: disposeBag)
    }
    
}
