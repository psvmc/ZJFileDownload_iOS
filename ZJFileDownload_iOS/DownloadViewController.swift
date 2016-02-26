//
//  DownloadViewController.swift
//  ecms_ios
//
//  Created by 张剑 on 15/12/30.
//
//

import UIKit

class DownloadViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ZJFileDownloadDelegate,UIDocumentInteractionControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var logger = XCGLogger.defaultInstance();
    var documentInteractionController:UIDocumentInteractionController!;
    
    let fileManager = NSFileManager.defaultManager();
    let documentsPath: AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
    private static let documentsPath: AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //添加假数据
        ZJFileDataSource.addFileInfo(ZJFileInfo(name: "壁纸.jpg", url: "http://bbs.feng.com/data/attachment/forum/201412/02/164442jakbgm3zalof1fig.jpg", perSize: "101.4k", fileType: "jpg"));
        ZJFileDataSource.addFileInfo(ZJFileInfo(name: "360手机卫士.apk", url: "http://msoftdl.360.cn/mobilesafe/shouji360/360safesis/360MobileSafe_6.2.3.1060.apk", perSize: "8.48M", fileType: "apk"));
        ZJFileDataSource.addFileInfo(ZJFileInfo(name: "好压.exe", url: "http://dl.2345.com/haozip/haozip_v5.5.exe", perSize: "6.59M", fileType: "exe"));
        
        
        self.tableView.registerNib(UINib.init(nibName: "DownloadTableViewCell", bundle: nil), forCellReuseIdentifier: "DownloadTableViewCell");
        self.tableView.dataSource=self;
        self.tableView.delegate = self;
        
        self.documentInteractionController = UIDocumentInteractionController();
        self.documentInteractionController.delegate = self;
    }
    
    
    override func viewWillAppear(animated: Bool) {
        //禁止边缘手势
        self.navigationController?.interactivePopGestureRecognizer!.enabled = false;
    }
    
    override func viewDidAppear(animated: Bool) {
        ZJDownloadManager.delegate = self;
    }
    
    override func viewWillDisappear(animated: Bool) {
        ZJDownloadManager.delegate = nil;
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ZJFileDataSource.myDataSource.count;
    }
    
    //为表视图单元格提供数据，该方法是必须实现的方法
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let num=indexPath.row
        let item = ZJFileDataSource.myDataSource[num];
        if(ZJDownloadManager.fileIsExist(item)){
            item.status = ZJFileInfo.STATUS_COMPLETE;
            item.progress = 1;
            item.downloadPerSize = item.perSize;
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("DownloadTableViewCell") as! DownloadTableViewCell;
        cell.fileNameLabel.text = item.name;
        cell.fileSizeLabel.text = item.downloadPerSize + "/" + item.perSize;
        cell.downloadButton.setTitle(item.getButtonText(), forState: UIControlState.Normal);
        cell.statusLabel.text = item.getStatusText();
        cell.progress.progress = item.progress;
        cell.downloadButton.tag = num;
        cell.downloadButton.addTarget(self, action: "downloadClick:", forControlEvents: UIControlEvents.TouchUpInside)
        let path = NSBundle.mainBundle().pathForResource("big_ico_\(item.fileType.lowercaseString)@2x", ofType: "png");
        if(path == nil){
            cell.leftImageView.image = UIImage(named: "big_ico_hlp");
        }else{
            cell.leftImageView.image = UIImage(named: "big_ico_\(item.fileType.lowercaseString)");
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None;
        return cell;
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false;
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false;
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        ZJ_Func.delay(0.1) {
            ZJ_Func.unselectCell(tableView);
        }
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80;
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001;
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001;
    }
    
    func downloadClick(button:UIButton){
        let fileInfo = ZJFileDataSource.myDataSource[button.tag];
        switch (fileInfo.status) {
        case ZJFileInfo.STATUS_NOT_DOWNLOAD:
            logger.info("开始下载...")
            ZJDownloadManager.download(fileInfo);
            break;
        case ZJFileInfo.STATUS_CONNECTING:
            break;
        case ZJFileInfo.STATUS_CONNECT_ERROR:
            logger.info("重新下载")
            ZJDownloadManager.download(fileInfo);
            break;
        case ZJFileInfo.STATUS_DOWNLOADING:
            logger.info("暂停下载")
            ZJDownloadManager.pause(fileInfo);
            break;
        case ZJFileInfo.STATUS_PAUSED:
            logger.info("继续下载")
            ZJDownloadManager.start(fileInfo);
            break;
        case ZJFileInfo.STATUS_DOWNLOAD_ERROR:
            logger.info("重新下载")
            ZJDownloadManager.download(fileInfo);
            break;
        case ZJFileInfo.STATUS_COMPLETE:
            logger.info("打开文件")
            openFile(fileInfo);
            break;
        default:
            break;
        }
    }
    
    func viewRefresh() {
        self.tableView.reloadData();
    }
    
    func openFile(fileInfo:ZJFileInfo){
        let isExist = fileManager.fileExistsAtPath(documentsPath.stringByAppendingString("/Download/\(fileInfo.name)"));
        if(isExist){
            let des =  NSURL(fileURLWithPath: documentsPath.stringByAppendingString("/Download/\(fileInfo.name)"));
            
            self.documentInteractionController.URL = des;
            self.documentInteractionController.presentOpenInMenuFromRect(self.view.frame, inView: self.view, animated: true);
            
        }else{
            self.showNoticeInfo("文件尚未下载", time: 1.2);
        }
    }
    

    
}
