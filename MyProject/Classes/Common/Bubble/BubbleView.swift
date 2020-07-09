//
//  BubbleView.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/8/2.
//  Copyright © 2018 胡浩三雄. All rights reserved.
//

import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let BUBBLEDIAMETER = 40



class BubbleView: UIView {

    var disposeBag = DisposeBag()
    var title : String = ""
    var value : String = "0"
    var button : UIButton!

    init(title: String, value: String) {
        
        self.title = title
        self.value = value
        
        super.init(frame: CGRect(x: 0, y: 0, width: BUBBLEDIAMETER, height: BUBBLEDIAMETER))
        
        self.backgroundColor = UIColor.clear
        
        button = UIButton()
        button.layer.cornerRadius = self.bounds.size.width/2.0
        button.backgroundColor = UIColor.green
        button.setTitle(value+"g", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.contentMode = .center
        self.addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(UIEdgeInsets.zero)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}



