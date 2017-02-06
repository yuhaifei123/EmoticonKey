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
        
        
        self!.textView.textViewAttributed(emotion: emotion, font: 17);
        /*
        //点击了删除按钮
        if emotion.removButton {
            
            //删除前面的 text
            if let selft = self{
                selft.textView.deleteBackward();
                return;
            }
        }
        
        //判断是不是emoji 表情
        if emotion.emojiStr != nil {
            
            //  self.textView.replace 替换 text
            //  self.textView.selectedTextRange 选中的 text
            self!.textView.replace(self!.textView.selectedTextRange!, withText: emotion.emojiStr!);
        }
        
        if emotion.png  != nil {
            //创建附件
            let attachment = NSTextAttachment();
            attachment.image = UIImage(contentsOfFile: emotion.imagePath!);
            attachment.bounds = CGRect(x: 0, y: -4, width: 17, height: 17);
            //根据附件，创建属性字符串
            let imageText = NSAttributedString(attachment: attachment);
            
            //强行解包
            if let text = self?.textView.text {
               
                //拿到当前所有数据 内容
                let strM = NSMutableAttributedString(attributedString: self!.textView.attributedText);
                //得到光标地址
                let rang = self!.textView.selectedRange;
                strM.replaceCharacters(in: rang, with: imageText);
                //替换数据
                self!.textView.attributedText = strM;
                
                //附件自己的字体大小
                strM.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 17), range: NSMakeRange(rang.location - 1, 1) );
                //光标 + 1 ，光标显示数量是0
                self!.textView.selectedRange = NSMakeRange(rang.location + 1, 0);
            }
        }
        */
    };
    
    deinit {
        
        print("滚");
    }
}

