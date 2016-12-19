//
//  BTWeatnerInfoViewController.swift
//  BeautifulTimes
//
//  Created by deng on 16/12/10.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

import UIKit
import SnapKit

class BTWeatnerInfoViewController: UIViewController {
    
    private var closeButton: UIButton!
    private var backgroundImageView: UIImageView!
    private var  temperatureLaber: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        prepareCloseButton()
        prepareBackgroundImage()
        prepareTemperatureLaber()
    
        self.view.addSubview(self.backgroundImageView)
        self.view.addSubview(self.closeButton)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.closeButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-20)
            make.width.equalTo(36)
            make.height.equalTo(36)
            make.centerX.equalTo(self.view)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - prepare method
    private func prepareCloseButton() {
        closeButton = UIButton.init()
        closeButton.addTarget(self, action:#selector(closeView), for: .touchUpInside)
        closeButton.setBackgroundImage(BTThemeManager.getInstance().loadImageInDefaultTheme(withName: "cm_close_white"), for: .normal)
        closeButton.alpha = 0.8
    }
    
    private func prepareBackgroundImage() {
        backgroundImageView = UIImageView(frame: self.view.frame)
        backgroundImageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        backgroundImageView.image = BTThemeManager.getInstance().loadImageInDefaultTheme(withName: "com_weather_bg")
        backgroundImageView.alpha = 0.8
    }
    
    private func prepareTemperatureLaber() {
        
    }
    
    // MARK: - click event
    func closeView() {
        self .dismiss(animated: true) { 
            
        }
    }

}
