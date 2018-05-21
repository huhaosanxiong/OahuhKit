//
//  HoverCollectionController.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/5/21.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import UIKit

class HoverCollectionController: BaseViewController {
    
    var collectionView : UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func initSubviews() {
        
        //去除存在导航栏时内内边距自动调整功能，防止对自定义的Collection View分区头停留功能造成影响
//        self.automaticallyAdjustsScrollViewInsets = false
        
        let layout = HoverCollectionFlowLayout()
        
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        view.addSubview(collectionView)
        
        collectionView.register(HoverCollectionViewCell.self, forCellWithReuseIdentifier: "HoverCollectionViewCell")
        collectionView.register(HoverCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HoverCollectionReusableView")
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0))
        }
    }


    override func setNavigationItemsIsInEditMode(_ isInEditMode: Bool, animated: Bool) {
        super.setNavigationItemsIsInEditMode(isEditing, animated: animated)
        self.titleView.title = "HoverCollection"
    }
}

extension HoverCollectionController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HoverCollectionViewCell", for: indexPath)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HoverCollectionReusableView", for: indexPath) as? HoverCollectionReusableView else {
            fatalError()
        }
        
        header.textLabel.text = "\(indexPath.section)"
        
        return header
    }
}

extension HoverCollectionController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //返回分组头大小
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 44.0)
    }
    
    //返回单元格大小
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.bounds.width - 2*3)/4
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    //每个分组的内边距
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    //单元格的行间距
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    //单元格横向的最小间距
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
}





