// Playground - noun: a place where people can play

import UIKit
import XCPlayground
import yavfl

func Root(color: UIColor = UIColor.redColor()) -> UIView {
    let v = UIView(frame: CGRect(x: 0, y: 0, width: 280, height: 150))
    v.layer.borderWidth = 1
    v.backgroundColor = UIColor.whiteColor()
    return v
}

let root = Root()

func View(text: String, color: UIColor = UIColor.redColor()) -> UIView {
    let v = UILabel()
    v.text = text
    v.textAlignment = .Center
    v.layer.borderWidth = 1
    v.layer.borderColor = color.CGColor
    root.addSubview(v)
    return v
}


let x = View("x")
let y = View("y")

XCPShowView("yavfl", view: root)

//: ### Sample 1
visualFormat(x, y) { x, y in
    .V ~ |-20-[x,==80];
    .V ~ [y,==50];
    .H ~ |-20-[x,==y]-10-[y]-20-| % .AlignAllCenterY
}

let tmp = root
