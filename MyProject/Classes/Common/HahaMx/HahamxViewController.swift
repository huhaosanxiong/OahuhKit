//
//  HahamxViewController.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/11/2.
//  Copyright © 2018 胡浩三雄. All rights reserved.
//

import UIKit

class HahamxViewController: BaseViewController, Refreshable {
    
    let disposeBag = DisposeBag()
    
    var hahaViewModel = HahaListViewModel()
    
    var type: String = "good"
    
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.estimatedRowHeight = 100
        table.registerCell(ofType: JokeListCell.self)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "搞笑"
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view).inset(UIEdgeInsets.zero)
        }
        
        tableView.mj_header.beginRefreshing()
    }
    
    
    override func bindViewModel() {
        
        self.hahaViewModel.autoSetRefreshControlStatus(header: initRefreshHeader(tableView, { [weak self] in
            //下拉刷新
            self?.hahaViewModel.loadData(pullDown: true, type: (self?.type)!)
        }), footer: initAutoRefreshFooter(tableView, { [weak self] in
            //上拉加载更多
            self?.hahaViewModel.loadData(pullDown: false, type: (self?.type)!)
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

