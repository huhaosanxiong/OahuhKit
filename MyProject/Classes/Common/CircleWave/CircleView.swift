//
//  CircleView.swift
//  MyProject
//
//  Created by huhsx on 2020/7/7.
//  Copyright © 2020 胡浩三雄. All rights reserved.
//

import Foundation

class CircleView: UIView {
    
    lazy var myLayer: CAShapeLayer = {
        
        return self.layer as! CAShapeLayer
    }()
    
    var fillColor: UIColor = .white {
        
        didSet {
            myLayer.fillColor = fillColor.cgColor
        }
    }
    
    // 重写layer的类型
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        myLayer.fillColor = UIColor.white.cgColor
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        myLayer.path = path().cgPath
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension CircleView {
    
    private func path() -> UIBezierPath {
        
        let radius = min(bounds.size.width / 2.0, bounds.size.height / 2.0)
        
        let path = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: radius, startAngle: 0, endAngle: -2 * CGFloat(Float.pi), clockwise: false)
        
        return path
    }
}
