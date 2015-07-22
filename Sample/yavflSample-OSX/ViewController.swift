//
//  ViewController.swift
//  yavflSample-OSX
//
//  Created by Safx Developer on 2015/01/23.
//  Copyright (c) 2015 Safx Developers. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let textField1 = NSTextField()
        let textField2 = NSTextField()
        
        textField1.stringValue = "Label"
        textField1.backgroundColor = NSColor.grayColor()
        view.addSubview(textField1)
        view.addSubview(textField2)
        
        visualFormat(textField1, textField2) { l, t in
            .V ~ |-80-[l,==32];
            .V ~ [t,==48];
            .H ~ |-20-[l,==t]-10-[t]-| % .AlignAllCenterY
        }
    }
}

