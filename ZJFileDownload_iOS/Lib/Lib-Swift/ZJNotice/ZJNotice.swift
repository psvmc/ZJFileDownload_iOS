//
//  ZJNotice.swift
//  ZJNotice
//
//  Created by psvmc on 15/6/1.
//  Copyright (c) 2015年 psvmc. All rights reserved.
//
//
import Foundation
import UIKit

extension UIViewController {
    
    ///延迟执行方法
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    ///显示成功弹窗，不自动关闭
    func showNoticeSuc(_ text: String) {
        ZJNotice.showNoticeWithText(ZJNoticeType.success, text: text,time: 0, autoClear: false);
    }
    
    ///显示成功弹窗，延时关闭
    func showNoticeSuc(_ text: String,time:TimeInterval) {
        ZJNotice.showNoticeWithText(ZJNoticeType.success, text: text,time: time, autoClear: true);
    }
    
    ///显示成功弹窗，延时关闭，回调事件
    func showNoticeSuc(_ text: String,time:TimeInterval,callbackBlock:@escaping ()->()){
        ZJNotice.showNoticeWithText(ZJNoticeType.success, text: text,time: 0, autoClear: false);
        delay(time, closure: {
            ()->() in
            self.clearAllNotice();
            callbackBlock();
        })
    }
    
    ///显示错误弹窗，不自动关闭
    func showNoticeErr(_ text: String) {
        ZJNotice.showNoticeWithText(ZJNoticeType.error, text: text,time: 0, autoClear: false);
    }
    
    ///显示错误弹窗，延时关闭
    func showNoticeErr(_ text: String,time:TimeInterval) {
        ZJNotice.showNoticeWithText(ZJNoticeType.error, text: text, time:time,autoClear: true);
    }
    
    ///显示错误弹窗，延时关闭，回调事件
    func showNoticeErr(_ text: String,time:TimeInterval,callbackBlock:@escaping ()->()){
        ZJNotice.showNoticeWithText(ZJNoticeType.error, text: text,time: 0, autoClear: false);
        delay(time, closure: {
            ()->() in
            self.clearAllNotice();
            callbackBlock();
        })
    }
    
    ///显示提醒弹窗，不自动关闭
    func showNoticeInfo(_ text: String) {
        ZJNotice.showNoticeWithText(ZJNoticeType.info, text: text, time: 0,autoClear: false)
    }
    
    ///显示提醒弹窗，延时关闭
    func showNoticeInfo(_ text: String,time:TimeInterval) {
        ZJNotice.showNoticeWithText(ZJNoticeType.info, text: text, time: time,autoClear: true)
    }
    
    ///显示提醒弹窗，延时关闭，回调事件
    func showNoticeInfo(_ text: String,time:TimeInterval,callbackBlock:@escaping ()->()){
        ZJNotice.showNoticeWithText(ZJNoticeType.info, text: text, time: 0,autoClear: false)
        delay(time, closure: {
            ()->() in
            self.clearAllNotice();
            callbackBlock();
        })
    }
    
    ///显示等待弹窗，不自动关闭
    func showNoticeWait() {
        ZJNotice.wait(0,autoClear: false)
    }
    
    ///显示等待弹窗，延时关闭
    func showNoticeWait(_ time:TimeInterval){
        ZJNotice.wait(time,autoClear: true)
    }
    
    ///显示等待弹窗，延时关闭，回调事件
    func showNoticeWait(_ time:TimeInterval,callbackBlock:@escaping ()->()){
        ZJNotice.wait(0,autoClear: false);
        delay(time, closure: {
            ()->() in
            self.clearAllNotice();
            callbackBlock();
        })
    }
    
    ///显示等待带文本弹窗，不自动关闭
    func showNoticeWait(text: String){
        ZJNotice.waitWithText(text, time: 0, autoClear: false);
    }
    
    ///显示等待带文本弹窗，延时关闭
    func showNoticeWait(_ text: String,time:TimeInterval){
        ZJNotice.waitWithText(text, time: time, autoClear: true);
    }
    
    ///显示等待带文本弹窗，延时关闭，回调事件
    func showNoticeWait(_ text: String,time:TimeInterval,callbackBlock:@escaping ()->()){
        ZJNotice.waitWithText(text, time: 0, autoClear: false);
        delay(time, closure: {
            ()->() in
            self.clearAllNotice();
            callbackBlock();
        })
    }
    
