//
//  ZJFileDataSource.swift
//  ecms_ios
//
//  Created by 张剑 on 15/12/30.
//
//

import Foundation

class ZJFileDataSource:NSObject{
    private static var id = 0;
    static var myDataSource:[ZJFileInfo] = [ZJFileInfo]();
    
    ///添加文件
    static func addFileInfo(fileInfo:ZJFileInfo){
        if(!fileIsExist(fileInfo)){
            id += 1;
            fileInfo.id = id;
            myDataSource.append(fileInfo);
        }
    }
    
    ///根据id移除文件
    static func removeFileById(id:Int){
        for (index,fileInfo) in ZJFileDataSource.myDataSource.enumerate(){
            if(fileInfo.id == id){
                myDataSource.removeAtIndex(index);
            }
        }
    }
    
    ///根据id获取文件
    static func getFileById(id:Int)->ZJFileInfo?{
        for (index,fileInfo) in ZJFileDataSource.myDataSource.enumerate(){
            if(fileInfo.id == id){
                return myDataSource[index];
            }
        }
        return nil;
    }
    
    ///文件是否已添加
    static func fileIsExist(file:ZJFileInfo)->Bool{
        for fileInfo in ZJFileDataSource.myDataSource{
            if(file.url == fileInfo.url){
                return true;
            }
        }
        return false;
    }
    
}
