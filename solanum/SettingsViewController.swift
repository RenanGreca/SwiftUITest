//
//  SettingsViewController.swift
//  solanum
//
//  Created by Cinq Technologies on 08/03/18.
//  Copyright © 2018 renangreca. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIAlertViewDelegate {
    
    @IBOutlet weak var debugModeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.debugModeSwitch.setOn(UserDefaults.standard.bool(forKey: Strings.kSettingsDebugModeKey.rawValue), animated: false)
    }
    
    @IBAction func toggleDebugModeSwitch(_ sender: UISwitch) {
        
        UserDefaults.standard.set(sender.isOn, forKey: Strings.kSettingsDebugModeKey.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func clearHistoryTapped(_ sender: Any) {

        let alertController = UIAlertController(title: "Clear History?", message: "Clear all work and task history?", preferredStyle: UIAlertControllerStyle.alert)
        
        let yesButton = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {
            action in
                self.clearHistory()
        })
        
        let noButton = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil)
        
        alertController.addAction(yesButton)
        alertController.addAction(noButton)
        
        self.present(alertController, animated: true, completion: nil)

    }
    
    func clearHistory() {
        UserDefaults.standard.removeObject(forKey: Strings.kSettingsHistoryKey.rawValue)
        UserDefaults.standard.synchronize()
        
        NotificationCenter.default.post(name: NSNotification.Name(Strings.kWorkedNotification.rawValue),
                                        object: self,
                                        userInfo: nil)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
