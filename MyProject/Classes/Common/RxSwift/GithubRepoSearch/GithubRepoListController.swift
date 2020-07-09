//
//  GithubRepoListController.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/5/29.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher

class GithubRepoListController: BaseViewController {
    
    var tableView = UITableView()
    
    var searchBar = UISearchBar()
    
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerCell(ofType: UITableViewCell.self)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        tableView.tableHeaderView = searchBar
        searchBar.snp.makeConstraints { make in
            make.width.equalTo(tableView.snp.width)
        }
        
    }

    override func bindViewModel() {
        
        let searchAction = searchBar.rx.text.orEmpty.asDriver()
            .throttle(0.5)
            .distinctUntilChanged()
        
        let viewModel = GithubViewModel(searchAction: searchAction)
        
        let dataSource = RxTableViewSectionedReloadDataSource<GithubListSection>(configureCell: { (dataSource, tableView, indexPath, model) -> UITableViewCell in
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "UITableViewCell")
            cell.textLabel?.text = model.name
            cell.detailTextLabel?.text = model.full_name
            cell.imageView?.kf.setImage(with: URL.init(string: model.owner["avatar_url"] as! String))
            return cell
        })
        
        //bind
        viewModel.repositories.drive(tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)

        viewModel.navigationTitle.asObservable().subscribe(onNext: { title in
            debugPrint(title)
            self.navigationItem.title = title
        }).disposed(by: disposeBag)
        
        //点击跳转
        tableView.rx.modelSelected(GithubRepository.self).subscribe(onNext:{[unowned self] model in
            let vc = WebViewController()
            vc.urlString = model.html_url
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
    }

}
