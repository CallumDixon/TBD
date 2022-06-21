//
//  ViewController.swift
//  TBD
//
//  Created by Callum Dixon on 20/06/2022.
//

import Cocoa

class ViewController: NSViewController {
    
    var timer: Timer
    //25mins = 1500secs
    //3mins = 300secs
   
    let workDurationInMin : Double = 0.1
    let breakDurationInMin : Double = 0.1
    let workDuration : Double
    let breakDuration : Double
    
    var countdown : Double
    
    @IBOutlet weak var countdownLabel: NSTextField!
    
    
    @IBAction func overrideButton(_ sender: Any) {
        unLockScreen()
    }
    
    required init?(coder code: NSCoder) {
        timer = Timer()
        workDuration = workDurationInMin * 60
        breakDuration = breakDurationInMin * 60
        countdown = breakDuration
        super.init(coder: code)
    }
    
    @IBOutlet weak var toggleButton: NSButton!
    
    @IBAction func togglePressed(_ sender: Any) {
        //test
        if self.view.isInFullScreenMode {
            unLockScreen()
            timer = Timer.scheduledTimer(timeInterval: workDuration, target: self, selector: #selector(fireRestEvent), userInfo: nil, repeats: false)
            toggleButton.isHidden = true
        }
        else {
            lockScreen()
        }
    }
    
    func lockScreen() {
        let presOptions: NSApplication.PresentationOptions = [
            .hideDock,
            //.disableForceQuit
            
        ]
        
        let optionsDictionary = [NSView.FullScreenModeOptionKey.fullScreenModeApplicationPresentationOptions: presOptions]
                
        for screen in NSScreen.screens {
            NSApp.setActivationPolicy(.accessory)
            self.view.enterFullScreenMode(screen, withOptions: optionsDictionary)
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        countdownLabel.isHidden = false
        
    }
    
    @objc func updateTimer(){

        
        print(countdown)
        print(countdown < 1)
        
        if(countdown == 0.0){
            countdownLabel.stringValue = String(countdown)
            timer.invalidate()
        }
        
        countdownLabel.stringValue = String(countdown)
        countdown -= 1
    
    }
    
    func resetTimer(){
        countdownLabel.stringValue = ""
        countdown = breakDurationInMin * 60
        countdownLabel.isHidden = true
    }
    
    func unLockScreen() {
        NSApp.setActivationPolicy(.regular)
        self.view.exitFullScreenMode()
        
        resetTimer()
    }
    
    // Load the application
    override func viewDidLoad() { //Starting a timer for 25 mins, then fire the rest event
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: workDuration, target: self, selector: #selector(fireRestEvent), userInfo: nil, repeats: false)
        // Do any additional setup after loading the view.
    }
    
    //Auto locking the screen after 25 mins
    
    @objc func fireRestEvent() { //Locks the screen for 5 mins, then fire the work event
        self.lockScreen()
        timer = Timer.scheduledTimer(timeInterval: breakDuration, target: self, selector: #selector(fireWorkEvent), userInfo: nil, repeats: false)
    }
    
    @objc func fireWorkEvent() { //Unlocks the screen for the next 25 mins
//        self.unLockScreen()
        toggleButton.isHidden = false
    }
    
    func autoLock()async {
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

