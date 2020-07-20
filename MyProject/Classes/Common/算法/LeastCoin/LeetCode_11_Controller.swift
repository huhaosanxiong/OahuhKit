//
//  LeetCode_11_Controller.swift
//  MyProject
//
//  Created by huhsx on 2020/7/17.
//  Copyright © 2020 胡浩三雄. All rights reserved.
//

import UIKit

class LeetCode_11_Controller: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        DLog(maxArea([1,8,6,2,5,4,8,3,7]))
    }
    
    /// 双指针解法
    func maxArea(_ height: [Int]) -> Int {
        
        var maxArea = 0
        var i = 0
        var j = height.count - 1
        
        while i < j {
            
            maxArea = max(maxArea, (j - i)*(min(height[i], height[j])))
            
            if height[i] < height[j] {
                i+=1
            }else {
                j-=1
            }
        }
        
        return maxArea
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
