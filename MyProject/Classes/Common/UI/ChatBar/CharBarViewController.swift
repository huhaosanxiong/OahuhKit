//
//  CharBarViewController.swift
//  MyProject
//
//  Created by huhsx on 2020/7/21.
//  Copyright © 2020 胡浩三雄. All rights reserved.
//

import UIKit
import TZImagePickerController

class CharBarViewController: BaseViewController {
    
    let manager = ChatBarDataManager.shared
    
    private lazy var tableView: UITableView = {
        
        let tableview = UITableView()
        tableview.backgroundColor = ColorHex("#F0F0F5")
        tableview.delegate = self
        tableview.dataSource = self
        tableview.registerCell(ofType: MessageTextViewCell.self)
        tableview.registerCell(ofType: MessageImageCell.self)
        tableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        tableview.separatorStyle = .none
        tableview.backgroundView = UIImageView(image: Asset.background.image)
        return tableview
    }()
    
    private var chatBar: ChatBarView!
    
    // 安全区高度
    var topInset: CGFloat = 0.0
    var bottomInset: CGFloat = 0.0
    
    var dataSource: [MessageModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Chat UI"
        
        view.backgroundColor = ColorHex("#E0E0E0")
        
        loadData()
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

        chatBar = ChatBarView(frame: CGRect(x: 0,
                                            y: SCREEN_HEIGHT - ChatBarHeight - bottomInset,
                                            width: SCREEN_WIDTH,
                                            height: ChatBarHeight))
        chatBar.delegate = self
        chatBar.moreBoardView.delegate = self
        view.addSubview(chatBar)
    }
    
    func loadData() {
        
        let stringArray = ["Hello world! [可爱][可爱][可爱][可爱][可爱][可爱][可爱][汗][怒][怒][怒][怒][怒][怒]",
        "Hello world! [可爱][可爱][可爱][可爱][可爱][可爱][可爱][汗][怒][怒][怒][怒][怒][怒]",
        "😄[可爱][鬼脸]",
        "🇨🇳[可爱][鬼脸]",
        "Contact: huhsxxx@gmail.com"]
        
        for text in stringArray {
            
            // 构造Message
            let message = MessageConverter.messageWithText(text: text)
            message.messageId = UUID().uuidString
            // 构造MessageModel
            let messageModel = MessageModel(message: message)
            
            if let lastMessageModel = dataSource.last {
                messageModel.hideTimeLabel = messageModel.time == lastMessageModel.time
            }
            
            messageModel.getFrame()
            
            dataSource.append(messageModel)
        }
        
        tableView.reloadData()
    }

    
    func tableViewScrollToBottom(animte: Bool) {
        
        if dataSource.count == 0 { return }
        
        //reloadData会发生闪烁
        //tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: dataSource.count - 1, section: 0), at: .bottom, animated: animte)
    }
}

// MARK: - ChatBarViewDelegate
extension CharBarViewController: ChatBarViewDelegate {
    
    func sendMessage(text: String) {
        
        // 构造Message
        let message = MessageConverter.messageWithText(text: text)
        message.messageId = UUID().uuidString
        
        // 构造MessageModel
        let messageModel = MessageModel(message: message)
        
        if let lastMessageModel = dataSource.last {
            messageModel.hideTimeLabel = messageModel.time == lastMessageModel.time
        }
        
        messageModel.getFrame()
        
        dataSource.append(messageModel)
        
        tableView.insertRows(at: [IndexPath(row: dataSource.count - 1, section: 0)], with: .none)
    }
    
    func chatBarFrameDidChanged(frame: CGRect) {
        
        //DLog("chatBarFrame = \(frame)")
        
        let barMinY = frame.minY
        
        self.tableView.frame = CGRect(x: 0,
                                      y: self.topInset,
                                      width: SCREEN_WIDTH,
                                      height: barMinY - self.topInset)
        
        tableViewScrollToBottom(animte: false)
    }

}

extension CharBarViewController: ChatBarMoreViewDelegate {
    
    func clickFunction(type: MessageMoreFunctionType) {
        switch type {
        case .picture:
            
            let tz = TZImagePickerController(maxImagesCount: 9, columnNumber: 3, delegate: self)!
            present(tz, animated: true, completion: nil)
        default:
            break
        }
    }
}

extension CharBarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = dataSource[indexPath.row]
        
        var cell: MessageCell!
        
        switch model.message.messageType {
        case .text:
            cell = tableView.cell(ofType: MessageTextViewCell.self, for: indexPath)
        case .image:
            cell = tableView.cell(ofType: MessageImageCell.self, for: indexPath)
            
        default:
            break
        }
        
        cell.msgModel = model
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = dataSource[indexPath.row]
        return model.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        chatBar.chatBarDismiss()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        chatBar.chatBarDismiss()
    }
    
}

extension CharBarViewController: TZImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        
        let image = photos[0]
        
        // 构造Message
        let message = MessageConverter.messageWithImage(image: image)
        message.messageId = UUID().uuidString
        
        // 构造MessageModel
        let messageModel = MessageModel(message: message)
        
        if let lastMessageModel = dataSource.last {
            messageModel.hideTimeLabel = messageModel.time == lastMessageModel.time
        }
        
        messageModel.getFrame()
        
        dataSource.append(messageModel)
        
        tableView.insertRows(at: [IndexPath(row: dataSource.count - 1, section: 0)], with: .none)
        
        chatBar.chatBarDismiss()
    }
}
