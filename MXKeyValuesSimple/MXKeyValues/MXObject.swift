//
//  NSObject+KeyValues.swift
//  MXKeyValuesSimple
//
//  Created by muxiao on 2016/12/1.
//  Copyright © 2016年 muxiao. All rights reserved.
//

import Foundation

open class MXObject:NSObject{
    required  public override init() {
        super.init();
    }
}
extension MXObject{
    
    public func convertToDict() -> [String:Any]{
        var dict:[String:Any] = [:];
        properties { (name, type, value) in
            let values = self.value(forKey: name);
            let data:Any;
            if let values = values{
                if type.isObject{
                    data = (values as! MXObject).convertToDict();
                }else if type.isArray{
                    var dictM: [[String: Any]] = []
                    let modelArr = values as! NSArray
                    for item in  modelArr {
                        if item is MXObject{
                            let dict = (item as! MXObject).convertToDict()
                            dictM.append(dict);
                        }else{
                            dictM.append(item as! [String : Any]);
                        }
                    }
                    data = dictM;
                }else{
                    data = values
                }
            }else{
              data = NSNull()
            }
            dict[name] = data;
        }
        return dict;
    }
    public func mx_setKeyValues(_ keyValues:Any?){
        var originModel:MXObject?
        let classType = getSelfClassType();
        if keyValues == nil {
            originModel = classType.init()
        }else if keyValues is NSDictionary{
            let dict = keyValues as? NSDictionary;
            if let dict = dict {
                mx_setKeyValues(from:dict);
            }else{
                originModel = classType.init();
            }
        }else if keyValues is MXObject{
            originModel = keyValues as? MXObject;
            if originModel == nil {
                originModel = classType.init();
            }else{
                let modelClass = originModel?.classForCoder as? NSObject.Type;
                assert(modelClass != nil, "The type of assignment is not consistent");
                assert(modelClass == classType, "The type of assignment is not consistent");
            }
        }else{
            let dict = keyValues as? NSDictionary;
            if let dict = dict {
                mx_setKeyValues(from:dict);
            }else{
                originModel = classType.init();
            }
        }
        if let originModel = originModel {
            self.properties({ (name, type, value) in
                self.setValue(originModel.value(forKeyPath: name), forKey: name);
            }
            )
        }
    }
    
    public func mx_setKeyValues(from dict:NSDictionary){
        let classType = getSelfClassType();
        let simpleModel = classType.init();
        properties { (name, type, value) in
            let dataDictHasKey = dict[name] != nil;
            if dataDictHasKey {
                if dict[name] is NSNull{
                    self.setValue(simpleModel.value(forKey: name), forKey: name);
                }else{
                    if !type.isArray{
                        if !type.isObject{
                            if type.typeClass == Bool.self{
                                self.setValue((dict[name] as AnyObject).boolValue, forKey: name);
                            }else {
                                self.setValue(dict[name], forKey: name)
                            }
                        }else{
                            let dictValue = dict[name];
                            let modelValue = self.value(forKey: name) as? MXObject;
                            if let modelValue =  modelValue {
                                modelValue.mx_setKeyValues(dictValue);
                            }else{
                                let className = ClassFromString(type.typeName) as! MXObject.Type;
                                let model = className.init();
                                model.mx_setKeyValues(dictValue);
                                self.setValue(model, forKey: name)
                            }
                        }
                    }else{
                        if let res = type.isAggregate(){
                            var arrAggregate:[Any] = []
                            if res is Int.Type {
                                arrAggregate = parseAggregateArray(dict[name] as! NSArray, basicType: MXBasicType.Int, ins: 0)
                            }else if res is Float.Type {
                                arrAggregate = parseAggregateArray(dict[name] as! NSArray, basicType: MXBasicType.Float, ins: 0.0)
                            }else if res is Double.Type {
                                arrAggregate = parseAggregateArray(dict[name] as! NSArray, basicType: MXBasicType.Double, ins: 0.0)
                            }else if res is String.Type {
                                arrAggregate = parseAggregateArray(dict[name] as! NSArray, basicType: MXBasicType.String, ins: "")
                            }else if res is NSNumber.Type {
                                arrAggregate = parseAggregateArray(dict[name] as! NSArray, basicType: MXBasicType.NSNumber, ins: NSNumber())
                            }else{
                                arrAggregate = dict[name] as! [AnyObject]
                            }
                            self.setValue(arrAggregate, forKeyPath: name)
                        }else{
                            let elementModelType =  type.makeClass() as? MXObject.Type
                            let dictKeyArr = dict[name] as! NSArray
                            if elementModelType == nil{
                                self.setValue(dictKeyArr, forKeyPath: name)
                            }else{
                                var arrM: [MXObject] = []
                                for (_, value) in dictKeyArr.enumerated() {
                                    let elementModel = elementModelType!.init();
                                    elementModel.mx_setKeyValues(value);
                                    arrM.append(elementModel)
                                }
                                self.setValue(arrM, forKeyPath: name)
                            }
                        }
                    }
                }
            }
       }
    }
}

fileprivate extension MXObject{
    func properties(_ property:@escaping(String, MXValueType, Any) -> Void)  {
        for propertyItem in Mirror(reflecting: self).children {
            guard let propertyNameString = propertyItem.label else {
                assert(false, "propertyItem.label is nil")
                return;
            }
            let value = propertyItem.value;
            let valueType = MXValueType(Mirror(reflecting: value), belongType: type(of: self))
            property(propertyNameString, valueType, value);
            
        }
    }
    
    func getSelfClassType() -> MXObject.Type {
        let selfType =   Mirror(reflecting: self);
        let selfClass = selfType.subjectType as? MXObject.Type;
        assert(selfClass != nil, "get classType error");
        let classType = selfClass!;
        return classType;
    }
    
}



