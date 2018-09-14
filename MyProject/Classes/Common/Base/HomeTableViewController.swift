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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "ProjectList"
        
        let dataArray = Observable.just([
            SectionModel(model: "", items: ["1.UICollectionView组头悬停",
                                            "2.Github搜寻仓库",
                                            "3.Charts",
                                            "4.蚂蚁森林能量收取",
                                            "5.Lottie"])
            ])
        
        let className = ["HoverCollectionController",
                         "GithubRepoListController",
                         "ChartsViewController",
                         "BubbleViewController",
                         "LottieViewController"]
        
        
        //Config
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: { (dataSource, tableView, indexPath, model) -> UITableViewCell in
            
            let cell = tableView.cell(ofType: UITableViewCell.self)
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.textLabel?.text = model
            return cell
        })
        //绑定
        dataArray.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        //点击
        Observable.zip(tableView.rx.modelSelected(String.self),tableView.rx.itemSelected)
            .subscribe(onNext: {[unowned self] model, indexPath in
                
                self.tableView.deselectRow(at: indexPath, animated: true)
                
                DLog("indexPath = \(indexPath),title = \(model)")
                
                let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"]
                guard let ns = nameSpace as? String else{
                    return
                }
                
                let myClass: AnyClass? = NSClassFromString(ns + "." + className[indexPath.row])
                guard let myClassType = myClass as? UIViewController.Type else{
                    return
                }
                
                let vc = myClassType.init()
                self.navigationController?.pushViewController(vc, animated: true)

            }).disposed(by: disposeBag)
        
    }
    
    override func initSubviews() {
        
        view.addSubview(tableView)
        tableView.registerCell(ofType: UITableViewCell.self)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
    }
    
    override func setNavigationItemsIsInEditMode(_ isInEditMode: Bool, animated: Bool) {
        super.setNavigationItemsIsInEditMode(isInEditMode, animated: animated)
        self.titleView.title = "ProjectList"
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
