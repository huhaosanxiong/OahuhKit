//
//  LeetCode_70_Controller.swift
//  MyProject
//
//  Created by huhsx on 2020/8/4.
//  Copyright © 2020 胡浩三雄. All rights reserved.
//

import UIKit

/*
 假设你正在爬楼梯。需要 n 阶你才能到达楼顶。

 每次你可以爬 1 或 2 个台阶。你有多少种不同的方法可以爬到楼顶呢？

 注意：给定 n 是一个正整数。
 */

class LeetCode_70_Controller: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        print(Solution().climbStairs(10))
    }
    


    class Solution {
        
        /*
        func climbStairs(_ n: Int) -> Int {
            
            if n == 0 {
                return 0
            }
            
            var d = Array(repeating: 0, count: n + 1)
            d[0] = 1
            d[1] = 1
            
            for i in 2...n {
                d[i] = d[i - 1] + d[i - 2]
            }
            
            return d[n]
        }
 */
        //滚动数组 降低空间复杂度
        func climbStairs(_ n: Int) -> Int {
            
            var p = 0
            var q = 0
            var r = 1
            
            for _ in 0..<n {
                p = q
                q = r
                r = p + q
            }
            
            return r
        }
    }
    
}

