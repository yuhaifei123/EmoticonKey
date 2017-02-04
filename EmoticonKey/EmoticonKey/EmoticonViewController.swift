//
//  EmoticonViewController.swift
//  EmoticonKey
//
//  Created by 虞海飞 on 2017/1/24.
//  Copyright © 2017年 虞海飞. All rights reserved.
//

import UIKit


// cell 的id (必须是类外面)
private let XMGEmoticonCellReuseIdentifier = "XMGEmoticonCellReuseIdentifier"

class EmoticonViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// 添加 ui
    private func setupUI(){
        
        self.view.addSubview(collectionVeiw);
        self.view.addSubview(toolbar);
        
        toolbar.snp.makeConstraints { (make) in
            
            make.bottom.right.left.equalTo(0);
            make.height.equalTo(44);
        }
        
        collectionVeiw.snp.makeConstraints { (make) in
            
            make.top.equalTo(0);
            make.left.right.equalTo(0);
            make.bottom.equalTo(toolbar.snp.top);
        }
    }
    
    
    /// 点击按钮，触发事件
    ///
    /// - Parameter item: <#item description#>
    public func clickItem(item : UIBarButtonItem){

        print("不要乱点");
    }
    
    private lazy var collectionVeiw : UICollectionView = {
    
        let collview = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmoticonLayout());
         collectionVeiw.backgroundColor = UIColor.white;
        // 注册cell
        collview.register(EmoticonCell.self, forCellWithReuseIdentifier: XMGEmoticonCellReuseIdentifier);
        collview.dataSource = self
        return collview;
    }();
    
    private lazy var toolbar: UIToolbar = {
    
        let toolbar = UIToolbar();
        toolbar.tintColor = UIColor.darkGray;
        var items = [UIBarButtonItem]();
        for title in ["最近", "默认", "emoji", "浪小花"]{
            
            let item = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.plain, target: self, action: #selector(clickItem(item:)));
            item.tag += 1;
            items.append(item);
            //加弹簧（不然没有间距）
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil))
        }
        
        items.removeLast()
        toolbar.items = items
        return toolbar;
    }();
    
    public lazy var packages : [EmoticonPackage] = EmoticonPackage.loadPackages();
}

extension EmoticonViewController : UICollectionViewDataSource{
   
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:XMGEmoticonCellReuseIdentifier , for: indexPath) as! EmoticonCell;
        cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor.red : UIColor.green;

        // 1.取出对应的组
        let package = packages[indexPath.section]
        // 2.取出对应组对应行的模型
        let emoticon = package.emoticons![indexPath.item]
        // 3.赋值给cell
        cell.emoticon = emoticon;
        
        return cell;
    }

    // 告诉系统每组有多少行
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
    
        return packages[section].emoticons?.count ?? 0;
    }
    
    //有多少组
    public func numberOfSections(in collectionView: UICollectionView) -> Int{
    
        return packages.count;
    }

}

class EmoticonCell : UICollectionViewCell {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        setupUI();
    }
    
    var emoticon: Emoticon?{
        
        didSet{
            // 1.判断是否是图片表情
            if emoticon!.chs != nil{
                
                iconButton.setImage(UIImage(contentsOfFile: emoticon!.imagePath!), for: UIControlState.normal)
            }
            else{
                // 防止重用
                iconButton.setImage(nil, for: UIControlState.normal)
            }
            
            // 2.设置emoji表情
            // 注意: 加上??可以防止重用
            iconButton.setTitle(emoticon!.emojiStr ?? "", for: UIControlState.normal)
            
            if emoticon!.removButton {
                
                iconButton.setImage(UIImage(named: "compose_emotion_delete"), for: UIControlState.normal);
                iconButton.setImage(UIImage(named: "compose_emotion_delete_highlighted"), for: UIControlState.highlighted);
            }
        }
    }

    
    func setupUI(){
        
        self.contentView.addSubview(iconButton);
        
        iconButton.snp.makeConstraints { (make) in
            
            make.top.left.equalTo(2);
            make.right.bottom.equalTo(-2);
        }
    }
    
    private lazy var iconButton : UIButton = {
    
        let button = UIButton();
        //button 的字体
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32);
        return button;
    }();
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// 自定义布局
class EmoticonLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare();
        
        //得到宽度
        let width = collectionView!.bounds.width/7;
        //items 大小
        itemSize = CGSize(width: width, height: width);
        
        //间距
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        //滑动方向
        scrollDirection = UICollectionViewScrollDirection.horizontal;
        
        // 2.设置collectionview相关属性
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        
        // 注意:最好不要乘以0.5, 因为CGFloat不准确, 所以如果乘以0.5在iPhone4/4身上会有问题
        let y = (collectionView!.bounds.height - 3 * width) * 0.45
        collectionView?.contentInset = UIEdgeInsets(top: y, left: 0, bottom: y, right: 0)
    }
}
