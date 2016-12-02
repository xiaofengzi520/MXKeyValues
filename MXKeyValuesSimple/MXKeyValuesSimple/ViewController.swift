//
//  ViewController.swift
//  MXKeyValuesSimple
//
//  Created by muxiao on 2016/12/1.
//  Copyright © 2016年 muxiao. All rights reserved.
//

import UIKit
import MXKeyValues

class People:MXObject{
    var name:String = ""
    var sex:Int = 1
    var hello:Bool = true
    var shencai:Shencai?;
    var games:[Game]?;
    var n:String = "";
}

class Shencai:MXObject{
    var height:Int = 0
    var width:Int = 0
}

class Game:MXObject{
    var name:String = ""
}

let data = ["name":"muxiao",
            "sex":2,
            "hello":false,
            "shencai":["height":20, "width":100],
            "games":[
                ["name":"wangzhe"],
                ["name":"hello"],
    ]
    ] as [String : Any]

let data1 = ["name":"muxiao",
            "sex": NSNull(),
            "hello":false,
            "shencai":["height":20, "width":100],
            "games":[
                ["name":"wangzhe"],
                ["name":"hello"],
    ]
    ] as [String : Any]


class TestModel: MXObject {
    var name:String = ""
    override func setValue(_ value: Any?, forKey key: String) {
        
    }
}


class PTGame: MXObject {
    
    var id:String = ""
    var gameName:String = ""
    var icon:String = ""
    var gameAliasName:String = ""
    
}

class PTUser: MXObject {
    
    var authKey:String?
    var userId:String = ""
    var nickName:String = ""
    var photoUrl:String = ""
    var sex:UInt = 0
    var phone:String = ""
    var goldNum:Int = 0
    var lastLoginTime:TimeInterval = Date().timeIntervalSince1970 * 1000
    var fansNum:Int = 0
    var followNum:Int = 0
    var signature:String = ""
    var totalConsume:Int = 0
    var concurrentTime:Int = 0
    var isFirstRegister:Bool = true
    var totalFee:Int = 0
    var alipayAccount:String = ""
    var openId:String = ""
    var playFee:Int = 0
    var constellation:String = ""
    var bigGod:Int = 0
    var girlAuth:Bool = false
    var funny:Int = 0
    var videoAuth:Bool = false
    var nickNameOnPhone:String = ""
    var bindGameList:[PTGame] = []
    var userPictures:NSArray?
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}


class Test1Model: MXObject {
    var sex:Int = 1;
}
class ViewController: UIViewController {
    var className:NSString!
    var sex:Int! = 1;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let  people  = People();
        people.mx_setKeyValues(data);
        
        people.mx_setKeyValues(data1);
        let url =  URL(string: "http://test.api.xiugr.com:8080/pig-server-service/restful/account/getUserProfile?userId=10002")!
        let request = URLRequest(url: url)
        let urlsession = URLSession.shared;
        let user = PTUser();
//
//        
        print(user.convertToDict());
        let dataTask = urlsession.dataTask(with: request, completionHandler: {
            data, response, error in
            let jsonDict = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            let dict = jsonDict as! NSDictionary;
            user.mx_setKeyValues(from: dict["result"] as! NSDictionary)
            print(user.convertToDict());
            
        })
////        setValue(1, forKey: "sex");
//        
        dataTask.resume();
//        let test = TestModel();
//        test.mx_setKeyValues(TestModel());
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

