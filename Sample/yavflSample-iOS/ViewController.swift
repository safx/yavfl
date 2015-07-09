//
//  ViewController.swift
//  yavfl
//
//  Created by Safx Developer on 2014/12/07.
//  Copyright (c) 2014 Safx Developers. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let label = UILabel()
        let textField = UITextField()
        
        label.text = "Label"
        label.backgroundColor = UIColor.grayColor()
        textField.placeholder = "Input some text"
        textField.borderStyle = .Line
        view.addSubview(label)
        view.addSubview(textField)
        
        visualFormat(label, textField) { l, t in
            .V ~ |-80-[l,==32];
            .V ~ [t,==48];
            .H ~ |-20-[l,==t]-10-[t]-| % .AlignAllCenterY
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

