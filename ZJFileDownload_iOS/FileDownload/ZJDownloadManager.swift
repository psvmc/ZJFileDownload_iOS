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
    fileprivate static let documentsPath: AnyObject = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as AnyObject
    //下载
    
    static var lastTime = Date().timeIntervalSince1970 * 1000;
    
    
    static func getFileSize(_ byte:CGFloat)->String{
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
    
    static func  download(_ fileInfo:ZJFileInfo){
        if(fileIsExist(fileInfo)){
            fileInfo.status = ZJFileInfo.STATUS_COMPLETE;
            fileInfo.progress = 1;
            fileInfo.downloadPerSize = fileInfo.perSize;
            self.delegate?.viewRefresh();
        }else if(!operationIsExist(fileInfo)){
            fileInfo.status = ZJFileInfo.STATUS_CONNECTING;
            self.delegate?.viewRefresh();

            let operation = LCDownloadManager.downloadFile(withURLString: fileInfo.url, cachePath: fileInfo.name, progress: {
                (progress:CGFloat!, totalByteRead:CGFloat!, totalByteExpectedToRead:CGFloat!) -> Void in
                let progressFloat:Float = (String(format: "%.2f", Float(progress)) as NSString).floatValue;
                if(fileInfo.progress != progressFloat){
                    
                    fileInfo.progress = progressFloat;
                    fileInfo.perSize = getFileSize(totalByteExpectedToRead);
                    fileInfo.downloadPerSize = getFileSize(totalByteRead);
                    
                    if(progressFloat<1 && progressFloat>0){
                        fileInfo.status = ZJFileInfo.STATUS_DOWNLOADING;
                    }else if(progressFloat == 1){
                        fileInfo.downloadPerSize = fileInfo.perSize;
                        fileInfo.status = ZJFileInfo.STATUS_COMPLETE;
                    }
                    
                    if(progressFloat == 1){
                        self.delegate?.viewRefresh();
                    }else if(progressFloat > 0){
                        let nowTime = Date().timeIntervalSince1970 * 1000;
                        if(nowTime - lastTime > 1000){
                            lastTime = nowTime;
                            self.delegate?.viewRefresh();
                        }
                    }

                    
                }
                }, success: {
                    (operation:AFHTTPRequestOperation?, responseObject: Any?) -> Void in
                    
                }, failure: {
                    (operation:AFHTTPRequestOperation?,error:Error?) -> Void in
                    
                    fileInfo.status = ZJFileInfo.STATUS_DOWNLOAD_ERROR;
                    self.delegate?.viewRefresh();
            })
            downloadSequence[fileInfo.url] = operation;
        }
        
    }
    
    
    //暂停
    static func pause(_ fileInfo:ZJFileInfo){
        let operation = downloadSequence[fileInfo.url];
        if(operation != nil){
            LCDownloadManager.pause(with: operation);
            self.delegate?.viewRefresh();
        }
    }
    
    //继续
    static func start(_ fileInfo:ZJFileInfo){
        let operation = downloadSequence[fileInfo.url];
        if(operation != nil){
            operation?.start();
            self.delegate?.viewRefresh();
        }
    }
    
    ///文件是否已存在
    static func fileIsExist(_ fileInfo:ZJFileInfo)->Bool{
        let fileManager = FileManager.default;
        let isExist = fileManager.fileExists(atPath: documentsPath.appending("/Download/\(fileInfo.name)"));
        return isExist;
    }
    
    ///下载序列中是否有该序列
    static func operationIsExist(_ fileInfo:ZJFileInfo)->Bool{
        for (url,_) in downloadSequence{
            if(url == fileInfo.url){
                return true;
            }
        }
        return false;
    }
}
