//
//  yavflTests_tvos.swift
//  yavflTests-tvos
//
//  Created by Safx Developer on 2015/11/17.
//  Copyright © 2015年 Safx Developers. All rights reserved.
//


import UIKit
import XCTest
@testable import yavfl

extension LayoutViewName: Equatable {}
public func == (lhs: LayoutViewName, rhs: LayoutViewName) -> Bool {
    return lhs.index == rhs.index && lhs.view === rhs.view
}


class yavflTests: XCTestCase {

    func vf(vf: VisualFormat) -> String {
        return vf.description
    }

    func opt(vf: VisualFormat) -> NSLayoutFormatOptions {
        return vf.options
    }

    func rv(vf: VisualFormat) -> [LayoutViewName] {
        return vf.relatedViews
    }

    func testVisualFormat() {
        let x : ViewExpression = .View(LayoutViewName(view: UIView(), index: 1))
        let y : ViewExpression = .View(LayoutViewName(view: UIView(), index: 2))
        let z : ViewExpression = .View(LayoutViewName(view: UIView(), index: 3))

        XCTAssertEqual(vf(|[x]|)              , "|[v1]|")
        XCTAssertEqual(vf(|-[x]|)             , "|-[v1]|")
        XCTAssertEqual(vf(|[x]-|)             , "|[v1]-|")
        XCTAssertEqual(vf(|-[x]-|)            , "|-[v1]-|")
        XCTAssertEqual(vf(|-10-[x]-20-|)      , "|-10-[v1]-20-|")
        XCTAssertEqual(vf(|-(>=100)-[x]-0-|)  , "|-(>=100)-[v1]-0-|")
        XCTAssertEqual(vf(|-[x]-(>=99)-|)     , "|-[v1]-(>=99)-|")
        XCTAssertEqual(vf([x,<=y~1000])       , "[v1(<=v2@1000)]")
        XCTAssertEqual(vf(|-0-[x,==200]-[y]-|), "|-0-[v1(==200)]-[v2]-|")

        XCTAssertEqual(vf([x]-[y])              , "[v1]-[v2]")
        XCTAssertEqual(vf([x,>=50])             , "[v1(>=50)]")
        XCTAssertEqual(vf(|-50-[x]-50-|)        , "|-50-[v1]-50-|")
        XCTAssertEqual(vf([x]-10-[y])           , "[v1]-10-[v2]")
        XCTAssertEqual(vf([x]-0-[y])            , "[v1]-0-[v2]")
        XCTAssertEqual(vf([x,==100~20])         , "[v1(==100@20)]")
        XCTAssertEqual(vf([x,==y])              , "[v1(==v2)]")
        XCTAssertEqual(vf([x,>=70,<=100])       , "[v1(>=70,<=100)]")
        XCTAssertEqual(vf(|-[x]-[y]-[z,>=20]-|) , "|-[v1]-[v2]-[v3(>=20)]-|")
    }

    func testRelatedViews() {
        let x_ = UIView()
        let y_ = UIView()
        let z_ = UIView()
        let xn = LayoutViewName(view: x_, index: 1)
        let yn = LayoutViewName(view: y_, index: 2)
        let zn = LayoutViewName(view: z_, index: 3)

        visualFormat(x_, y_, z_) { x, y, z in
            XCTAssertEqual(rv(|[x]|)              , [xn])
            XCTAssertEqual(rv(|-[x]|)             , [xn])
            XCTAssertEqual(rv(|[x]-|)             , [xn])
            XCTAssertEqual(rv(|-[x]-|)            , [xn])
            XCTAssertEqual(rv(|-10-[x]-20-|)      , [xn])
            XCTAssertEqual(rv(|-(>=100)-[x]-0-|)  , [xn])
            XCTAssertEqual(rv(|-[x]-(>=99)-|)     , [xn])
            XCTAssertEqual(rv([x,<=y~1000])       , [xn, yn])
            XCTAssertEqual(rv(|-0-[x,==200]-[y]-|), [xn, yn])

            XCTAssertEqual(rv([x]-[y])              , [xn, yn])
            XCTAssertEqual(rv([x,>=50])             , [xn])
            XCTAssertEqual(rv(|-50-[x]-50-|)        , [xn])
            XCTAssertEqual(rv([x]-10-[y])           , [xn, yn])
            XCTAssertEqual(rv([x]-0-[y])            , [xn, yn])
            XCTAssertEqual(rv([x,==100~20])         , [xn])
            XCTAssertEqual(rv([x,==y])              , [xn, yn])
            XCTAssertEqual(rv([x,>=70,<=100])       , [xn])
            XCTAssertEqual(rv(|-[x]-[y]-[z,>=20]-|) , [xn, yn, zn])
        }
    }

    func testOptions() {
        let x : ViewExpression = .View(LayoutViewName(view: UIView(), index: 1))

        XCTAssertEqual(opt(|[x]|)                   , NSLayoutFormatOptions())
        XCTAssertEqual(opt(|[x]| % .AlignAllCenterY), NSLayoutFormatOptions.AlignAllCenterY)
    }

    func testCapture() {
        let par = UIView()
        let v = UIView()
        par.addSubview(v)

        var q1: [AnyObject]?
        visualFormat(v) { v in
            q1 = .H ~ |-[v]
        }
        XCTAssertEqual((q1!).count, 1)

        var q2: [AnyObject]?
        visualFormat(v) { v in
            q2 = .H ~ |-[v]-|
        }
        XCTAssertEqual((q2!).count, 2)
    }
}
