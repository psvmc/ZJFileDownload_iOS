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
    static func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    ///异步调用方法
    static func async(_ block:@escaping ()->(),callBack:@escaping ()->()){
        DispatchQueue(label: Date().description, attributes: []).async(execute: {
            block();
            DispatchQueue.main.async(execute: callBack);
        });
    }
    
    ///取消选中的tablecell
    static func unselectCell(_ tableView: UITableView)->Void{
        if(tableView.indexPathForSelectedRow != nil){
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true);
        }
    }
    
    ///打电话
    static func phone(_ phone:String,viewController:UIViewController)->Void{
        let str = "tel:\(phone)";
        let callWebView = UIWebView();
        viewController.view.addSubview(callWebView);
        callWebView.loadRequest(URLRequest(url: URL(string: str)!));
        
    }
    
    ///发短信
    static func msg(_ phone:String)->Void{
        let str = "sms:\(phone)";
        UIApplication.shared.openURL(URL(string: str)!);
        
    }
    ///获取随机正整数
    static func randomNum(_ num:Int)->Int{
        let randomNum = Int(arc4random_uniform(UInt32(num)));
        return randomNum;
    }
    
    ///距离scrollView底部的距离
    static func scrollViewSpaceToButtom(_ scrollView: UIScrollView)->CGFloat{
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
    static func isVersion(_ version:String)-> Bool{
        switch UIDevice.current.systemVersion.compare(version, options: NSString.CompareOptions.numeric) {
        case .orderedSame, .orderedDescending:
            return true;
        case .orderedAscending:
            return false;
        }
    }
    
    ///Cell抖动动画
    static func animateCell(_ cell: UITableViewCell) {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values =  [0, 20, -20, 10, 0]
        animation.keyTimes = [0, NSNumber(value:1.0 / 6.0), NSNumber(value:3.0 / 6.0), NSNumber(value:5.0 / 6.0), 1]
        animation.duration = 0.35
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.isAdditive = true
        cell.layer.add(animation, forKey: "shake")
    }
    
    ///是否处于搜索状态
    static func isSearch(_ tableView: UITableView,mySearchDisplayController:UISearchDisplayController?)-> Bool{
        if tableView == mySearchDisplayController!.searchResultsTableView{
            return true;
        }else{
            return false;
        }
    }
}
