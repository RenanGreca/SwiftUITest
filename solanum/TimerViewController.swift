//
//  TimerViewController.swift
//  solanum
//
//  Created by Cinq Technologies on 08/03/18.
//  Copyright © 2018 renangreca. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var taskNameField: UITextField!
    
    @IBOutlet weak var workTimeSlider: UISlider!
    @IBOutlet weak var breakTimeSlider: UISlider!
    @IBOutlet weak var repsStepper: UIStepper!
    
    @IBOutlet weak var workLabel: UILabel!
    @IBOutlet weak var breakLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.refresh()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.userDidSelectPreset),
                                               name: NSNotification.Name(Strings.kSelectPresetNotification.rawValue),
                                               object: nil)
        
        self.repsStepper.accessibilityLabel = "Reps Stepper"
    }
    
    func refresh() {
        self.workTimeDidChange(self.workTimeSlider)
        self.breakTimeDidChange(self.breakTimeSlider)
        self.repsDidChange(self.repsStepper)
    }
    
    @objc func userDidSelectPreset(notification: Notification) {
        let preset = notification.userInfo!
        
        self.workTimeSlider.value = Float(preset["workTime"] as! Int)
        self.breakTimeSlider.value = Float(preset["breakTime"] as! Int)
        self.repsStepper.value = Double(preset["reps"] as! Int)
        
        self.refresh()
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelPresets(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func giveup(segue: UIStoryboardSegue) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Inputs
    @IBAction func workTimeDidChange(_ sender: UISlider) {
        self.workLabel.text = "\(sender.value) minutes"
    }
    
    @IBAction func breakTimeDidChange(_ sender: UISlider) {
        self.breakLabel.text = "\(sender.value) minutes"
    }
    
    @IBAction func repsDidChange(_ sender: UIStepper) {
        self.repsLabel.text = "\(sender.value) time\( sender.value == 1 ? "" : "s" )"
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is WorkViewController {
            let work = segue.destination as! WorkViewController
            work.taskName = self.taskNameField.text == "" ? "Some random task" : self.taskNameField.text
            work.workMinutes = Int(self.workTimeSlider.value)
            work.breakMinutes = Int(self.breakTimeSlider.value)
            work.reps = Int(self.repsStepper.value)
        }
        
        
    }
 

}
