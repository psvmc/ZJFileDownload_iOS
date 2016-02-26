//
//  ZJDownloadManager.swift
//  ecms_ios
//
//  Created by 张剑 on 15/12/30.
//
//

import Foundation

class ZJDownloadManager{
    static var delegate:ZJFileDownloadDelegate?;
    static var downloadSequence:[String:AFHTTPRequestOperation] = [:];
    private static let documentsPath: AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
    //下载
    
    
    static func getFileSize(byte:CGFloat)->String{
        let oneKB = CGFloat(1024.0);
        let oneMB = CGFloat(1024.0*1024);
        let oneGB = CGFloat(1024.0*1024*1024);
        if(byte >= oneGB){
            return String(format: "%.2f", byte/oneGB)+"G";
        }else if(byte >= oneMB){
            return String(format: "%.2f", byte/oneMB)+"M";
        }else if(byte >= oneKB){
            return String(format: "%.2f", byte/oneKB)+"K";
        }else{
            return String(format: "%.2f", byte)+"B";
        }
    }
    
    static func  download(fileInfo:ZJFileInfo){
        if(fileIsExist(fileInfo)){
            fileInfo.status = ZJFileInfo.STATUS_COMPLETE;
            fileInfo.progress = 1;
            fileInfo.downloadPerSize = fileInfo.perSize;
            self.delegate?.viewRefresh();
        }else if(!operationIsExist(fileInfo)){
            fileInfo.status = ZJFileInfo.STATUS_CONNECTING;
            self.delegate?.viewRefresh();
    
            let operation = LCDownloadManager.downloadFileWithURLString(fileInfo.url, cachePath: fileInfo.name, progress: {
                (progress:CGFloat!, totalByteRead:CGFloat!, totalByteExpectedToRead:CGFloat!) -> Void in
                
                fileInfo.progress = Float(progress);
                fileInfo.perSize = getFileSize(totalByteExpectedToRead);
                fileInfo.downloadPerSize = getFileSize(totalByteRead);
                if(progress<1 && progress>0){
                    fileInfo.status = ZJFileInfo.STATUS_DOWNLOADING;
                }else if(progress == 1){
                    fileInfo.status = ZJFileInfo.STATUS_COMPLETE;
                }
                self.delegate?.viewRefresh();
                }, success: {
                    (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
                    
                }, failure: {
                    (operation:AFHTTPRequestOperation?,error:NSError?) -> Void in
            
                    fileInfo.status = ZJFileInfo.STATUS_DOWNLOAD_ERROR;
                    self.delegate?.viewRefresh();
            })
            downloadSequence[fileInfo.url] = operation;
        }
        
    }
    
    
    //暂停
    static func pause(fileInfo:ZJFileInfo){
        let operation = downloadSequence[fileInfo.url];
        if(operation != nil){
            LCDownloadManager.pauseWithOperation(operation);
            self.delegate?.viewRefresh();
        }
    }
    
    //继续
    static func start(fileInfo:ZJFileInfo){
        let operation = downloadSequence[fileInfo.url];
        if(operation != nil){
            operation?.start();
            self.delegate?.viewRefresh();
        }
    }
    
    ///文件是否已存在
    static func fileIsExist(fileInfo:ZJFileInfo)->Bool{
        let fileManager = NSFileManager.defaultManager();
        let isExist = fileManager.fileExistsAtPath(documentsPath.stringByAppendingString("/Download/\(fileInfo.name)"));
        return isExist;
    }
    
    ///下载序列中是否有该序列
    static func operationIsExist(fileInfo:ZJFileInfo)->Bool{
        for (url,_) in downloadSequence{
            if(url == fileInfo.url){
                return true;
            }
        }
        return false;
    }
}
