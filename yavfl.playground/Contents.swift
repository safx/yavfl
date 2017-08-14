// Playground - noun: a place where people can play

import UIKit
import XCPlayground
import yavfl

func Root(color: UIColor = .red) -> UIView {
    let v = UIView(frame: CGRect(x: 0, y: 0, width: 280, height: 150))
    v.layer.borderWidth = 1
    v.backgroundColor = .white
    return v
}

let root = Root()

func View(text: String, color: UIColor = .red) -> UIView {
    let v = UILabel()
    v.text = text
    v.textAlignment = .center
    v.layer.borderWidth = 1
    v.layer.borderColor = color.cgColor
    root.addSubview(v)
    return v
}


let x = View(text: "x", color: .blue)
let y = View(text: "y", color: .green)

//: ### Sample 1
visualFormat(x, y) { x, y in
    .v ~ |-20-[x,==80];
    .v ~ [y,==50];
    .h ~ |-20-[x,==y]-10-[y]-20-| % .alignAllCenterY
}


XCPlaygroundPage.currentPage.liveView = root
root
