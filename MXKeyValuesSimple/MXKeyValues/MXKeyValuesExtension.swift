//
//  MXKeyValuesExtension.swift
//  MXKeyValuesSimple
//
//  Created by muxiao on 2016/12/2.
//  Copyright © 2016年 muxiao. All rights reserved.
//

import Foundation

extension String{
    func deleteSpecialStr() -> String {
        return self.replacingOccurrencesOfString("Optional<", withString: "").replacingOccurrencesOfString(">", withString: "")
    }
    func replacingOccurrencesOfString(_ target: String, withString: String) -> String{
        return (self as NSString).replacingOccurrences(of: target, with: withString)
    }
    
    func contain(subStr: String) -> Bool {return (self as NSString).range(of: subStr).length > 0}
    var floatValue: Float? {return NumberFormatter().number(from: self)?.floatValue}
    var doubleValue: Double? {return NumberFormatter().number(from: self)?.doubleValue}
    func explode (_ separator: Character) -> [String] {
        return self.characters.split(whereSeparator: { (element: Character) -> Bool in
            return element == separator
        }).map { String($0) }
    }
    func repeatTimes(_ times: Int) -> String{
        
        var strM = ""
        
        for _ in 0..<times {
            strM += self
        }
        
        return strM
    }

}
