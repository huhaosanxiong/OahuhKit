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
        static let closeCellHeight: CGFloat = CGFloat(FoldingListCell.itemHeight + FoldingListCell.space*2)
        static let openCellHeight: CGFloat = CGFloat(FoldingListCell.itemHeight*FoldingListCell.count + FoldingListCell.space*2)
        static let rowsCount: Int = 10
    }
    
    var cellHeights: [CGFloat] = []
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.registerCell(ofType: FoldingListCell.self)
        table.delegate = self
        table.dataSource = self
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "FoldingCell"
        
        cellHeights = Array(repeating: Const.closeCellHeight, count: Const.rowsCount)
        
    }
    
    override func initSubviews() {
        view.addSubview(tableView)
        tableView.estimatedRowHeight = Const.closeCellHeight
        tableView.rowHeight = UITableView.automaticDimension
//        tableView.backgroundColor = UIColor(patternImage: Asset.background.image)
        tableView.backgroundView = UIImageView(image: Asset.background.image)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view).inset(UIEdgeInsets.zero)
        }
        
        cellHeights = Array(repeating: Const.closeCellHeight, count: Const.rowsCount)
    }
}

extension FoldingCellViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellHeights.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as FoldingListCell = cell else {
            return
        }

        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(ofType: FoldingListCell.self) 
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingListCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.5
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
        
    }
    
}
