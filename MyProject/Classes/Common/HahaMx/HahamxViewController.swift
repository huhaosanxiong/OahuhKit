//
//  HahamxViewController.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/11/2.
//  Copyright © 2018 胡浩三雄. All rights reserved.
//

import UIKit

//TODO ： Gif的很多第三方报错，先这样
class HahamxViewController: BaseViewController, Refreshable {
    
    let disposeBag = DisposeBag()
    
    var hahaViewModel = HahaListViewModel()
    
    var type: String = "web_good"
    
    var topicID: Int = 0
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.registerCell(ofType: JokeListCell.self)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "搞笑"
        self.rightBarButtonImage = Icon.menu!
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view).inset(UIEdgeInsets.zero)
        }
        
        tableView.mj_header.beginRefreshing()
        
        SDWebImageManager.shared().imageCache?.config.shouldDecompressImages = false
        SDWebImageManager.shared().imageCache?.config.maxCacheSize = 1024*1024*100
    }
    
    override func rightButtonAction(button: UIButton) {
        
        let arr = hahaViewModel.rxTopicDataSource.value
        
        let alert: UIAlertController = UIAlertController.init(title: "选择标签", message: "#话题#", preferredStyle: UIAlertController.Style.actionSheet)
        arr.forEach({ model in
            let action = UIAlertAction.init(title: model.content, style: UIAlertAction.Style.default, handler: { act in
                self.type = "topic"
                self.topicID = model.id
                self.navigationItem.title = "#"+model.content+"#"
                self.tableView.mj_header.beginRefreshing()
            })
            alert.addAction(action)
        })
        let cancel = UIAlertAction.init(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    override func bindViewModel() {
        
        self.hahaViewModel.autoSetRefreshControlStatus(header: initRefreshHeader(tableView, { [weak self] in
            //下拉刷新
            self?.hahaViewModel.loadData(pullDown: true, type: (self?.type)!, topicID: (self?.topicID)!)
            
            self?.hahaViewModel.loadDataWithTopic()
            
        }), footer: initRefreshFooter(tableView, { [weak self] in
            //上拉加载更多
            self?.hahaViewModel.loadData(pullDown: false, type: (self?.type)!, topicID: (self?.topicID)!)
        })).disposed(by: disposeBag)
        
        //Configure
        let dataSource = RxTableViewSectionedReloadDataSource<JokeListSection>(configureCell: {(dataSource, tableView, indexPath, model) -> UITableViewCell in
            
            let cell = tableView.cell(ofType: JokeListCell.self)
            cell.model = model
            return cell
        })
        
        //Bind
        hahaViewModel.rxDataSource
            .asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        
    }
    
    deinit {
        DLog("dealloc")
        SDWebImageManager.shared().imageCache?.clearMemory()
        
    }
    
    override func didReceiveMemoryWarning() {
        SDWebImageManager.shared().imageCache?.clearMemory()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension HahamxViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let height = hahaViewModel.cellHeightArray[indexPath.row]
        return height
    }
}

