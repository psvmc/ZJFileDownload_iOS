//
//  ZJYuanjiaoButton.swift
//  easysong_ios
//
//  Created by 张剑 on 15/10/15.
//
//

import UIKit

class ZJYuanjiaoButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.layer.cornerRadius = self.frame.height/8;
        self.layer.masksToBounds = true;
    }

}
