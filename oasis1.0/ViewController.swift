//
//  ViewController.swift
//  oasis1.0
//
//  Created by Sandy Nguyen on 6/26/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    var timer: Timer?
    var endDate:Date?
    
    var secondsLeft: TimeInterval = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Configure initial state of the label and button
        updateLabel()
        button.setTitle("Start", for: .normal)
    }
    //Mark: - Life cycle
    override func viewWillDisappear(_ animated: Bool) {
        
        //check if timer is running
        
        if timer != nil && endDate != nil {
        
        //the timer is running, so stop it
            timer?.invalidate()
        
            
        //save end date
        let defaults = UserDefaults.standard
        defaults.set(endDate, forKey: "EndDate")
        
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let defaults = UserDefaults.standard
        
        // check if there is an end date saved
        if let date = defaults.value(forKey: "EndDate") as? Date{
            
            if Date() > date {
                // timer has expired
                
            }
            else{
                //get the seconds left
                secondsLeft = date.timeIntervalSince(Date())
                
                //start the timer
                timerStart()
            }
            defaults.set(nil, forKey: "EndDate")
        }
        
    }
    
    //Mark: - UI
    
    func updateLabel() {
        label.text = String(round(secondsLeft))
    }

    //Mark: - Timer function
    
    @objc func timerTick() {
        //Decrement the seconds left
        secondsLeft -= 1
        
        // Update the label
        updateLabel()
        
        //Check if timer has expired
        if secondsLeft <= 0 {
            timerEnd()
        }
    }
    
    func timerStart() {
        
        //hardcode the number of seconds
        secondsLeft = 100
        
        //create timer and run it
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
        //set an end date
        
        endDate = Date().addingTimeInterval(secondsLeft)
        
        //update the label
        updateLabel()
        
        //update the text of the label
        button.setTitle("Pause", for: .normal)    }
    
    
    func timerPause() {
        
        //kill the timer
        timer?.invalidate()
        
        //reset the end date
        endDate = nil
        
        //update the button text
        button.setTitle("Continue", for: .normal)
        
    }
    
    func timerEnd() {
        //Kill the timer
        timer?.invalidate()
        
        //reset the timer
        timer = nil
        //reset the end date
        endDate = nil
        //update the button text
        button.setTitle("Restart", for: .normal)
    }
    
    // Mark: - User Interaction
    

    @IBAction func tapped( sender: Any){
        
        //Timer hasn't been run
        if timer == nil {
            //timer hasn't been run
            timerStart()
            
            
        }
        else if timer != nil && endDate == nil {
            
            //currently paused
            timerStart()
        }
        else if timer != nil && endDate != nil {
            //currently running
            timerPause()
        }
    }
    
}

