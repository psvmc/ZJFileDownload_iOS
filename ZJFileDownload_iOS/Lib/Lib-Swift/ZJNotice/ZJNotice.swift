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
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    ///显示成功弹窗，不自动关闭
    func showNoticeSuc(text: String) {
        ZJNotice.showNoticeWithText(ZJNoticeType.success, text: text,time: 0, autoClear: false);
    }
    
    ///显示成功弹窗，延时关闭
    func showNoticeSuc(text: String,time:NSTimeInterval) {
        ZJNotice.showNoticeWithText(ZJNoticeType.success, text: text,time: time, autoClear: true);
    }
    
    ///显示成功弹窗，延时关闭，回调事件
    func showNoticeSuc(text: String,time:NSTimeInterval,callbackBlock:()->()){
        ZJNotice.showNoticeWithText(ZJNoticeType.success, text: text,time: 0, autoClear: false);
        delay(time, closure: {
            ()->() in
            self.clearAllNotice();
            callbackBlock();
        })
    }
    
    ///显示错误弹窗，不自动关闭
    func showNoticeErr(text: String) {
        ZJNotice.showNoticeWithText(ZJNoticeType.error, text: text,time: 0, autoClear: false);
    }
    
    ///显示错误弹窗，延时关闭
    func showNoticeErr(text: String,time:NSTimeInterval) {
        ZJNotice.showNoticeWithText(ZJNoticeType.error, text: text, time:time,autoClear: true);
    }
    
    ///显示错误弹窗，延时关闭，回调事件
    func showNoticeErr(text: String,time:NSTimeInterval,callbackBlock:()->()){
        ZJNotice.showNoticeWithText(ZJNoticeType.error, text: text,time: 0, autoClear: false);
        delay(time, closure: {
            ()->() in
            self.clearAllNotice();
            callbackBlock();
        })
    }
    
    ///显示提醒弹窗，不自动关闭
    func showNoticeInfo(text: String) {
        ZJNotice.showNoticeWithText(ZJNoticeType.info, text: text, time: 0,autoClear: false)
    }
    
    ///显示提醒弹窗，延时关闭
    func showNoticeInfo(text: String,time:NSTimeInterval) {
        ZJNotice.showNoticeWithText(ZJNoticeType.info, text: text, time: time,autoClear: true)
    }
    
    ///显示提醒弹窗，延时关闭，回调事件
    func showNoticeInfo(text: String,time:NSTimeInterval,callbackBlock:()->()){
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
    func showNoticeWait(time:NSTimeInterval){
        ZJNotice.wait(time,autoClear: true)
    }
    
    ///显示等待弹窗，延时关闭，回调事件
    func showNoticeWait(time:NSTimeInterval,callbackBlock:()->()){
        ZJNotice.wait(0,autoClear: false);
        delay(time, closure: {
            ()->() in
            self.clearAllNotice();
            callbackBlock();
        })
    }
    
    ///显示等待带文本弹窗，不自动关闭
    func showNoticeWait(text text: String){
        ZJNotice.waitWithText(text, time: 0, autoClear: false);
    }
    
    ///显示等待带文本弹窗，延时关闭
    func showNoticeWait(text: String,time:NSTimeInterval){
        ZJNotice.waitWithText(text, time: time, autoClear: true);
    }
    
    ///显示等待带文本弹窗，延时关闭，回调事件
    func showNoticeWait(text: String,time:NSTimeInterval,callbackBlock:()->()){
         ZJNotice.waitWithText(text, time: 0, autoClear: false);
        delay(time, closure: {
            ()->() in
            self.clearAllNotice();
            callbackBlock();
        })
    }
    
    ///显示文本弹窗，不自动关闭
    func showNoticeText(text: String) {
        ZJNotice.showText(text,time:0,autoClear:false)
    }
    
    ///显示文本弹窗，延时关闭
    func showNoticeText(text: String,time:NSTimeInterval) {
        ZJNotice.showText(text,time:time,autoClear:true);
    }
    
    ///显示文本弹窗，延时关闭，回调事件
    func showNoticeText(text: String,time:NSTimeInterval,callbackBlock:()->()){
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
    private static var imageOfCheckmark: UIImage?
    private static var imageOfCross: UIImage?
    private static var imageOfInfo: UIImage?
    private static let waitTag = 98
    static var notices = Array<UIView>()
    static let rv = UIApplication.sharedApplication().keyWindow?.subviews.first!
    static var window:UIWindow = UIApplication.sharedApplication().keyWindow!
    
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
    static func wait(time:NSTimeInterval,autoClear: Bool) {
        clear()
        let frame = CGRectMake(0, 0, 78, 78)
        let mainView = UIView(frame: frame)
        mainView.layer.cornerRadius = 12
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.8)
        
        let ai = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        ai.frame = CGRectMake(21, 21, 36, 36)
        ai.startAnimating()
        mainView.addSubview(ai)
        mainView.tag = waitTag;
        addView(mainView, time: time, autoClear: autoClear)
    }
    
    //菊花图带文字
    static func waitWithText(text: String,time:NSTimeInterval,autoClear: Bool) {
        clear();
        
        let font = UIFont.systemFontOfSize(13);
        let attrs = [NSFontAttributeName:font,NSForegroundColorAttributeName:UIColor.whiteColor()];
        let fontSize = (text as NSString).sizeWithAttributes(attrs);
        let fontWidth = fontSize.width;

        let frame = CGRectMake(0, 0, fontWidth+40, 100)
        let mainView = UIView(frame: frame)
        mainView.layer.cornerRadius = 12
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.8)
        
        let ai = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        ai.frame = CGRectMake(21, 21, 36, 36)
        ai.startAnimating()
        mainView.addSubview(ai)
        ai.center.x = mainView.center.x;
        
        //添加文字
        let label = UILabel(frame: CGRectMake(0, 65, fontWidth+10, 16))
        label.font = font;
        label.textColor = UIColor.whiteColor();
        label.text = text;
        label.textAlignment = NSTextAlignment.Center;
        mainView.addSubview(label);
        label.center.x = mainView.center.x;
        mainView.tag = waitTag;
        addView(mainView, time: time, autoClear: autoClear)
    }
    
    //仅文字
    static func showText(text: String,time:NSTimeInterval,autoClear: Bool) {
        clear()
        let font = UIFont.systemFontOfSize(13);
        let attrs = [NSFontAttributeName:font,NSForegroundColorAttributeName:UIColor.whiteColor()];
        let fontSize = (text as NSString).sizeWithAttributes(attrs);
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
        label.textAlignment = NSTextAlignment.Center;
        label.textColor = UIColor.whiteColor();
        label.frame = CGRectMake(0, 0, 150, fontLinesHeight+10);
        
        mainView.addSubview(label)
        mainView.frame = CGRectMake(0, 0, label.frame.width + 50 , fontLinesHeight + 20);
        
        label.center = mainView.center;
        addView(mainView, time: time, autoClear: autoClear)
    }
    
    //有勾、叉和警告
    static func showNoticeWithText(type: ZJNoticeType,text: String,time:NSTimeInterval,autoClear: Bool) {
        clear()
        
        let font = UIFont.systemFontOfSize(13);
        let attrs = [NSFontAttributeName:font,NSForegroundColorAttributeName:UIColor.whiteColor()];
        
        let fontSize = (text as NSString).sizeWithAttributes(attrs);
        
        let fontWidth = fontSize.width;
        
        let frame = CGRectMake(0, 0, fontWidth+40, 90)
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
        checkmarkView.frame = CGRectMake(27, 15, 36, 36)
        mainView.addSubview(checkmarkView);
        checkmarkView.center.x = mainView.center.x;
        
        let label = UILabel(frame: CGRectMake(0, 60, fontWidth, 16))
        label.font = font;
        label.textColor = UIColor.whiteColor();
        label.text = text;
        label.textAlignment = NSTextAlignment.Center;
        mainView.addSubview(label);
        label.center.x = mainView.center.x;
        addView(mainView, time: time, autoClear: autoClear);
    }
    
    static func addView(mainView:UIView,time:NSTimeInterval,autoClear:Bool){
        mainView.center = rv!.center
        window.addSubview(mainView)
        notices.append(mainView)
        
        if autoClear {
            NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: "hideNotice:", userInfo: mainView, repeats: false)
        }
    }
    
    static func hideNotice(sender: NSTimer) {
        if sender.userInfo is UIView {
            sender.userInfo!.removeFromSuperview()
        }
    }
    
    //下面是画图的
    class func draw(type: ZJNoticeType) {
        let checkmarkShapePath = UIBezierPath()
        // 先画个圈圈
        checkmarkShapePath.moveToPoint(CGPointMake(36, 18))
        checkmarkShapePath.addArcWithCenter(CGPointMake(18, 18), radius: 17.5, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: true)
        checkmarkShapePath.closePath()
        
        switch type {
        case .success: // 画勾
            checkmarkShapePath.moveToPoint(CGPointMake(10, 18))
            checkmarkShapePath.addLineToPoint(CGPointMake(16, 24))
            checkmarkShapePath.addLineToPoint(CGPointMake(27, 13))
            checkmarkShapePath.moveToPoint(CGPointMake(10, 18))
            checkmarkShapePath.closePath()
        case .error: // 画叉
            checkmarkShapePath.moveToPoint(CGPointMake(10, 10))
            checkmarkShapePath.addLineToPoint(CGPointMake(26, 26))
            checkmarkShapePath.moveToPoint(CGPointMake(10, 26))
            checkmarkShapePath.addLineToPoint(CGPointMake(26, 10))
            checkmarkShapePath.moveToPoint(CGPointMake(10, 10))
            checkmarkShapePath.closePath()
        case .info:  //画警告
            checkmarkShapePath.moveToPoint(CGPointMake(18, 6))
            checkmarkShapePath.addLineToPoint(CGPointMake(18, 22))
            checkmarkShapePath.moveToPoint(CGPointMake(18, 6))
            checkmarkShapePath.closePath()
            
            UIColor.whiteColor().setStroke()
            checkmarkShapePath.stroke()
            
            let checkmarkShapePath = UIBezierPath()
            checkmarkShapePath.moveToPoint(CGPointMake(18, 27))
            checkmarkShapePath.addArcWithCenter(CGPointMake(18, 27), radius: 1, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: true)
            checkmarkShapePath.closePath()
            
            UIColor.whiteColor().setFill()
            checkmarkShapePath.fill()
        }
        
        UIColor.whiteColor().setStroke()
        checkmarkShapePath.stroke()
    }
    
    
    class func drawCacheImg(cacheImg: UIImage?,type:ZJNoticeType)->UIImage{
        if (cacheImg != nil) {
            return cacheImg!
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), false, 0)
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

