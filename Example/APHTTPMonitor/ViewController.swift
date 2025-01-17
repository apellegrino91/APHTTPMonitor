//
//  ViewController.swift
//  APHTTPMonitor
//
//  Created by 14331895 on 01/15/2025.
//  Copyright (c) 2025 14331895. All rights reserved.
//

import UIKit
import APHTTPMonitor

class ViewController: UIViewController {

    @IBOutlet weak var switchMonitor: UISwitch!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblServerUrl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblStatus.textColor = UIColor.red
        
    }

    @IBAction func switchValueChanged(_ sender: Any) {
        if switchMonitor.isOn {
            let url = APHTTPMonitor.shared().start()
            lblStatus.textColor = UIColor.systemGreen
            lblStatus.text = "Active"
            lblServerUrl.text = url
        } else {
            APHTTPMonitor.shared().stop()
            lblStatus.textColor = UIColor.red
            lblStatus.text = "Stopped"
            lblServerUrl.text = ""
        }
    }
}

