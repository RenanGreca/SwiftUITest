//
//  WorkViewController.swift
//  solanum
//
//  Created by Cinq Technologies on 08/03/18.
//  Copyright © 2018 renangreca. All rights reserved.
//

import UIKit
import AVFoundation

enum WorkState:Int {
    case Working
    case Break
}

class WorkViewController: UIViewController {

    var taskName:String?
    
    var workMinutes:Int?
    var breakMinutes:Int?
    var reps:Int?
    
    var totalWork:Int = 0
    var totalBreak:Int = 0
    
    var isRunning = false
    var state:WorkState?
    var countDown:Int?
    var timer:Timer?
    var alertSound = AVAudioPlayer()
    
    @IBOutlet weak var taksLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let soundURL = Bundle.main.url(forResource: "alert", withExtension: "caf")
        try? self.alertSound = AVAudioPlayer(contentsOf: soundURL!)
        self.alertSound.prepareToPlay()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (!isRunning) {
            self.startTimer()
        }
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.timer?.invalidate()
        self.timer = nil
        
        var historyEntries:Array<Dictionary<String, Any>>
        if let savedHistories = UserDefaults.standard.object(forKey: Strings.kSettingsHistoryKey.rawValue) as? Array<Dictionary<String, Any>> {
            historyEntries = savedHistories
        } else {
            historyEntries = []
        }
        
        historyEntries.insert([
                                Strings.kHistoryTaskNameKey.rawValue: self.taskName!,
                                Strings.kHistoryTotalWorkKey.rawValue: self.totalWork,
                                Strings.kHistoryTotalBreakKey.rawValue: self.totalBreak,
                                Strings.kHistoryCompletedSetKey.rawValue: Bool(sender is WorkViewController),
                                Strings.kHistoryFinishTimeKey.rawValue: Date()
                              ], at: 0)
        
        UserDefaults.standard.set(historyEntries, forKey: Strings.kSettingsHistoryKey.rawValue)
        UserDefaults.standard.synchronize()
        
        NotificationCenter.default.post(name: NSNotification.Name(Strings.kWorkedNotification.rawValue),
                                        object: self,
                                        userInfo: nil)
        
    }
    
    func startTimer() {
        self.taksLabel.text = self.taskName
        self.titleLabel.text = "Get to work!"
        self.timeLabel.text = "\(self.workMinutes!) minutes to go"
        
        let tickTime = UserDefaults.standard.bool(forKey: Strings.kSettingsDebugModeKey.rawValue) ? 0.5 : 60
        
        self.timer = Timer.scheduledTimer(timeInterval: tickTime,
                           target: self,
                           selector: #selector(self.timerTick),
                           userInfo: nil,
                           repeats: true)
        
        self.state = .Working
        self.countDown = self.workMinutes
        
        self.isRunning = true
    }
    
    @objc func timerTick() {
        countDown! -= 1
        
        if state == .Working {
            totalWork += 1
        } else {
            totalBreak += 1
        }
        
        if countDown == 0 {
            alertSound.play()
            
            if state == .Working {
                self.reps? -= 1
                
                if self.reps == 0 {
//                    self.dismiss(animated: true, completion: nil)
                    self.performSegue(withIdentifier: "finishWork", sender: self)
                    return
                }
                
                state = .Break
                self.titleLabel.text = "Take a break!"
                countDown = self.breakMinutes
            } else {
                state = .Working
                self.titleLabel.text = "Get to work!"
                countDown = self.workMinutes
            }
        }
        
        let text:String
        if countDown == 1 {
            text = "Less than a minute left!"
        } else {
            text = "\(countDown!) minutes to go"
        }
        
        self.timeLabel.text = text
    }

}
