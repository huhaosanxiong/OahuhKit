//
//  LeetCode_7_Controller.swift
//  MyProject
//
//  Created by huhsx on 2020/8/4.
//  Copyright © 2020 胡浩三雄. All rights reserved.
//

import UIKit

/*
给出一个 32 位的有符号整数，你需要将这个整数中每位上的数字进行反转。

示例 1:

输入: 123
输出: 321
 示例 2:

输入: -123
输出: -321
示例 3:

输入: 120
输出: 21

来源：力扣（LeetCode）
链接：https://leetcode-cn.com/problems/reverse-integer
著作权归领扣网络所有。商业转载请联系官方授权，非商业转载请注明出处。
*/
class LeetCode_7_Controller: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        print(Solution().reverse(4321))
        print(Solution().reverse(-1234))
    }
    

}

class Solution {
    
    func reverse(_ x: Int) -> Int {
        
        var number = x
        var temp = 0
        
        while number != 0 {
            
            // 取得个位
            let unit = number % 10
            // 移除个位
            number = number / 10
            
            temp = temp * 10 + unit
        }
        
        if temp > Int32.max || temp < Int32.min {
            return 0
        }
        
        return temp
    }
}
