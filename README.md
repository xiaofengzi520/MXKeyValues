# MXKeyValues

### 转换速度快、使用简单方便的字典转模型的swift框架

### 只适配与Xcode8 & swift 3.0

### 功能:
1. 主要是字典和模型的互转,同类型的模型,也可以按key迅速赋值.

### 使用:

例子如下:

```
class User: MXObject {
    
    var userId:String! 
    var nickName:String = ""
    var photoUrl:String?
    var sex:UInt = 0
    var isFirstRegister:Bool = true
    var totalFee:Int = 0
    var videoAuth:Bool = false
    var bindGameList:[PTGame] = []
    var userPictures:[String:Any]
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}


let user = User();
user.mx_setKeyValues(data);

```
主要方法:

```
    public func convertToDict() -> [String : Any]

    public func mx_setKeyValues(_ keyValues: Any?)

    public func mx_setKeyValues(from dict: NSDictionary)
```

1. 所有模型对象都需要继承于MXObject.
2. 所有基本数据类型如Int,float等,不可为Optional,必须赋初值
3. 切记,对于属性有声明为2的情况,或者声明成了常量,必须实现建议实现func setValue(_ value: Any?, forUndefinedKey key: String)方法.
4. 通过字典给模型赋值时,只对不为value不为nil的key进行赋值,如果是null,会对属性赋初值  


**推荐所有的属性都使用默认值，能够避免在原始数据错误时，过多的可选判断或空对象崩溃
 **


 
