//
//  yavflTests.swift
//  yavflTests
//
//  Created by Safx Developer on 2014/12/07.
//  Copyright (c) 2014 Safx Developers. All rights reserved.
//

import UIKit
import XCTest

class yavflTests: XCTestCase {
    let x : ViewExpression = .View(LayoutViewName(UIView(), 1))
    let y : ViewExpression = .View(LayoutViewName(UIView(), 2))
    let z : ViewExpression = .View(LayoutViewName(UIView(), 3))

    func v(vf: VisualFormat) -> String {
        return vf.description
    }

    func testExample() {
        XCTAssertEqual(v(|[x]|)              , "|[v1]|")
        XCTAssertEqual(v(|-[x]|)             , "|-[v1]|")
        XCTAssertEqual(v(|[x]-|)             , "|[v1]-|")
        XCTAssertEqual(v(|-[x]-|)            , "|-[v1]-|")
        XCTAssertEqual(v(|-10-[x]-20-|)      , "|-10-[v1]-20-|")
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
}
