//
//  ZJ_Func.swift
//  ecms_ios
//
//  Created by PSVMC on 15/6/30.
//
//

import Foundation
class ZJ_Func{
    
    ///延迟执行方法
    static func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    ///异步调用方法
    static func async(block:()->(),callBack:()->()){
        dispatch_async(dispatch_queue_create(NSDate().description, nil), {
            block();
            dispatch_async(dispatch_get_main_queue(), callBack);
        });
    }
    
    ///取消选中的tablecell
    static func unselectCell(tableView: UITableView)->Void{
        if(tableView.indexPathForSelectedRow != nil){
            tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: true);
        }
    }
    
    ///打电话
    static func phone(phone:String,viewController:UIViewController)->Void{
        let str = "tel:\(phone)";
        let callWebView = UIWebView();
        viewController.view.addSubview(callWebView);
        callWebView.loadRequest(NSURLRequest(URL: NSURL(string: str)!));
        
    }
    
    ///发短信
    static func msg(phone:String)->Void{
        let str = "sms:\(phone)";
        UIApplication.sharedApplication().openURL(NSURL(string: str)!);
        
    }
    ///获取随机正整数
    static func randomNum(num:Int)->Int{
        let randomNum = Int(arc4random_uniform(UInt32(num)));
        return randomNum;
    }
    
    ///距离scrollView底部的距离
    static func scrollViewSpaceToButtom(scrollView: UIScrollView)->CGFloat{
        let offset = scrollView.contentOffset;
        let bounds = scrollView.bounds;
        let size = scrollView.contentSize;
        let inset = scrollView.contentInset;
        let currentOffset = offset.y + bounds.size.height - inset.bottom;
        let maximumOffset = size.height;
        
        //当currentOffset与maximumOffset的值相等时，说明scrollview已经滑到底部了。也可以根据这两个值的差来让他做点其他的什么事情
        let space = maximumOffset-currentOffset;
        return space;
    }
    
    ///判断系统是否大于某版本号
    static func isVersion(version:String)-> Bool{
        switch UIDevice.currentDevice().systemVersion.compare(version, options: NSStringCompareOptions.NumericSearch) {
        case .OrderedSame, .OrderedDescending:
            return true;
        case .OrderedAscending:
            return false;
        }
    }
    
    ///Cell抖动动画
    static func animateCell(cell: UITableViewCell) {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values =  [0, 20, -20, 10, 0]
        animation.keyTimes = [0, (1 / 6.0), (3 / 6.0), (5 / 6.0), 1]
        animation.duration = 0.35
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.additive = true
        cell.layer.addAnimation(animation, forKey: "shake")
    }
    
    ///是否处于搜索状态
    static func isSearch(tableView: UITableView,mySearchDisplayController:UISearchDisplayController?)-> Bool{
        if tableView == mySearchDisplayController!.searchResultsTableView{
            return true;
        }else{
            return false;
        }
    }
}
