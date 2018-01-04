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

    var documentInteractionController:UIDocumentInteractionController!;
    
    var isFirstLoad = true;
    
    let fileManager = FileManager.default;
    let documentsPath: AnyObject = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as AnyObject
    fileprivate static let documentsPath: AnyObject = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as AnyObject
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //添加假数据
        ZJFileDataSource.addFileInfo(ZJFileInfo(name: "壁纸.jpg", url: "http://bbs.feng.com/data/attachment/forum/201412/02/164442jakbgm3zalof1fig.jpg", perSize: "101.4k", fileType: "jpg"));
        ZJFileDataSource.addFileInfo(ZJFileInfo(name: "360手机卫士.apk", url: "http://msoftdl.360.cn/mobilesafe/shouji360/360safesis/360MobileSafe_6.2.3.1060.apk", perSize: "8.48M", fileType: "apk"));
        ZJFileDataSource.addFileInfo(ZJFileInfo(name: "好压.exe", url: "http://dl.2345.com/haozip/haozip_v5.5.exe", perSize: "6.59M", fileType: "exe"));
        
        
        self.tableView.register(UINib.init(nibName: "DownloadTableViewCell", bundle: nil), forCellReuseIdentifier: "DownloadTableViewCell");
        self.tableView.dataSource=self;
        self.tableView.delegate = self;
        
        self.documentInteractionController = UIDocumentInteractionController();
        self.documentInteractionController.delegate = self;
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //禁止边缘手势
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ZJDownloadManager.delegate = self;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ZJDownloadManager.delegate = nil;
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ZJFileDataSource.myDataSource.count;
    }
    
    //为表视图单元格提供数据，该方法是必须实现的方法
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let num=(indexPath as NSIndexPath).row
        let item = ZJFileDataSource.myDataSource[num];
        if(isFirstLoad){
            if(ZJDownloadManager.fileIsExist(item)){
                item.status = ZJFileInfo.STATUS_COMPLETE;
                item.progress = 1;
                item.downloadPerSize = item.perSize;
            }
            if(item == ZJFileDataSource.myDataSource.last){
                isFirstLoad = false;
            }
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadTableViewCell") as! DownloadTableViewCell;
        cell.fileNameLabel.text = item.name;
        cell.fileSizeLabel.text = item.downloadPerSize + "/" + item.perSize;
        cell.downloadButton.setTitle(item.getButtonText(), for: UIControlState());
        cell.statusLabel.text = item.getStatusText();
        cell.progress.progress = item.progress;
        cell.downloadButton.tag = num;
        cell.downloadButton.addTarget(self, action: #selector(DownloadViewController.downloadClick(_:)), for: UIControlEvents.touchUpInside)
        let path = Bundle.main.path(forResource: "big_ico_\(item.fileType.lowercased())@2x", ofType: "png");
        if(path == nil){
            cell.leftImageView.image = UIImage(named: "big_ico_hlp");
        }else{
            cell.leftImageView.image = UIImage(named: "big_ico_\(item.fileType.lowercased())");
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        return cell;
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false;
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false;
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ZJ_Func.delay(0.1) {
            ZJ_Func.unselectCell(tableView);
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001;
    }
    
    func downloadClick(_ button:UIButton){
        let fileInfo = ZJFileDataSource.myDataSource[button.tag];
        switch (fileInfo.status) {
        case ZJFileInfo.STATUS_NOT_DOWNLOAD:
            print("开始下载...")
            ZJDownloadManager.download(fileInfo);
            break;
        case ZJFileInfo.STATUS_CONNECTING:
            break;
        case ZJFileInfo.STATUS_CONNECT_ERROR:
            print("重新下载")
            ZJDownloadManager.download(fileInfo);
            break;
        case ZJFileInfo.STATUS_DOWNLOADING:
            print("暂停下载")
            ZJDownloadManager.pause(fileInfo);
            break;
        case ZJFileInfo.STATUS_PAUSED:
            print("继续下载")
            ZJDownloadManager.start(fileInfo);
            break;
        case ZJFileInfo.STATUS_DOWNLOAD_ERROR:
            print("重新下载")
            ZJDownloadManager.download(fileInfo);
            break;
        case ZJFileInfo.STATUS_COMPLETE:
            print("打开文件")
            openFile(fileInfo);
            break;
        default:
            break;
        }
    }
    
    func viewRefresh() {
        self.tableView.reloadData();
    }
    
    func openFile(_ fileInfo:ZJFileInfo){
        let isExist = fileManager.fileExists(atPath: documentsPath.appending("/Download/\(fileInfo.name)"));
        if(isExist){
            let des =  URL(fileURLWithPath: documentsPath.appending("/Download/\(fileInfo.name)"));
            
            self.documentInteractionController.url = des;
            self.documentInteractionController.presentOpenInMenu(from: self.view.frame, in: self.view, animated: true);
            
        }else{
            self.showNoticeInfo("文件尚未下载", time: 1.2);
        }
    }
    
}
