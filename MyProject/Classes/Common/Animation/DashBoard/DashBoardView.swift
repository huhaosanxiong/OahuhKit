//
//  DashBoardView.swift
//  MyProject
//
//  Created by huhsx on 2019/9/11.
//  Copyright © 2019 胡浩三雄. All rights reserved.
//

import Foundation
import UIKit

class DashBoardView: UIView {
    
    /// 圆心
    private var m_center: CGPoint!
    
    /// 内半径
    private var inside_radius: CGFloat = 140
    
    /// 脉冲动画直径
    private var breath_inside_radius: CGFloat = 140*2
    
    /// 外半径
    private var outside_radius: CGFloat = SCREEN_WIDTH/2.0 - 15 - 10
    
    /// 动画layer
    private var progressLayer: CAShapeLayer = CAShapeLayer()
    
    /// 呼吸layer
    private var breatheLayer: CAShapeLayer = CAShapeLayer()
    
    ///指针
    private lazy var pointerView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "netspeed_pointer")
        imageView.sizeToFit()
        //一定要先设置anchorPoint，再设置frame，不然 设置完anchorPoint之后，frame会变更
        imageView.layer.anchorPoint = CGPoint(x: 0.5 ,y: 0.9)
        imageView.frame = CGRect(x: m_center.x - imageView.bounds.width/2.0, y: m_center.y - imageView.bounds.height*0.9, width: imageView.bounds.width, height: imageView.bounds.height)
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        m_center = CGPoint(x: frame.size.width/2.0, y: frame.size.height/2.0)
        
        inside_radius = outside_radius - 40
        
        setupView()
    }
    
    private func setupView() {
        
        
        
        drawActivityOutsideArc()
        drawOutsideArc()
        drawInsideArc()
        drawBreatheInsideArc()
        
        self.addSubview(pointerView)
        reset()
    }
    
    public func reset(animate: Bool = false) {
        
        if animate {
            UIView.animate(withDuration: 0.25) {
                
                // 添加0角度让其逆时针复位
                self.pointerView.transform = CGAffineTransform(rotationAngle: 0)
                
                self.pointerView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi * 3 / 4.0)
                
                self.progressLayer.strokeEnd = 0
            }
            
        }else {
            
            self.pointerView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi * 3 / 4.0)
            
            self.progressLayer.strokeEnd = 0
        }
        
    }
    
    /// 设置进度
    ///
    /// - Parameter value: 当前网速
    public func setProgress(value: CGFloat) {
        
        UIView.animate(withDuration: 0.25) {
            
            self.pointerView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 1.5 * value - CGFloat.pi * 3 / 4.0)
            
            self.progressLayer.strokeEnd = value
        }
    }
    
    
    /// 动画外环
    private func drawActivityOutsideArc() {
        
        let startAngle = -Double.pi * (5/4.0)
        let endAngle = (1/4.0) * Double.pi
        
        
        let path = UIBezierPath.init(arcCenter: m_center, radius: outside_radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
        
        progressLayer.path = path.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor//填充色
        progressLayer.strokeColor = UIColor.yellow.cgColor//画笔色
        progressLayer.lineWidth = 10//线宽度
        progressLayer.lineDashPattern = [2,15]//设置虚线样式，数组
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = 0
        
        self.layer.addSublayer(progressLayer)
        
    }
    
    /// 外环
    private func drawOutsideArc() {
        
        let startAngle = -Double.pi * (5/4.0)
        let endAngle = (1/4.0) * Double.pi
        
        
        let path = UIBezierPath.init(arcCenter: m_center, radius: outside_radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = UIColor.clear.cgColor//填充色
        layer.strokeColor = UIColor(white: 1, alpha: 0.5).cgColor//画笔色
        layer.lineWidth = 10//线宽度
        layer.lineDashPattern = [2,15]//设置虚线样式，数组
        
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.duration            = 0.5;
        drawAnimation.repeatCount         = 1.0;
        drawAnimation.isRemovedOnCompletion = false;
        drawAnimation.fromValue = 0
        drawAnimation.toValue = 1
        drawAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        layer.add(drawAnimation, forKey: "strokeEnd")
        
        self.layer.addSublayer(layer)
        
    }
    
    /// 内环
    private func drawInsideArc() {
        
        let path = UIBezierPath.init(arcCenter: m_center, radius: inside_radius, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = UIColor(white: 1, alpha: 0.3).cgColor//填充色
        layer.strokeColor = UIColor.clear.cgColor//画笔色
        
        self.layer.addSublayer(layer)
    }
    
    /// 呼吸内环
    public func drawBreatheInsideArc() {
        
        breatheLayer.bounds = CGRect(x: 0, y: 0, width: breath_inside_radius, height: breath_inside_radius)
        breatheLayer.position = m_center
        
        breatheLayer.path = UIBezierPath(ovalIn: breatheLayer.bounds).cgPath
        breatheLayer.fillColor = UIColor(white: 1, alpha: 0.6).cgColor//填充色
        breatheLayer.strokeColor = UIColor.clear.cgColor//画笔色
        breatheLayer.opacity = 0.0
        
        //脉冲layer
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.instanceCount = 1
        replicatorLayer.instanceDelay = 1
        replicatorLayer.addSublayer(breatheLayer)
        self.layer.addSublayer(replicatorLayer)
        self.layer.insertSublayer(replicatorLayer, at: 0)
        
        
    }
    
    public func startAnimation() {
        
        // 透明
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1.0  // 起始值
        opacityAnimation.toValue = 0     // 结束值
        
        // 扩散动画
        let scaleAnimation = CABasicAnimation(keyPath: "transform")
        let t = CATransform3DIdentity
        scaleAnimation.fromValue = NSValue(caTransform3D: CATransform3DScale(t, 0.0, 0.0, 0.0))
        scaleAnimation.toValue = NSValue(caTransform3D: CATransform3DScale(t, 1.0, 1.0, 0.0))
        
        // 给CAShapeLayer添加组合动画
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [opacityAnimation,scaleAnimation]
        groupAnimation.duration = 2   //持续时间
        groupAnimation.autoreverses = false //循环效果
        groupAnimation.repeatCount = HUGE
        breatheLayer.add(groupAnimation, forKey: nil)
    }
    
    
    public func stopAnimation() {
        
        self.breatheLayer.removeAllAnimations()
        
        reset(animate: true)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
