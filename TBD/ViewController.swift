//
//  ViewController.swift
//  TBD
//
//  Created by Callum Dixon on 20/06/2022.
//

import Cocoa
import RxSwift

class ViewController: NSViewController {
    
    var timer: Timer?
   
    let workDurationInMin : Double = 0.1
    let breakDurationInMin : Double = 0.05
    let workDuration : Double
    let breakDuration : Double
    
    var isInFullScreen : Bool = false
    var countdown : Double
    
    let videoCallChecker = VideoCallChecker()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var countdownLabel: NSTextField!
    @IBOutlet weak var toggleButton: NSButton!
    @IBOutlet weak var analyticsButton: NSButton!
    
    required init?(coder code: NSCoder) {
        self.timer = Timer()
        workDuration = workDurationInMin * 60
        breakDuration = breakDurationInMin * 60
        countdown = breakDuration
        print(AppDelegate.shared.userData.count)
        super.init(coder: code)
    }
    
    // Load the application
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timer = Timer.scheduledTimer(timeInterval: workDuration, target: self, selector: #selector(fireRestEvent), userInfo: nil, repeats: false)
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func overrideButton(_ sender: Any) {
        unLockScreen()
    }
    
    @IBAction func togglePressed(_ sender: Any) {
        if isInFullScreen {
            unLockScreen()
            self.timer = Timer.scheduledTimer(timeInterval: workDuration, target: self, selector: #selector(fireRestEvent), userInfo: nil, repeats: false)
        }
        else {
            lockScreen()
        }
    }
    
    func lockScreen() {
        
        // The session for the app that was open before the lockout should be ended
        AppDelegate.shared.endSession(currentSessionEndTime: Date.now)
        
        let presOptions: NSApplication.PresentationOptions = [
            .hideDock,
            //.disableForceQuit
        ]
        
        let optionsDictionary = [NSView.FullScreenModeOptionKey.fullScreenModeApplicationPresentationOptions: presOptions]
        
        self.analyticsButton.isHidden = true
        
        isInFullScreen = true
        for screen in NSScreen.screens {
            NSApp.setActivationPolicy(.accessory)
            self.view.enterFullScreenMode(screen, withOptions: optionsDictionary)
        }
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
    }
    
    func unLockScreen() {
        
        // A session for the app that was open before the lockout should be created. This function attempts that
        if let name = NSWorkspace.shared.frontmostApplication?.localizedName{
            AppDelegate.shared.startSession(name: name, newSessionStartTime: Date.now)
        }
            
        isInFullScreen = false
        NSApp.setActivationPolicy(.regular)
        self.view.exitFullScreenMode()
        toggleButton.isHidden = true
        self.analyticsButton.isHidden = false

        resetTimer()
    }
   
    @objc func updateTimer(){
        if(self.timer != nil){
            countdownLabel.stringValue = buildCountdownLabelMessage(countdown:countdown)
            
            print(countdown < 1)
            
            if(countdown  < 1) {
                //countdownLabel.stringValue = String(countdown)
                self.timer?.invalidate()
                self.timer = nil
                self.timer?.replaceValue(at: 0, inPropertyWithKey: "repeats", withValue: false)
                toggleButton.isHidden = false
            }
            else {
                countdown -= 1
            }
            countdownLabel.isHidden = false
        }
        
      

    }
    
    func resetTimer(){
        countdownLabel.stringValue = ""
        countdown = breakDuration
        countdownLabel.isHidden = true
    }
    

    
    @objc func fireRestEvent() {
        
        videoCallChecker.isInCall.subscribe(
            onNext: { value in
                if !value {
                    self.lockScreen()
                }
                else{
                    print("Zoom is currently open. Ill wait for it to close")
                }
            }
        )
        .disposed(by: disposeBag)
    }
    
    func autoLock()async {
        
    }
   
    func buildCountdownLabelMessage(countdown:Double) -> String {
        
        if(countdown < 0){
            return "Invalid value"
            
        }
        let temp:Int = Int(countdown)
        let mins:Int = temp / 60
        let secs:Int = temp % 60
        
        let minsString:String = mins > 9 ? String(mins) : "0" + String(mins)
        

        let secsString:String = secs > 9 ? String(secs) : "0" + String(secs)
        
        let countdownLabelMessage = String( minsString + ":" + secsString)
        
        return countdownLabelMessage
    }


}

