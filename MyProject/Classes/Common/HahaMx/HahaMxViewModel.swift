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
    
    var cellHeightArray: [CGFloat] = []
    
    let disposeBag = DisposeBag()
    
    var page = 1
    
    var read: String = ""
    
    
    func loadData(pullDown: Bool, type: String = "good") {
        
        page = pullDown ? 1 : page
        
        DLog(self.read)
        
        HahaMxAPIProvider.rx
            .request(.joke_list(type: type, page: page, pagesize: 20, read: read))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .mapObject(type: JokeListModel.self)
            .subscribe(onNext: { [weak self] model in

                //计算高度
                var heightArray: [CGFloat] = []
                for mod in model.joke {
                    
                    let aspectRatio = mod.pic.width / mod.pic.height
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
                
            
                self?.read = (self?.read)! + "," + model.page
                
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
    
    func getlabelHeight(fontSize: CGFloat, text: String, maxWidth: Float) -> CGSize {
        
        let font = UIFont.systemFont(ofSize: fontSize)
        
        let att = [NSAttributedStringKey.font:font]
        
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


