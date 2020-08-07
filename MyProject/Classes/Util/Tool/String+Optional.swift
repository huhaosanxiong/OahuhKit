//
//  String+Optional.swift
//  MyProject
//
//  Created by huhsx on 2020/8/4.
//  Copyright © 2020 胡浩三雄. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    var safeString: String {
        return self ?? ""
    }
}
