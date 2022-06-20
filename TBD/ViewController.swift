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
   
    let workDurationInMin : Double = 25
    let breakDurationInMin : Double = 5
    let workDuration : Double
    let breakDuration : Double
    

    @IBAction func togglePressed(_ sender: Any) {
        //test
        if self.view.isInFullScreenMode {
            unLockScreen()
        }
        
        else {
            lockScreen()
        }
    }
    
    func lockScreen() {
        let presOptions: NSApplication.PresentationOptions = [
            .hideDock,
        ]
        
        let optionsDictionary = [NSView.FullScreenModeOptionKey.fullScreenModeApplicationPresentationOptions: presOptions]
                
        for screen in NSScreen.screens {
            NSApp.setActivationPolicy(.accessory)
            self.view.enterFullScreenMode(screen, withOptions: optionsDictionary)
        }
    }
    
    func unLockScreen() {
        NSApp.setActivationPolicy(.regular)
        self.view.exitFullScreenMode()
    }
    
    required init?(coder code: NSCoder) {
        timer = Timer()
        workDuration = workDurationInMin * 1
        breakDuration = breakDurationInMin * 1
        super.init(coder: code)
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
        self.unLockScreen()
        timer = Timer.scheduledTimer(timeInterval: workDuration, target: self, selector: #selector(fireRestEvent), userInfo: nil, repeats: false)
    }
    
    func autoLock()async {
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