    ///显示文本弹窗，不自动关闭
    func showNoticeText(_ text: String) {
        ZJNotice.showText(text,time:0,autoClear:false)
    }
    
    ///显示文本弹窗，延时关闭
    func showNoticeText(_ text: String,time:TimeInterval) {
        ZJNotice.showText(text,time:time,autoClear:true);
    }
    
    ///显示文本弹窗，延时关闭，回调事件
    func showNoticeText(_ text: String,time:TimeInterval,callbackBlock:@escaping ()->()){
        ZJNotice.showText(text,time:0,autoClear:false);
        delay(time, closure: {
            ()->() in
            self.clearAllNotice();
            callbackBlock();
        })
    }
    
    ///清除所有弹窗
    func clearAllNotice() {
        ZJNotice.clear()
    }
    
    ///清除等待弹窗
    func clearWaitNotice(){
        ZJNotice.clearWait()
    }
}

enum ZJNoticeType{
    case success
    case error
    case info
}

class ZJNotice: NSObject {
    fileprivate static var imageOfCheckmark: UIImage?
    fileprivate static var imageOfCross: UIImage?
    fileprivate static var imageOfInfo: UIImage?
    fileprivate static let waitTag = 98
    static var notices = Array<UIView>()
    static let rv = UIApplication.shared.keyWindow?.subviews.first!
    static var window:UIWindow = UIApplication.shared.keyWindow!
    
    static func clear() {
        for i in notices {
            i.removeFromSuperview()
        }
    }
    
    static func clearWait(){
        for i in notices {
            if i.tag == waitTag{
                i.removeFromSuperview()
            }
        }
    }
    
    //菊花图
    static func wait(_ time:TimeInterval,autoClear: Bool) {
        clear()
        let frame = CGRect(x: 0, y: 0, width: 78, height: 78)
        let mainView = UIView(frame: frame)
        mainView.layer.cornerRadius = 12
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.8)
        
