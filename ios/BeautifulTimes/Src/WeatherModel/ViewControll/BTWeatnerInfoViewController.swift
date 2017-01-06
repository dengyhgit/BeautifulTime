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
    private var temperatureLaber: UILabel!
    private var locationIcon: UIImageView!
    private var cityLaber: UILabel!
    private var refreshButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        prepareCloseButton()
        prepareBackgroundImage()
        prepareTemperatureLaber()
        prepareLocationIcon()
        prepareCityLabel()
        prepareRefreshButton()
    
        self.view.addSubview(self.backgroundImageView)
        self.view.addSubview(self.closeButton)
        self.view.addSubview(self.temperatureLaber)
        self.view.addSubview(self.locationIcon)
        self.view.addSubview(self.cityLaber)
        self.view.addSubview(self.refreshButton)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.closeButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-20)
            make.width.equalTo(36)
            make.height.equalTo(36)
            make.centerX.equalTo(self.view)
        }
        self.temperatureLaber.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(self.view.frame.size.height / 4);
            make.width.equalTo(self.view)
            make.height.equalTo(70)
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
        temperatureLaber = UILabel.init()
        temperatureLaber.text = "23°"
        temperatureLaber.textColor = UIColor.white
        temperatureLaber.textAlignment = .center
        temperatureLaber.font = UIFont.systemFont(ofSize: 65)
    }
    
    private func prepareLocationIcon() {
        locationIcon = UIImageView.init()
    }
    
    private func prepareCityLabel() {
        cityLaber = UILabel.init()
    }
    
    private func prepareRefreshButton() {
        refreshButton = UIButton.init()
    }
    
    // MARK: - click event
    func closeView() {
        self .dismiss(animated: true) { 
            
        }
    }
    
    func refreshWeatherInfo() {
    
    }
    
    public func bindData(data: BTWeatherModel) {
    
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
