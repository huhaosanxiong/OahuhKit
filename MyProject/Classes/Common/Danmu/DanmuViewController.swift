//
//  DanmuViewController.swift
//  MyProject
//
//  Created by huhsx on 2020/6/12.
//  Copyright © 2020 胡浩三雄. All rights reserved.
//

import UIKit

class DanmuViewController: BaseViewController {
    
    var timer: Timer?
    
    var queue = OperationQueue()
    
    var count = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Danmu"
        
        view.backgroundColor = .black
        
        // 需要写在addOperation之前
        queue.maxConcurrentOperationCount = 20
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        timer?.invalidate()
        timer = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        queue.cancelAllOperations()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if timer != nil {
            return
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc func timerAction() {
        
//        let operation = DamuOperaion(view: view)
//        operation.index = i
//        queue.addOperation(operation)
        
        if arc4random()%3 == 0 {
            return
        }
        
        queue.addOperation { [weak self] in
            
            DLog(Thread.current)
            
            self?.count += 1
            
            DispatchQueue.main.async {
                self?.labelAnimation(text: "第\(self?.count ?? -1)条弹幕")
            }
            
            Thread.sleep(forTimeInterval: 3)
        }
    }
    
    func labelAnimation(text: String) {
        
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.text = text
        label.sizeToFit()
        
        view.addSubview(label)
        
        let original = CGRect(x: view.bounds.size.width, y: 100.0 + CGFloat(arc4random()%500), width: label.bounds.size.width, height: label.bounds.size.height)
        let end = CGRect(x: -label.bounds.size.width, y: original.origin.y, width: label.bounds.size.width, height: label.bounds.size.height)
        
        label.frame = original
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = NSValue(cgRect: original)
        animation.toValue = NSValue(cgRect: end)
        animation.duration = 3
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        label.layer.add(animation, forKey: "move")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            label.removeFromSuperview()
        }
    }
    
}


//class DamuOperaion: Operation {
//
//    weak var superView: UIView!
//
//    private lazy var titleLabel: UILabel = {
//
//        let label = UILabel()
//        label.backgroundColor = .white
//        label.textColor = .black
//
//        return label
//    }()
//
//    public var index = 0
//
//    init(view: UIView) {
//        super.init()
//
//        superView = view
//    }
//
//    override func main() {
//
//        DLog(Thread.current)
//        DLog("第\(index)条弹幕发射")
//
//        DispatchQueue.main.async {
//            self.titleLabel.text = "DamuOperaion"
//            self.superView.addSubview(self.titleLabel)
//            self.titleLabel.sizeToFit()
//
//            let original = CGRect(x: self.superView.bounds.size.width, y: 100.0 + CGFloat(arc4random()%400), width: self.titleLabel.bounds.size.width, height: self.titleLabel.bounds.size.height)
//            let end = CGRect(x: -self.titleLabel.bounds.size.width, y: original.origin.y, width: self.titleLabel.bounds.size.width, height: self.titleLabel.bounds.size.height)
//
//            self.titleLabel.frame = original
//
//            let animation = CABasicAnimation(keyPath: "position")
//            animation.fromValue = NSValue(cgRect: original)
//            animation.toValue = NSValue(cgRect: end)
//            animation.duration = 3
//            animation.isRemovedOnCompletion = false
//            animation.fillMode = .forwards
//            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
//
//            self.titleLabel.layer.add(animation, forKey: "move")
//
//
//        }
//
//        Thread.sleep(forTimeInterval: 3)
//
//
//    }
//}
