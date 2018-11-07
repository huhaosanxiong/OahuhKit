//
//  FoldingCellViewController.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/11/7.
//  Copyright © 2018 胡浩三雄. All rights reserved.
//

import UIKit

class FoldingCellViewController: BaseViewController {
    
    enum Const {
        static let closeCellHeight: CGFloat = 100
        static let openCellHeight: CGFloat = 300
        static let rowsCount: Int = 10
    }
    
    var cellHeights: [CGFloat] = []
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.registerCell(ofType: JokeListCell.self)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "FoldingCell"

    }
    
    override func initSubviews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view).inset(UIEdgeInsets.zero)
        }
        
        cellHeights = Array(repeating: Const.closeCellHeight, count: Const.rowsCount)
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
