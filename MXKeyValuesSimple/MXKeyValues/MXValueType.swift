//
//  MXValueType.swift
//  MXKeyValuesSimple
//
//  Created by muxiao on 2016/12/1.
//  Copyright © 2016年 muxiao. All rights reserved.
//

import Foundation

enum MXRealType:String {
    case None = "None"
    case Int = "Int"
    case Float = "Float"
    case Double = "Double"
    case String = "String"
    case Bool = "Bool"
    case Class = "Class"
}

enum MXBasicType: String{
    
    case String
    case Int
    case Float
    case Double
    case Bool
    case NSNumber
}

class MXValueType {
    var typeName:String!
    var typeClass:Any.Type!
    var displayStyle:Mirror.DisplayStyle!
    var displayStyleDesc:String!
    var belongType: Any.Type!
    var isOptional:Bool = false;
    var isArray:Bool = false;
    var isObject:Bool = false;
    var realType:MXRealType = .None
    fileprivate var propertyMirrorType:Mirror
    init(_ propertyMirrorType:Mirror, belongType:Any.Type) {
        self.propertyMirrorType = propertyMirrorType;
        self.belongType = belongType;
        parseBegin();
        
    }
    
    func isAggregate() -> Any!{
        
        var res: Any! = nil
        
        for (typeStr, type) in aggregateTypes {
            
            if typeName.contain(subStr: typeStr) {res = type}
        }
        
        return res
    }
    
    func makeClass() ->AnyClass?{
        let arrayString = self.typeName
        let clsString = arrayString?.replacingOccurrencesOfString("Array<", withString: "").replacingOccurrencesOfString("Optional<", withString: "").replacingOccurrencesOfString(">", withString: "")
        var cls: AnyClass? = ClassFromString(clsString!)
        if cls == nil && self.isObject {
            let nameSpaceString = "\(self.belongType).\(clsString)"
            cls = ClassFromString(nameSpaceString)
        }
        return cls
    }
}

fileprivate extension MXValueType{
    func parseBegin() {
        parseTypeName()
        parseTypeClass()
        parseTypedisplayStyle()
        parseTypedisplayStyleDesc()
    }
    
    func parseTypeName() {
        typeName = "\(propertyMirrorType.subjectType)".deleteSpecialStr()
    }
    
    func parseTypeClass() {
        typeClass = propertyMirrorType.subjectType
    }
    func parseTypedisplayStyle()  {
        displayStyle = propertyMirrorType.displayStyle
        if displayStyle == nil && basicTypes.contains(typeName) {displayStyle = .struct}
        if extraTypes.contains(typeName) {displayStyle = .struct}
    }
    func parseTypedisplayStyleDesc() {
        if displayStyle == nil {return}
        switch displayStyle! {
        case .struct: displayStyleDesc = "Struct"
        case .class: displayStyleDesc = "Class"
        case .optional: displayStyleDesc = "Optional"; isOptional = true;
        case .enum: displayStyleDesc = "Enum"
        case .tuple: displayStyleDesc = "Tuple"
        default: displayStyleDesc = "Other: Collection/Dictionary/Set"
        }
        fetchRealType()
    }
}

fileprivate extension MXValueType{
    var basicTypes: [String] {return ["String", "Int", "Float", "Double", "Bool"]}
    var extraTypes: [String] {return ["__NSCFNumber", "_NSContiguousString", "NSTaggedPointerString"]}
    var aggregateTypes: [String: Any.Type] {return ["String": String.self, "Int": Int.self, "Float": Float.self, "Double": Double.self, "Bool": Bool.self, "NSNumber": NSNumber.self]}
    
    func fetchRealType(){
        if typeName.contain(subStr: "Array") {isArray = true}
        if typeName.contain(subStr: "Int") {realType = MXRealType.Int}
        else if typeName.contain(subStr: "Float") {realType = MXRealType.Float}
        else if typeName.contain(subStr: "Double") {realType = MXRealType.Double}
        else if typeName.contain(subStr: "String") {realType = MXRealType.String}
        else if typeName.contain(subStr: "Bool") {realType = MXRealType.Bool}
        else {realType = MXRealType.Class}
        let objectClass = ClassFromString(typeName) as? MXObject.Type
        if  objectClass != nil {
            isObject = true
        }
    }

}
