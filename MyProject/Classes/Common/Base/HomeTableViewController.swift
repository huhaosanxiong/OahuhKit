//
//  HomeTableViewController.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/5/21.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseViewController {
    
    var disposeBag : DisposeBag = DisposeBag()
    
    var tableView : UITableView = UITableView()
    
    struct SectionDataModel {
        
        let title: String
        let vcName: String
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Awesome"
        
        let dataArray = Observable.just([
            
            SectionModel(model: "Animation", items: [
                SectionDataModel(title: "PushTransitionAnimate", vcName: "PushTransitionViewController"),
                SectionDataModel(title: "屏幕自动旋转", vcName: "AutoRotationViewController"),
                SectionDataModel(title: "屏幕强制横屏", vcName: "ForceLandscapeViewController"),
                SectionDataModel(title: "DashBoard仪表盘", vcName: "DashBoardController"),
                SectionDataModel(title: "TwitterLaunchView", vcName: "TwitterViewController"),
                SectionDataModel(title: "WaveLodingView", vcName: "WaveLodingViewController"),
            ]),
            SectionModel(model: "UI", items: [
                SectionDataModel(title: "Charts", vcName: "ChartsViewController"),
                SectionDataModel(title: "Lottie", vcName: "LottieViewController"),
                SectionDataModel(title: "FoldingCell", vcName: "FoldingCellViewController"),
                SectionDataModel(title: "蚂蚁森林能量收取", vcName: "BubbleViewController"),
                SectionDataModel(title: "UICollectionView组头悬停", vcName: "HoverCollectionController"),
                SectionDataModel(title: "Chat UI", vcName: "CharBarViewController"),
            ]),
            SectionModel(model: "多线程", items: [
                SectionDataModel(title: "DispatchSemaphore", vcName: "GCDController"),
                SectionDataModel(title: "弹幕(OperationQueue)", vcName: "DanmuViewController")
            ]),
            SectionModel(model: "RxSwift网络请求", items: [
                SectionDataModel(title: "Github搜寻仓库", vcName: "GithubRepoListController"),
                SectionDataModel(title: "RxSwift+List+Refresh", vcName: "GithubRepoListRefreshController"),
                SectionDataModel(title: "https://www.haha.mx(接口已失效)", vcName: "HahamxViewController")
            ]),
            SectionModel(model: "初级算法", items: [
                SectionDataModel(title: "动态规划 最少钱币数（凑硬币）", vcName: "LeastCoinProblemViewController"),
                SectionDataModel(title: "两数之和(LeetCode.No2)", vcName: "LeetCode_2_Controller"),
                SectionDataModel(title: "盛最多水的容器(LeetCode.No11)", vcName: "LeetCode_11_Controller"),
            ])
        ])
        
        
        //Config
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, SectionDataModel>>(configureCell: { (dataSource, tableView, indexPath, model) -> UITableViewCell in
            
            let cell = tableView.cell(ofType: UITableViewCell.self, for: indexPath)
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            cell.textLabel?.text = model.title
            return cell
        }, titleForHeaderInSection: { dataSource, index in
            // 返回标题
            return dataSource.sectionModels[index].model
        })
        
        //绑定
        dataArray.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        //导航栏转场动画代理（写在下面block中不起作用）
        let delegate = TransitionProcotol()
        
        //点击
        Observable.zip(tableView.rx.modelSelected(SectionDataModel.self),tableView.rx.itemSelected)
            .subscribe(onNext: {[unowned self] model, indexPath in
                
                self.tableView.deselectRow(at: indexPath, animated: true)
                
                DLog("indexPath = \(indexPath),title = \(model.title)")
                
                let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"]
                guard let ns = nameSpace as? String else{
                    return
                }
                
                let myClass: AnyClass? = NSClassFromString(ns + "." + model.vcName)
                guard let myClassType = myClass as? UIViewController.Type else {
                    return
                }
                
                if model.vcName == "PushTransitionViewController" {

                    let vc = myClassType.init()
                    let nav = UINavigationController(rootViewController: vc)
                    nav.delegate = delegate
                    nav.isNavigationBarHidden = true
                    self.present(nav, animated: true, completion: nil)
                    
                    return
                }
                
                let vc = myClassType.init()
                
                if let base = vc as? BaseViewController {
                    base.showLargeTitles = false
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                

            }).disposed(by: disposeBag)
        
    }
    
    override func initSubviews() {
        
        view.addSubview(tableView)
        tableView.registerCell(ofType: UITableViewCell.self)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
