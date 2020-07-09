//
//  HahaMxViewModel.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/11/2.
//  Copyright © 2018 胡浩三雄. All rights reserved.
//

import Foundation

class HahaListViewModel: NSObject, RefreshProtocol {
    
    var refreshStatus: Variable<RefreshStatus> = Variable<RefreshStatus>(.none)
    
    let rxDataSource: Variable<[JokeListSection]> = Variable([])
    
    let rxTopicDataSource: Variable<[HahaTopicModel]> = Variable([])
    
    var cellHeightArray: [CGFloat] = []
    
    let disposeBag = DisposeBag()
    
    var page = 1
    
    
    func loadData(pullDown: Bool, type: String = "web_good", topicID: Int) {
        
        page = pullDown ? 1 : page
        
        HahaMxAPIProvider.rx
            .request(.joke_list(type: type, page: page, pagesize: 20, id: topicID))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .mapObject(type: JokeListModel.self)
            .subscribe(onNext: { [weak self] model in

                //计算高度
                var heightArray: [CGFloat] = []
                for mod in model.joke {
                    
                    var picModel: JokePicModel
                    if mod.pic.width > 0 {
                        picModel = mod.pic
                    }else{
                        picModel = mod.root.pic
                    }
                    
                    let aspectRatio = (picModel.width == 0 || picModel.height == 0) ? 1 : picModel.width / picModel.height
                    let avatarHeight = 30.0
                    let contentHeight = self?.getlabelHeight(fontSize: 14, text: mod.content, maxWidth: Float(SCREENWIDTH-10*2)).height
                    let imageHeight = (Float(JokeListCell.widthRatio) * Float(SCREENWIDTH)) / aspectRatio
                    let cellHeight = 10 + CGFloat(avatarHeight) + 15 + contentHeight! + 15 + CGFloat(imageHeight) + 15
                    heightArray.append(CGFloat(cellHeight))
                }
                
                if pullDown {
                    self?.cellHeightArray.removeAll()
                    self?.cellHeightArray = heightArray
                }else{
                    self?.cellHeightArray = (self?.cellHeightArray ?? []) + heightArray
                }
                
                //更改数据源
                self?.rxDataSource.value = pullDown ? [JokeListSection(items: model.joke)] : [JokeListSection(items: (self?.rxDataSource.value.first?.items ?? []) + model.joke)]
                
                self?.refreshStatus.value = pullDown ? .endHeaderRefresh : .endFooterRefresh
                
                if model.joke.count == 0 {
                    //无更多数据
                    self?.refreshStatus.value = .noMoreData
                }else{
                    self?.page += 1
                }
                
                }, onError: { [weak self] error in
                    
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
    
    
    private func loadTopic(page: Int) -> Observable<[HahaTopicModel]>{
        
        return HahaMxAPIProvider.rx
            .request(.topic(page: page))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .mapArray(type: HahaTopicModel.self)
        
    }
    
    func loadDataWithTopic()  {
        
        Observable.zip(loadTopic(page: 1),loadTopic(page: 2),loadTopic(page: 3),loadTopic(page: 4))
            .subscribe(onNext: {
                self.rxTopicDataSource.value = $0.0 + $0.1 + $0.2 + $0.3
            }, onError: { error in
                
            }).disposed(by: disposeBag)
        /*
        loadTopic(page: 1)
            .flatMap{
                Observable.zip(Observable.just($0),self.loadTopic(page: 2))
            }.flatMap{
                Observable.zip(Observable.just($0.0),Observable.just($0.1),self.loadTopic(page: 3))
            }.flatMap{
                Observable.zip(Observable.just($0.0),Observable.just($0.1),Observable.just($0.2),self.loadTopic(page: 4))
            }.subscribe(onNext: {
                let arr1 = $0.0 + $0.1
                let arr2 = $0.2 + $0.3
                self.rxTopicDataSource.value = arr1 + arr2
            }).disposed(by: disposeBag)
        */
        
    }
    
    func getlabelHeight(fontSize: CGFloat, text: String, maxWidth: Float) -> CGSize {
        
        let font = UIFont.systemFont(ofSize: fontSize)
        
        let att = [NSAttributedString.Key.font:font]
        
        var content = ""
        
        if text.isEmpty {
            content = ""
        }else{
            content = text
        }
        
        let size = NSString(string: content).boundingRect(with: CGSize(width: CGFloat(maxWidth), height: CGFloat(MAXFLOAT)), options: [.truncatesLastVisibleLine, .usesLineFragmentOrigin, .usesFontLeading], attributes: att, context: nil).size
        
        return size
    }
    
}


