//
//  ViewController.swift
//  BustPushAss
//
//  Created by aochuih on 16/8/23.
//  Copyright © 2016年 aochuih. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var curlPathTextField:NSTextField!
    @IBOutlet var pemPathTextField:NSTextField!
    @IBOutlet var bundlerIDTextField:NSTextField!
    @IBOutlet var tokenTextField:NSTextField!
    @IBOutlet var payloadTextField:NSTextField!
    @IBOutlet var outputText:NSTextView!
    @IBOutlet var envPopupButton:NSPopUpButton!
    @IBOutlet var sendButton:NSButton!

    var buildTask:NSTask!
    var outputPipe:NSPipe!
    var devAddress:NSString = "api.development.push.apple.com"
    var proAddress:NSString = "api.push.apple.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        curlPathTextField.placeholderString = "Input the 'curl' path, HTTP/2.0 support is needed. e.g. /usr/local/Cellar/curl/7.50.1/bin/curl"
        pemPathTextField.placeholderString = "Input the pem file path and password, e.g. ./aps.pem:12345"
        bundlerIDTextField.placeholderString = "Input your app's bundler ID"
        tokenTextField.placeholderString = "Input the device token"
        payloadTextField.placeholderString = "{\"aps\":{\"alert\":\"Hi!\",\"sound\":\"default\"}}"
        
        payloadTextField.stringValue = "{\"aps\":{\"alert\":\"Hi!\",\"sound\":\"default\"}}"
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func startTask(sender:AnyObject) {
        self.sendButton.enabled = false
        
        var arguments:[String] = []
        arguments.append(curlPathTextField.stringValue)
        arguments.append(payloadTextField.stringValue)
        arguments.append(pemPathTextField.stringValue)
        arguments.append(bundlerIDTextField.stringValue)
        arguments.append((envPopupButton.indexOfSelectedItem == 0 ? proAddress : devAddress) as String)
        arguments.append(tokenTextField.stringValue)
        
        runScript(arguments)
    }

    func runScript(arguments:[String]) {
        let taskQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
        
        dispatch_async(taskQueue) {
            guard let path = NSBundle.mainBundle().pathForResource("Script",ofType:"command") else {
                print("Unable to locate Script.command")
                return
            }
            
            self.buildTask = NSTask()
            self.buildTask.launchPath = path
            self.buildTask.arguments = arguments
            self.buildTask.terminationHandler = { task in
                dispatch_async(dispatch_get_main_queue(), {
                    self.sendButton.enabled = true
                })
                
            }
            
            self.captureStandardOutputAndRouteToTextView(self.buildTask)
            
            self.buildTask.launch()
            self.buildTask.waitUntilExit()
        }
        
    }
    
    func captureStandardOutputAndRouteToTextView(task:NSTask) {
        outputPipe = NSPipe()
        task.standardOutput = outputPipe
        task.standardError = outputPipe
        
        outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        
        NSNotificationCenter.defaultCenter().addObserverForName(NSFileHandleDataAvailableNotification, object: outputPipe.fileHandleForReading , queue: nil) {
            notification in
            
            let output = self.outputPipe.fileHandleForReading.availableData
            let outputString = String(data: output, encoding: NSUTF8StringEncoding) ?? ""
            
            dispatch_async(dispatch_get_main_queue(), {
                let previousOutput = self.outputText.string ?? ""
                let nextOutput = previousOutput + "\n" + outputString
                self.outputText.string = nextOutput
                
                let range = NSRange(location:nextOutput.characters.count,length:0)
                self.outputText.scrollRangeToVisible(range)
            })
            self.outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        }
    }
}
