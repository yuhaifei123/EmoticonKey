//
//  UITextView+Tool.swift
//  EmoticonKey
//
//  Created by 虞海飞 on 2017/2/6.
//  Copyright © 2017年 虞海飞. All rights reserved.
//

import UIKit

extension UITextView {
    
    /// 分类 textView的附件功能
    func textViewAttributed(emotion : Emoticon, font : Int){
        
        //点击了删除按钮
        if emotion.removButton {
            
            //删除前面的 text
            deleteBackward();
            return;
        }
        
        //判断是不是emoji 表情
        if emotion.emojiStr != nil {
            
            //  self.textView.replace 替换 text
            //  self.textView.selectedTextRange 选中的 text
            self.replace(self.selectedTextRange!, withText: emotion.emojiStr!);
        }
        
        if emotion.png  != nil {
            //创建附件
            let attachment = NSTextAttachment();
            attachment.image = UIImage(contentsOfFile: emotion.imagePath!);
            attachment.bounds = CGRect(x: 0, y: -4, width: font, height: font);
            //根据附件，创建属性字符串
            let imageText = NSAttributedString(attachment: attachment);

            //拿到当前所有数据 内容
            let strM = NSMutableAttributedString(attributedString: self.attributedText);
            //得到光标地址
            let rang = self.selectedRange;
            strM.replaceCharacters(in: rang, with: imageText);
            //替换数据
            self.attributedText = strM;
            
            //附件自己的字体大小
            strM.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 17), range: NSMakeRange(rang.location - 1, 1) );
            //光标 + 1 ，光标显示数量是0
            self.selectedRange = NSMakeRange(rang.location + 1, 0);
        }

    }
}
