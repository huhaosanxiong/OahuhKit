//
//  CharBarViewController.swift
//  MyProject
//
//  Created by huhsx on 2020/7/21.
//  Copyright © 2020 胡浩三雄. All rights reserved.
//

import UIKit

class CharBarViewController: BaseViewController {
    
    let manager = ChatBarDataManager.shared
    
    private lazy var tableView: UITableView = {
        
        let tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.estimatedRowHeight = 40
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return tableview
    }()
    
    private var charBar: ChatBarView!
    
    // 安全区高度
    var topInset: CGFloat = 0.0
    var bottomInset: CGFloat = 0.0
    
    var dataSource: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "CharBar"
        
        view.backgroundColor = ColorHex("#E0E0E0")
    }
    
    override func initSubviews() {
        
        
        if #available(iOS 11.0, *) {
            bottomInset = CGFloat(UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0)
            topInset = CGFloat(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0.0)
        } else {
            // Fallback on earlier versions
        }
        
        tableView.frame = CGRect(x: 0,
                                 y: topInset,
                                 width: SCREEN_WIDTH,
                                 height: SCREEN_HEIGHT - ChatBarHeight - topInset - bottomInset)
        view.addSubview(tableView)

        charBar = ChatBarView(frame: CGRect(x: 0,
                                            y: SCREEN_HEIGHT - ChatBarHeight - bottomInset,
                                            width: SCREEN_WIDTH,
                                            height: ChatBarHeight))
        charBar.delegate = self
        view.addSubview(charBar)
    }

    
    func tableViewScrollToBottom(animte: Bool) {
        
        if dataSource.count == 0 { return }
        
        tableView.scrollToRow(at: IndexPath(row: dataSource.count - 1, section: 0), at: .bottom, animated: animte)
    }
}

// MARK: - ChatBarViewDelegate
extension CharBarViewController: ChatBarViewDelegate {
    
    func sendMessage(text: String) {
        
        dataSource.append(text)
        
        tableView.insertRows(at: [IndexPath(row: dataSource.count - 1, section: 0)], with: .automatic)
    }
    
    func chatBarFrameDidChanged(frame: CGRect) {
        
        DLog("chatBarFrame = \(frame)")
        
        let barMinY = frame.minY
        
        self.tableView.frame = CGRect(x: 0,
                                      y: self.topInset,
                                      width: SCREEN_WIDTH,
                                      height: barMinY - self.topInset)
        
        self.tableViewScrollToBottom(animte: true)
    }

}

extension CharBarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = dataSource[indexPath.row]
        
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        charBar.chatBarDismiss()
    }
    
}
