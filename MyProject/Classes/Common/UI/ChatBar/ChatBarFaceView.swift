//
//  ChatBarFaceView.swift
//  MyProject
//
//  Created by huhsx on 2020/7/21.
//  Copyright © 2020 胡浩三雄. All rights reserved.
//

import UIKit

class ChatBarFaceView: UIView {
    
    private lazy var faceCollectionView: UICollectionView = {
        
        let view = UICollectionView()
        return view
    }()
    
    public var emojiDataArray: [ChatBarFaceItem] = [] {
        
        didSet {
            setEmojiDataArray()
        }
    }
    
    let manager = ChatBarDataManager.shared
    
    let space: CGFloat = 8.0
    
    let itemWidth: CGFloat = 35.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        faceCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        faceCollectionView.delegate = self
        faceCollectionView.dataSource = self
        faceCollectionView.backgroundColor = .white
        faceCollectionView.register(ChatBarFaceItemCell.self, forCellWithReuseIdentifier: "ChatBarFaceItemCell")
        
        if #available(iOS 11.0, *) {
            faceCollectionView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
        addSubview(faceCollectionView)
        
        faceCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0))
        }

    }
    
    
    /// 表情布局
    /// - Parameter array: 数据源
    private func setEmojiDataArray() {
        
        guard emojiDataArray.count > 0 else {
            fatalError("解析出错，Emoji无数据")
        }
        
        faceCollectionView.reloadData()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ChatBarFaceView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatBarFaceItemCell", for: indexPath) as! ChatBarFaceItemCell
        
        let model = emojiDataArray[indexPath.row]
        let imageName = "\(manager.bundleName)/\(manager.emojiPath)/\(model.file)"
        
        cell.imgView.image = UIImage(named: imageName)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = emojiDataArray[indexPath.row]
        
        DLog(model.id)
    }
    
    //返回单元格大小
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    //单元格纵向的最小间距
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return space
    }
    
    //单元格横向的最小间距
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return space
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: space, left: space, bottom: space, right: space)
    }
    
}


class ChatBarFaceItemCell: UICollectionViewCell {
    
    var imgView : UIImageView!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        imgView = UIImageView()
        imgView.backgroundColor = .white
        contentView.addSubview(imgView)
        
        imgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
