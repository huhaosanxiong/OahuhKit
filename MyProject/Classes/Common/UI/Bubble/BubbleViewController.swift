//
//  BubbleViewController.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/8/2.
//  Copyright © 2018 胡浩三雄. All rights reserved.
//

import UIKit

class BubbleViewController: BaseViewController {
    
    var disposeBag : DisposeBag = DisposeBag()
    
    var resetButton : UIButton!
    
    
    lazy var backgroundView :UIView = {
        
        let view = UIView()
        
        view.backgroundColor = UIColor.black
        
        self.view.addSubview(view)
        
        return view
        
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // UI适配
        if self.responds(to: #selector(getter: UIViewController.edgesForExtendedLayout)){
            self.edgesForExtendedLayout = []
        }
    }
    
    override func initSubviews() {
        
        resetButton = UIButton()
        resetButton.setTitle("reset", for: .normal)
        resetButton.backgroundColor = UIColor.green
        resetButton.rx.tap.subscribe(onNext:{ [weak self] _ in
            for view in (self?.backgroundView.subviews)! {
                view.removeFromSuperview()
            }
            self?.buildBubbles()
        }).disposed(by: disposeBag)
        view.addSubview(resetButton)
        
        backgroundView.snp.makeConstraints { make in
            make.left.top.right.equalTo(self.view)
            make.height.equalTo(350)
        }
        
        resetButton.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.bottom).offset(50)
            make.centerX.equalTo(backgroundView.snp.centerX)
            make.width.height.equalTo(50)
        }
        
        buildBubbles()
    }
    
    func buildBubbles() {
        
        let count :Int = 8
        
        let spaceX :Float = (Float(SCREEN_WIDTH)-2*Float(BUBBLEDIAMETER))/Float(count-1)
        let spaceY :Float = (350-2*Float(BUBBLEDIAMETER))/Float(count-1)
        
        let arrayX = returnDiffArray(min: 1, max: count)
        let arrayY = returnDiffArray(min: 1, max: count)
        
        for (index, i) in arrayX.enumerated() {
            
            let bubble = BubbleView.init(title: "", value: String(i))
            bubble.frame = CGRect(x: 0, y: 0, width: BUBBLEDIAMETER, height: BUBBLEDIAMETER)
            bubble.center = CGPoint(x: CGFloat(Float(i)*spaceX), y: CGFloat(Float(arrayY[index])*spaceY))
            backgroundView.addSubview(bubble)
            
            DLog(bubble.button)
            
            bubble.button.rx.tap.subscribe(onNext : {
                
                UIView.animate(withDuration: 1.0, animations: {
                    bubble.frame = CGRect(x: 0, y: 350-BUBBLEDIAMETER, width: BUBBLEDIAMETER, height: BUBBLEDIAMETER)
                    bubble.alpha = 0
                } ,completion: { _ in
                    bubble.removeFromSuperview()
                })
                
            }).disposed(by: bubble.disposeBag)
            
            let seed = Int(arc4random_uniform(UInt32(2)))
            let offset = (seed>0) ? 5 : -5
            
            bubble.alpha = 0
            UIView.animate(withDuration: 0.5) {
                bubble.alpha = 1
            }
            
            UIView.animate(withDuration: 0.6, delay: 0.4, options: [.repeat, .autoreverse, .allowUserInteraction],
                           animations: {
                            bubble.frame.origin.y = bubble.frame.origin.y+CGFloat(offset)


            },completion: nil)

        }
    
    }
    
    func returnDiffArray(min: Int, max: Int) -> Array<Int> {
        
        var array : [Int] = [Int]()
        var value : [Int] = [Int]()
        
        for i in min...max {
            array.append(i)
        }
        
        while array.count > 0 {
            
            let index = Int(arc4random_uniform(UInt32(array.count)))
            value.append(array[index])
            array.remove(at: index)
        }
        
        return value
    }

}
