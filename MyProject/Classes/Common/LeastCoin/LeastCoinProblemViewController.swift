//
//  LeastCoinProblemViewController.swift
//  MyProject
//
//  Created by huhsx on 2020/7/9.
//  Copyright © 2020 胡浩三雄. All rights reserved.
//

import UIKit

class LeastCoinProblemViewController: BaseViewController {

    let textView: UITextView = {
        
        let view = UITextView()
        
        return view
    }()
    
    
    /// 每个金额[0...total]所需要的硬币数数组
    private var d: [Int] = []
    /// 指定面值的硬币
    private var coins = [1, 3, 5, 7]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "LeastCoin"
        
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        go(total: 50)
    
    }
    
    /// 获取所需要的硬币数数组
    /// - Parameter total: 指定金额
    func go(total: Int) {
        
        d = Array(repeating: 100, count: total + 1)
        // 金额为0时，所需0个
        d[0] = 0
        
        d_func(num: total)

    }
    
    private func d_func(num: Int) {
        
        for currentMoney in 1...num {
            
            for coin in coins {
                
                if currentMoney >= coin  {
                    
                    // f(1) = 1, f(2) = 2, f(3) = 1, f(4) = f(3) + 1 种, f(5) = 1 ... 以此类推
                    d[currentMoney] = min(d[currentMoney], d[currentMoney - coin] + 1)
                }
            }
        }
        
        for i in 0...num {
            
            let log = "凑齐\(i)元需要\(d[i])个硬币"
            textView.text = textView.text + log + "\n"
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