        let ai = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        ai.frame = CGRect(x: 21, y: 21, width: 36, height: 36)
        ai.startAnimating()
        mainView.addSubview(ai)
        mainView.tag = waitTag;
        addView(mainView, time: time, autoClear: autoClear)
    }
    
    //菊花图带文字
    static func waitWithText(_ text: String,time:TimeInterval,autoClear: Bool) {
        clear();
        
        let font = UIFont.systemFont(ofSize: 13);
        let attrs = [NSFontAttributeName:font,NSForegroundColorAttributeName:UIColor.white];
        let fontSize = (text as NSString).size(attributes: attrs);
        let fontWidth = fontSize.width;
        
        let frame = CGRect(x: 0, y: 0, width: fontWidth+40, height: 100)
        let mainView = UIView(frame: frame)
        mainView.layer.cornerRadius = 12
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.8)
        
        let ai = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        ai.frame = CGRect(x: 21, y: 21, width: 36, height: 36)
        ai.startAnimating()
        mainView.addSubview(ai)
        ai.center.x = mainView.center.x;
        
        //添加文字
        let label = UILabel(frame: CGRect(x: 0, y: 65, width: fontWidth+10, height: 16))
        label.font = font;
        label.textColor = UIColor.white;
        label.text = text;
        label.textAlignment = NSTextAlignment.center;
        mainView.addSubview(label);
        label.center.x = mainView.center.x;
        mainView.tag = waitTag;
        addView(mainView, time: time, autoClear: autoClear)
    }
    
    //仅文字
    static func showText(_ text: String,time:TimeInterval,autoClear: Bool) {
        clear()
        let font = UIFont.systemFont(ofSize: 13);
        let attrs = [NSFontAttributeName:font,NSForegroundColorAttributeName:UIColor.white];
        let fontSize = (text as NSString).size(attributes: attrs);
        let fontWidth = fontSize.width;
        let fontHeight = fontSize.height;
        
        
        let fontLinesHeight:CGFloat = CGFloat(floor(fontHeight * ceil((fontWidth / 100))));
        
        let mainView = UIView()
        mainView.layer.cornerRadius = 12
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.8)
        
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = font;
        label.textAlignment = NSTextAlignment.center;
        label.textColor = UIColor.white;
        label.frame = CGRect(x: 0, y: 0, width: 150, height: fontLinesHeight+10);
        
        mainView.addSubview(label)
        mainView.frame = CGRect(x: 0, y: 0, width: label.frame.width + 50 , height: fontLinesHeight + 20);
        
        label.center = mainView.center;
        addView(mainView, time: time, autoClear: autoClear)
    }
    
    //有勾、叉和警告
    static func showNoticeWithText(_ type: ZJNoticeType,text: String,time:TimeInterval,autoClear: Bool) {
        clear()
        
        let font = UIFont.systemFont(ofSize: 13);
        let attrs = [NSFontAttributeName:font,NSForegroundColorAttributeName:UIColor.white];
        
        let fontSize = (text as NSString).size(attributes: attrs);
        
        let fontWidth = fontSize.width;
        
        let frame = CGRect(x: 0, y: 0, width: fontWidth+40, height: 90)
        let mainView = UIView(frame: frame)
        mainView.layer.cornerRadius = 10
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.7)
        
        var image = UIImage()
        switch type {
        case .success:
            image = drawCacheImg(imageOfCheckmark,type: ZJNoticeType.success)
        case .error:
            image = drawCacheImg(imageOfCross,type: ZJNoticeType.error)
        case .info:
            image = drawCacheImg(imageOfInfo,type: ZJNoticeType.info)
        }
        let checkmarkView = UIImageView(image: image)
        checkmarkView.frame = CGRect(x: 27, y: 15, width: 36, height: 36)
        mainView.addSubview(checkmarkView);
        checkmarkView.center.x = mainView.center.x;
        
        let label = UILabel(frame: CGRect(x: 0, y: 60, width: fontWidth, height: 16))
        label.font = font;
        label.textColor = UIColor.white;
        label.text = text;
        label.textAlignment = NSTextAlignment.center;
        mainView.addSubview(label);
        label.center.x = mainView.center.x;
        addView(mainView, time: time, autoClear: autoClear);
    }
    
    static func addView(_ mainView:UIView,time:TimeInterval,autoClear:Bool){
        mainView.center = rv!.center
        window.addSubview(mainView)
        notices.append(mainView)
        
        if autoClear {
            Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(ZJNotice.hideNotice(_:)), userInfo: mainView, repeats: false)
        }
    }
    
    static func hideNotice(_ sender: Timer) {
        if sender.userInfo is UIView {
            (sender.userInfo! as AnyObject).removeFromSuperview()
        }
    }
    
    //下面是画图的
    class func draw(_ type: ZJNoticeType) {
        let checkmarkShapePath = UIBezierPath()
        // 先画个圈圈
        checkmarkShapePath.move(to: CGPoint(x: 36, y: 18))
        checkmarkShapePath.addArc(withCenter: CGPoint(x: 18, y: 18), radius: 17.5, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: true)
        checkmarkShapePath.close()
        
        switch type {
        case .success: // 画勾
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 18))
            checkmarkShapePath.addLine(to: CGPoint(x: 16, y: 24))
            checkmarkShapePath.addLine(to: CGPoint(x: 27, y: 13))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 18))
            checkmarkShapePath.close()
        case .error: // 画叉
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 10))
            checkmarkShapePath.addLine(to: CGPoint(x: 26, y: 26))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 26))
            checkmarkShapePath.addLine(to: CGPoint(x: 26, y: 10))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 10))
            checkmarkShapePath.close()
        case .info:  //画警告
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 6))
            checkmarkShapePath.addLine(to: CGPoint(x: 18, y: 22))
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 6))
            checkmarkShapePath.close()
            
            UIColor.white.setStroke()
            checkmarkShapePath.stroke()
            
            let checkmarkShapePath = UIBezierPath()
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 27))
            checkmarkShapePath.addArc(withCenter: CGPoint(x: 18, y: 27), radius: 1, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: true)
            checkmarkShapePath.close()
            
            UIColor.white.setFill()
            checkmarkShapePath.fill()
        }
        
        UIColor.white.setStroke()
        checkmarkShapePath.stroke()
    }
    
    
    class func drawCacheImg(_ cacheImg: UIImage?,type:ZJNoticeType)->UIImage{
        if (cacheImg != nil) {
            return cacheImg!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        draw(type);
        
        switch type{
        case .success:
            imageOfCheckmark = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return imageOfCheckmark!
            
        case .error:
            imageOfCross = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return imageOfCross!
            
        case .info:
            imageOfInfo = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return imageOfInfo!
            
            
        }
    }
    
}

