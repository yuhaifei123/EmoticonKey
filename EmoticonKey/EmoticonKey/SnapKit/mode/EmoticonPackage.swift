//
//  EmoticonPackage.swift
//  EmoticonKey
//
//  Created by 虞海飞 on 2017/2/1.
//  Copyright © 2017年 虞海飞. All rights reserved.
//

import UIKit
/*
 结构:
 1. 加载emoticons.plist拿到每组表情的路径
 
 emoticons.plist(字典)  存储了所有组表情的数据
 |----packages(字典数组)
 |-------id(存储了对应组表情对应的文件夹)
 
 2. 根据拿到的路径加载对应组表情的info.plist
 info.plist(字典)
 |----id(当前组表情文件夹的名称)
 |----group_name_cn(组的名称)
 |----emoticons(字典数组, 里面存储了所有表情)
 |----chs(表情对应的文字)
 |----png(表情对应的图片)
 |----code(emoji表情对应的十六进制字符串)
 */
class EmoticonPackage: NSObject {

    //变成单例，这样可以降低性能
    static let staticLoadPackages : [EmoticonPackage] = loadPackages();
    
    /// 当前组表情文件夹的名称
    var id: String?
    /// 组的名称
    var group_name_cn : String?
    /// 当前组所有的表情对象
    var emoticons: [Emoticon]?
    
    /// 获取所有组的表情数组
    // 浪小花 -> 一组  -> 所有的表情模型(emoticons)
    // 默认 -> 一组  -> 所有的表情模型(emoticons)
    // emoji -> 一组  -> 所有的表情模型(emoticons)
    private class func loadPackages() -> [EmoticonPackage] {
        
        //创建数据
        var packages = [EmoticonPackage]();
        
        //添加最近组
        let pk = EmoticonPackage(id: "");
        pk.group_name_cn = "最近";
        pk.emoticons = [Emoticon]();
        pk.appendEmtyEmoticons();
        packages.append(pk);
        
        let path = Bundle.main.path(forResource: "emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")
       
        // 1.加载emoticons.plist
        let dict = NSDictionary(contentsOfFile: path!)!
        // 2.或emoticons中获取packages
        let dictArray = dict["packages"] as! [[String:AnyObject]]
        // 3.遍历packages数组
        for d in dictArray{
            // 4.取出ID, 创建对应的组
            let package = EmoticonPackage(id: d["id"]! as! String)
            packages.append(package)
            package.loadEmoticons();
            package.appendEmtyEmoticons();
        }
        
        return packages
    }
    
    /// 加载每一组中所有的表情
    func loadEmoticons() {
        
        let emoticonDict = NSDictionary(contentsOfFile: infoPath(fileName: "info.plist"))!
        group_name_cn = emoticonDict["group_name_cn"] as? String
        let dictArray = emoticonDict["emoticons"] as! [[String: String]]
        emoticons = [Emoticon]();
        
        //每个21就加删除按钮
        var nub = 0;
        for dict in dictArray{
            
            if nub == 20{
                
                emoticons!.append(Emoticon.init(removButton: true));
                nub = 0;
            }
            
            emoticons!.append(Emoticon(dict: dict, id: id!))
            nub = nub+1;
        }
    }
    
    /// 添加删除按钮
    func appendEmtyEmoticons(){
        
        if let num = emoticons{
            let count = num.count % 21;
            
            for _ in count ..< 20 {
                //添加空，不是删除按钮
                emoticons!.append(Emoticon.init(removButton: false));
            }
            
            //最后加上删除按钮
            emoticons!.append(Emoticon.init(removButton: true));
        }
    }
    
    
    /// 添加个人喜欢
    func appendEmoticon(emotion : Emoticon){
        
        //判断是不是删除按钮
        if emotion.removButton {
            return;
        }
        
        
        let contains = emoticons?.contains(emotion);
        //判断里面是不是包含这个图形
        if contains == false {
            
            //删除『删除按钮』 最后一个
            emoticons?.removeLast();
            //添加一个图标
            emoticons?.append(emotion);
        }
    
        var result = emoticons!.sorted { (e1, e2) -> Bool in
            return e1.times > e2.times;
        }
     
        //判断里面是不是包含这个图形，包含的，把多余的图形删除，添加删除按钮
        if contains == false {
     
            //删除最后一个数据
            result.removeLast();
            //添加删除按钮
            result.append(Emoticon.init(removButton: true));
        }
        
        emoticons = result;
    }
    
    /**
     获取指定文件的全路径
     
     :param: fileName 文件的名称
     
     :returns: 全路径
     */
    func infoPath(fileName: String) -> String {
        return (EmoticonPackage.emoticonPath().appendingPathComponent(id!) as NSString).appendingPathComponent(fileName)
    }
    /// 获取微博表情的主路径
    class func emoticonPath() -> NSString{
        return (Bundle.main.bundlePath as NSString).appendingPathComponent("Emoticons.bundle") as NSString
    }
    
    init(id: String)
    {
        self.id = id
    }
}

class Emoticon: NSObject {
    /// 表情对应的文字
    var chs: String?
    /// 表情对应的图片
    var png: String?;
    /// emoji表情对应的十六进制字符串
    var code: String?;
    //emoji 表情
    var emojiStr: String?;
    /// 当前表情对应的文件夹
    var id: String?
    /// 删除按钮
    var removButton : Bool = false;
    /// 点击次数
    var times : Int = 0;
    
    /// 表情图片的全路径
    var imagePath: String?
    
    init(removButton : Bool) {
        super.init();
        
        self.removButton = removButton;
    }
    
    init(dict: [String: String], id: String){
        super.init();
        
        self.id = id
        
        self.chs = dict["chs"];
        self.png = dict["png"];
        self.code = dict["code"];
        self.emojiStr = dict["emojiStr"];
      
        //setValuesForKeys(dict);
        if self.png != nil {
                self.imagePath = (EmoticonPackage.emoticonPath().appendingPathComponent(id) as NSString).appendingPathComponent(png!)
        }
       
        //十六进制转化
        if dict["code"] != nil {
            
            // 1.从字符串中取出十六进制的数
            // 创建一个扫描器, 扫描器可以从字符串中提取我们想要的数据
            let scanner = Scanner(string: dict["code"]!)
            
            // 2.将十六进制转换为字符串
            var result:UInt32 = 0
            scanner.scanHexInt32(&result)
            
            // 3.将十六进制转换为emoji字符串
            emojiStr = "\(Character(UnicodeScalar(result)!))"
        }
    }
    
    override func setValuesForKeys(_ keyedValues: [String : Any]) {
        
    }
}

