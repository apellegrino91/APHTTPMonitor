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
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func switchValueChanged(_ sender: Any) {
        if switchMonitor.isOn {
            startTimer()
            let url = APHTTPMonitor.shared().start()
            lblStatus.textColor = UIColor.systemGreen
            lblStatus.text = "Active"
            lblServerUrl.text = url
        } else {
            stopTimer()
            APHTTPMonitor.shared().stop()
            lblStatus.textColor = UIColor.red
            lblStatus.text = "Stopped"
            lblServerUrl.text = ""
        }
    }
    
    func startTimer() {
        guard timer == nil else {return}
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(scheduleRequest), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func scheduleRequest() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
}

