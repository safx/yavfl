//
//  yavflOSXTests.swift
//  yavflOSXTests
//
//  Created by Safx Developer on 2015/01/26.
//  Copyright (c) 2015年 Safx Developers. All rights reserved.
//

import Cocoa
import XCTest

class yavflOSXTests: XCTestCase {
    let x : ViewExpression = .View(LayoutViewName(NSView(), 1))
    let y : ViewExpression = .View(LayoutViewName(NSView(), 2))
    let z : ViewExpression = .View(LayoutViewName(NSView(), 3))
    
    func v(vf: VisualFormat) -> String {
        return vf.description
    }
    
    func opt(vf: VisualFormat) -> NSLayoutFormatOptions {
        return vf.options
    }
    
    func testExample() {
        XCTAssertEqual(v(|[x]|)              , "|[v1]|")
        XCTAssertEqual(v(|-[x]|)             , "|-[v1]|")
        XCTAssertEqual(v(|[x]-|)             , "|[v1]-|")
        XCTAssertEqual(v(|-[x]-|)            , "|-[v1]-|")
        XCTAssertEqual(v(|-10-[x]-20-|)      , "|-10-[v1]-20-|")
        XCTAssertEqual(v(|-(>=100)-[x]-0-|)  , "|-(>=100)-[v1]-0-|")
        XCTAssertEqual(v(|-[x]-(>=99)-|)     , "|-[v1]-(>=99)-|")
        XCTAssertEqual(v([x,<=y~1000])       , "[v1(<=v2@1000)]")
        XCTAssertEqual(v(|-0-[x,==200]-[y]-|), "|-0-[v1(==200)]-[v2]-|")
        
        XCTAssertEqual(v([x]-[y])              , "[v1]-[v2]")
        XCTAssertEqual(v([x,>=50])             , "[v1(>=50)]")
        XCTAssertEqual(v(|-50-[x]-50-|)        , "|-50-[v1]-50-|")
        XCTAssertEqual(v([x]-10-[y])           , "[v1]-10-[v2]")
        XCTAssertEqual(v([x]-0-[y])            , "[v1]-0-[v2]")
        XCTAssertEqual(v([x,==100~20])         , "[v1(==100@20)]")
        XCTAssertEqual(v([x,==y])              , "[v1(==v2)]")
        XCTAssertEqual(v([x,>=70,<=100])       , "[v1(>=70,<=100)]")
        XCTAssertEqual(v(|-[x]-[y]-[z,>=20]-|) , "|-[v1]-[v2]-[v3(>=20)]-|")
    }
    
    func testOptions() {
        XCTAssertEqual(opt(|[x]|)                   , NSLayoutFormatOptions())
        XCTAssertEqual(opt(|[x]| % .AlignAllCenterY), NSLayoutFormatOptions.AlignAllCenterY)

        XCTAssertEqual(v(|[x]|)                   , "[x]")
        XCTAssertEqual(v(|[x]| % .AlignAllCenterY), "[x]")
    }
    
    func testCapture() {
        let par = NSView()
        let v = NSView()
        par.addSubview(v)
        
        var q1: [AnyObject]?
        visualFormat(v) { v in
            q1 = .H ~ |-[v]
        }
        XCTAssertEqual(q1!.count, 1)
        
        var q2: [AnyObject]?
        visualFormat(v) { v in
            q2 = .H ~ |-[v]-|
        }
        XCTAssertEqual(q2!.count, 2)
    }
}
