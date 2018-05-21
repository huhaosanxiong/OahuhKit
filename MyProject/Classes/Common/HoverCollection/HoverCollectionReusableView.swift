//
//  HoverCollectionReusableView.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/5/21.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import UIKit

class HoverCollectionReusableView: UICollectionReusableView {
    
    var textLabel : UILabel!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.qmui_random()
        
        textLabel = UILabel()
        textLabel.textColor = UIColor.white
        textLabel.textAlignment = NSTextAlignment.center
        self.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
