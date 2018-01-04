//
//  ZJFileInfo.swift
//  ecms_ios
//
//  Created by 张剑 on 15/12/30.
//
//

import Foundation

class ZJFileInfo: NSObject{
    internal static var STATUS_NOT_DOWNLOAD = 0;
    internal static var STATUS_CONNECTING = 1;
    internal static var STATUS_CONNECT_ERROR = 2;
    internal static var STATUS_DOWNLOADING = 3;
    internal static var STATUS_PAUSED = 4;
    internal static var STATUS_DOWNLOAD_ERROR = 5;
    internal static var STATUS_COMPLETE = 6;

    
    var name:String = "";//文件名称
    var id:Int = 0;//列表中的id
    var url:String = "";//文件的URL
    var fileType:String = "";//文件的类型
    var progress:Float = 0;//文件下载进度
    var perSize:String = "0M";//文件的大小
    var downloadPerSize:String = "0";//已下载的大小
    var status:Int = 0;//下载状态
    
    override init(){}
    
    init(name: String,
        url: String,
        perSize: String,
        fileType: String
        ){
            self.name = name
            self.url = url
            self.perSize = perSize
            self.fileType = fileType
    }
    
    func getStatusText() -> String{
        switch (status) {
        case ZJFileInfo.STATUS_NOT_DOWNLOAD:
            return "未下载";
        case ZJFileInfo.STATUS_CONNECTING:
            return "连接中";
        case ZJFileInfo.STATUS_CONNECT_ERROR:
            return "连接失败";
        case ZJFileInfo.STATUS_DOWNLOADING:
            return "下载中";
        case ZJFileInfo.STATUS_PAUSED:
            return "暂停";
        case ZJFileInfo.STATUS_DOWNLOAD_ERROR:
            return "下载出错";
        case ZJFileInfo.STATUS_COMPLETE:
            return "已完成";
        default:
            return "未下载";
        }
    }
    
    func getButtonText() ->String{
        switch status {
        case ZJFileInfo.STATUS_NOT_DOWNLOAD:
            return "下载";
        case ZJFileInfo.STATUS_CONNECTING:
            return "取消";
        case ZJFileInfo.STATUS_CONNECT_ERROR:
            return "重试";
        case ZJFileInfo.STATUS_DOWNLOADING:
            return "暂停";
        case ZJFileInfo.STATUS_PAUSED:
            return "继续";
        case ZJFileInfo.STATUS_DOWNLOAD_ERROR:
            return "重试";
        case ZJFileInfo.STATUS_COMPLETE:
            return "打开";
        default:
            return "下载";
        }
    }
}
