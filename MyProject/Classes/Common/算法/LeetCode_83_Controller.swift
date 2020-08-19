//
//  LeetCode_83_Controller.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2020/8/19.
//  Copyright © 2020 胡浩三雄. All rights reserved.
//

/*
83. 删除排序链表中的重复元素
给定一个排序链表，删除所有重复的元素，使得每个元素只出现一次。

示例 1:

输入: 1->1->2
输出: 1->2
示例 2:

输入: 1->1->2->3->3
输出: 1->2->3

来源：力扣（LeetCode）
链接：https://leetcode-cn.com/problems/remove-duplicates-from-sorted-list
著作权归领扣网络所有。商业转载请联系官方授权，非商业转载请注明出处。
 */

import UIKit

class LeetCode_83_Controller: UIViewController {
    
    class Solution {
        func deleteDuplicates(_ head: ListNode?) -> ListNode? {
            
            guard let value = head else { return nil }
            var current = value

            while current.next != nil {
                if current.val == current.next!.val {
                    if let nextnext = current.next!.next {
                         current.next! = nextnext
                    }else {
                        current.next = nil
                    }
                   
                }else {
                    current = current.next!
                }
            }
            return value
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let node = ListNode(1)
        node.next = ListNode(1)
        node.next?.next = ListNode(2)
        node.next?.next?.next = ListNode(3)
        node.next?.next?.next?.next = ListNode(3)
        
        let res = Solution().deleteDuplicates(node)
        print(res)

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
