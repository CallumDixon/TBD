//
//  ViewController.swift
//  TBD
//
//  Created by Callum Dixon on 20/06/2022.
//

import Cocoa

class ViewController: NSViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

