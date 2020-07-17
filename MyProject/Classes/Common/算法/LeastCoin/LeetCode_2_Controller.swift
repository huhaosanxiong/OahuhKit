//
//  LeetCode_2_Controller.swift
//  MyProject
//
//  Created by huhsx on 2020/7/17.
//  Copyright © 2020 胡浩三雄. All rights reserved.
//

import UIKit

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

class LeetCode_2_Controller: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let l1 = ListNode(2)
        let l2 = ListNode(4)
        let l3 = ListNode(3)
        
        l1.next = l2
        l2.next = l3
        
        let r1 = ListNode(5)
        let r2 = ListNode(6)
        let r3 = ListNode(4)
        
        r1.next = r2
        r2.next = r3
        
        let _ = addTwoNumbers(l1, r1)
        
        
    }
    
    /*
     输入：(2 -> 4 -> 3) + (5 -> 6 -> 4)
     输出：7 -> 0 -> 8
     原因：342 + 465 = 807
     */
    func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        
        let result = ListNode(0)
        
        var left = l1
        var right = l2
        
        //
        var nextNode = result
        
        DLog("first time nextNode = \(Unmanaged<AnyObject>.passUnretained(nextNode as AnyObject).toOpaque())")
        DLog("first time result = \(Unmanaged<AnyObject>.passUnretained(result as AnyObject).toOpaque())")
        
        // 进位
        var carry = 0
        
        while left != nil && right != nil {
            
            let leftVal = left?.val ?? 0
            let rightVal = right?.val ?? 0
            
            let sum = leftVal + rightVal + carry
            carry = sum/10
            
            let next = ListNode(sum%10)
            nextNode.next = next
            nextNode = next
            
            DLog("nextNode = \(Unmanaged<AnyObject>.passUnretained(nextNode as AnyObject).toOpaque())")
            DLog("result = \(Unmanaged<AnyObject>.passUnretained(result as AnyObject).toOpaque())")
            
            left = left?.next
            right = right?.next
            
        }
        
        if carry > 0 {
            nextNode.next = ListNode(1)
        }
        
        return result.next
    }
    

}
