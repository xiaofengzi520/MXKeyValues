//
//  MXUtils.swift
//  MXKeyValuesSimple
//
//  Created by muxiao on 2016/12/2.
//  Copyright © 2016年 muxiao. All rights reserved.
//

import Foundation

func parseAggregateArray<T>(_ arrDict: NSArray,basicType: MXBasicType, ins: T) -> [T]{
    
    var intArrM: [T] = []
    
    if arrDict.count == 0 {return intArrM}
    
    for (_, value) in arrDict.enumerated() {
        
        var element: T = ins
        
        let v = "\(value)"
        
        
        
        if T.self is Int.Type {
            element = Int(Float(v)!) as! T
        }
        else if T.self is Float.Type {element = v.floatValue as! T}
        else if T.self is Double.Type {element = v.doubleValue as! T}
        else if T.self is NSNumber.Type {element = NSNumber(value: v.doubleValue! as Double) as! T}
        else{element = value as! T}
        intArrM.append(element)
    }
    
    return intArrM
}

func ClassFromString(_ str: String) -> AnyClass!{
    
    if  var appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
        
        if appName == "" {appName = ((Bundle.main.bundleIdentifier!).characters.split{$0 == "."}.map { String($0) }).last ?? ""}
        
        var clsStr = str
        
        if !str.contain(subStr: "\(appName)."){
            clsStr = appName + "." + str
        }
        
        let strArr = clsStr.explode(".")
        
        var className = ""
        
        let num = strArr.count
        
        if num > 2 || strArr.contains(appName) {
            
            var nameStringM = "_TtC" + "C".repeatTimes(num - 2)
            
            for (_, s): (Int, String) in strArr.enumerated(){
                
                nameStringM += "\(s.characters.count)\(s)"
            }
            
            className = nameStringM
            
        }else{
            
            className = clsStr
        }
        
        return NSClassFromString(className)
    }
    
    return nil;
}
