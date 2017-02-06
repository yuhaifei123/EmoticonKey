//
//  ViewController.swift
//  EmoticonKey
//
//  Created by 虞海飞 on 2017/1/24.
//  Copyright © 2017年 虞海飞. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
         // 1.将键盘控制器添加为当前控制器的子控制器
        self.addChildViewController(emoticon);
        
        // 2.将表情键盘控制器的view设置为UITextView的inputView
        self.textView.inputView = emoticon.view;
        
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    private lazy var emoticon : EmoticonViewController = EmoticonViewController.init { [weak self] (emotion) in
        
        //判断是不是emoji 表情
        if emotion.emojiStr != nil {
            
            //  self.textView.replace 替换 text
            //  self.textView.selectedTextRange 选中的 text
            self!.textView.replace(self!.textView.selectedTextRange!, withText: emotion.emojiStr!);
        }
    };
    
    deinit {
        
        print("滚");
    }
}

