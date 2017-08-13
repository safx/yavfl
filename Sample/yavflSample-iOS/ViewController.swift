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
        label.backgroundColor = UIColor.gray
        textField.placeholder = "Input some text"
        textField.borderStyle = .line
        view.addSubview(label)
        view.addSubview(textField)
        
        visualFormat(label, textField) { l, t in
            .v ~ |-80-[l,==32];
            .v ~ [t,==48];
            .h ~ |-20-[l,==t]-10-[t]-| % .alignAllCenterY
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

