//
//  ChatBarMoreView.swift
//  MyProject
//
//  Created by huhsx on 2020/7/21.
//  Copyright © 2020 胡浩三雄. All rights reserved.
//

import UIKit

/// 更多功能
public enum MessageMoreFunctionType {
    
    case picture
}

protocol ChatBarMoreViewDelegate: class {
    
    func clickFunction(type: MessageMoreFunctionType)
}

class ChatBarMoreView: UIView {

    private lazy var collectionView: UICollectionView = {
        
        let view = UICollectionView()
        return view
    }()
    
    weak var delegate: ChatBarMoreViewDelegate?
    
    let titleArray = ["照片"]

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        //CollectionView
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
    
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatBarMoreView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        cell.backgroundColor = randomColor()
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = titleArray[indexPath.row]
        
        guard let delegate = delegate else { return }
        
        switch model {
        case "照片":
            delegate.clickFunction(type: .picture)
        default:
            break
        }
        
    }
    
    //返回单元格大小
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 80, height: 80)
    }
    
    //单元格纵向的最小间距
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    //单元格横向的最小间距
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}
