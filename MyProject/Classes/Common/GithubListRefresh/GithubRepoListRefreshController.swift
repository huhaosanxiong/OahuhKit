//
//  GithubRepoListRefreshController.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/10/26.
//  Copyright © 2018 胡浩三雄. All rights reserved.
//

import UIKit

class GithubRepoListRefreshController: BaseViewController, Refreshable {

    let disposeBag: DisposeBag = DisposeBag()
    
    var repoViewModel = RepoListViewModel()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.registerCell(ofType: GithubRepoListCell.self)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "RepoList"
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view).inset(UIEdgeInsets.zero)
        }
        
        tableView.mj_header.beginRefreshing()
    }
    
    override func bindViewModel() {
        
        self.repoViewModel.autoSetRefreshControlStatus(header: initRefreshHeader(tableView, { [weak self] in
            //下拉刷新
            self?.repoViewModel.loadData(pullDown: true)
        }), footer: initRefreshFooter(tableView, { [weak self] in
            //上拉加载更多
            self?.repoViewModel.loadData(pullDown: false)
        })).disposed(by: disposeBag)
        
        //Configure
        let dataSource = RxTableViewSectionedReloadDataSource<GithubListSection>(configureCell: {(dataSource, tableView, indexPath, model) -> UITableViewCell in
            
            let cell = tableView.cell(ofType: GithubRepoListCell.self)
            cell.model = model
            return cell
        })
        
        //Bind
        repoViewModel.rxDataSource
            .asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    
        //点击事件
        Observable.zip(tableView.rx.modelSelected(GithubRepository.self), tableView.rx.itemSelected)
            .subscribe(onNext: { [weak self] model, indexPath in
                
                self?.tableView.deselectRow(at: indexPath, animated: true)
                
                let vc = WebViewController()
                vc.urlString = model.html_url
                self?.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
        
        //
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
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

extension GithubRepoListRefreshController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
