//
//  yavfl.swift
//
//  yavfl : Yet Another Visual Format Language for Auto layout
//
//  Created by Safx Developer on 2014/12/08.
//  Copyright (c) 2014 Safx Developers. All rights reserved.
//


import Foundation

#if os(iOS)
    import UIKit
    public typealias YAVView = UIView
#else
    import AppKit
    public typealias YAVView = NSView
#endif

extension YAVView {
    private func yav_setTranslatesAutoresizingMaskIntoConstraints(flag: Bool) {
        #if os(iOS)
            setTranslatesAutoresizingMaskIntoConstraints(flag)
        #else
            translatesAutoresizingMaskIntoConstraints = flag
        #endif
    }
}


public func visualFormat(v1: YAVView,
                         closure: (ViewExpression) -> ()) {
    v1.yav_setTranslatesAutoresizingMaskIntoConstraints(false)

    closure(.View(LayoutViewName(v1, 1)))

    v1.updateConstraints()
}

public func visualFormat(v1: YAVView, v2: YAVView,
                         closure: (ViewExpression, ViewExpression) -> ()) {
    v1.yav_setTranslatesAutoresizingMaskIntoConstraints(false)
    v2.yav_setTranslatesAutoresizingMaskIntoConstraints(false)

    closure(.View(LayoutViewName(v1, 1)),
            .View(LayoutViewName(v2, 2)))

    v1.updateConstraints()
    v2.updateConstraints()
}

public func visualFormat(v1: YAVView, v2: YAVView, v3: YAVView,
                         closure: (ViewExpression, ViewExpression, ViewExpression) -> ()) {
    v1.yav_setTranslatesAutoresizingMaskIntoConstraints(false)
    v2.yav_setTranslatesAutoresizingMaskIntoConstraints(false)
    v3.yav_setTranslatesAutoresizingMaskIntoConstraints(false)

    closure(.View(LayoutViewName(v1, 1)),
            .View(LayoutViewName(v2, 2)),
            .View(LayoutViewName(v3, 3)))

    v1.updateConstraints()
    v2.updateConstraints()
    v3.updateConstraints()
}

public func visualFormat(v1: YAVView, v2: YAVView, v3: YAVView, v4: YAVView,
                         closure: (ViewExpression, ViewExpression, ViewExpression, ViewExpression) -> ()) {
    v1.yav_setTranslatesAutoresizingMaskIntoConstraints(false)
    v2.yav_setTranslatesAutoresizingMaskIntoConstraints(false)
    v3.yav_setTranslatesAutoresizingMaskIntoConstraints(false)
    v4.yav_setTranslatesAutoresizingMaskIntoConstraints(false)

    closure(.View(LayoutViewName(v1, 1)),
            .View(LayoutViewName(v2, 2)),
            .View(LayoutViewName(v3, 3)),
            .View(LayoutViewName(v4, 4)))

    v1.updateConstraints()
    v2.updateConstraints()
    v3.updateConstraints()
    v4.updateConstraints()
}

public func visualFormat(v1: YAVView, v2: YAVView, v3: YAVView, v4: YAVView, v5: YAVView,
                         closure: (ViewExpression, ViewExpression, ViewExpression, ViewExpression, ViewExpression) -> ()) {
    v1.yav_setTranslatesAutoresizingMaskIntoConstraints(false)
    v2.yav_setTranslatesAutoresizingMaskIntoConstraints(false)
    v3.yav_setTranslatesAutoresizingMaskIntoConstraints(false)
    v4.yav_setTranslatesAutoresizingMaskIntoConstraints(false)
    v5.yav_setTranslatesAutoresizingMaskIntoConstraints(false)

    closure(.View(LayoutViewName(v1, 1)),
            .View(LayoutViewName(v2, 2)),
            .View(LayoutViewName(v3, 3)),
            .View(LayoutViewName(v4, 4)),
            .View(LayoutViewName(v5, 5)))

    v1.updateConstraints()
    v2.updateConstraints()
    v3.updateConstraints()
    v4.updateConstraints()
    v5.updateConstraints()
}

// MARK:

public enum ViewExpression {
    case View(LayoutViewName)
    case Predicate(LayoutPredicate)
}

// MARK: <viewName>

public class LayoutViewName : Printable {
    let view: YAVView
    let index: Int

    public var description: String {
        return "v\(index)"
    }

    init(_ view: YAVView, _ index: Int) {
        self.view = view
        self.index = index
    }
}

// MARK: <predicate>

public class LayoutPredicate : Printable {
    let relation: LayoutRelation
    let object: LayoutObjectOfPredicate
    let priority: Int?

    public init(relation: LayoutRelation, object: LayoutObjectOfPredicate, priority: Int? = nil) {
        self.relation = relation
        self.object = object
        self.priority = priority
    }

    public var description: String {
        let d = relation.description + object.description
        if let p = priority {
            return d + "@\(p)"
        }
        return d
    }
}

// MARK: <relation>

public enum LayoutRelation : String, Printable {
    case Equal = "=="
    case GreaterThanOrEqual = ">="
    case LessThanOrEqual = "<="

    public var description: String {
        return rawValue
    }
}

// MARK: <objectOfPredicate>

public enum LayoutObjectOfPredicate : Printable {
    case Constant(Int)
    case View(LayoutViewName)

    public var description: String {
        switch self {
        case Constant(let n): return "\(n)"
        case View(let view): return view.description
        }
    }
}

// MARK: <orientation>

public enum LayoutOrientation : String, Printable {
    case V = "V"
    case H = "H"

    public var description: String {
        return rawValue
    }
}

// MARK: <view>

public class LayoutView : Printable {
    let view: LayoutViewName
    let predicates: [LayoutPredicate]

    public var description: String {
        let v = view.description
        if count(predicates) == 0 {
            return v
        }
        let p = ",".join(predicates.map { $0.description })
        return v + "(" + p + ")"
    }

    var relatedViews: [LayoutViewName] {
        var v = [view]
        for i in predicates {
            switch i.object {
            case .View(let view):
                v.append(view)
            default:
                break
            }
        }
        return v
    }

    public init(_ elements: [ViewExpression]) {
        assert(count(elements) > 0)

        let len = count(elements)
        let view_part = elements[0]
        let pred_part = elements[1..<len]

        switch view_part {
        case .View(let v):
            self.view = v
        default:
            fatalError("Error")
        }

        self.predicates = map(pred_part) { e in
            switch e {
            case .Predicate(let p):
                return p
            default:
                fatalError("Error")
            }
        }
    }
}

// MARK: <visualFormatString>

public enum VisualFormat : Printable, IntegerLiteralConvertible, ArrayLiteralConvertible {
    case Superview
    case View(LayoutView)
    case Connection
    case Predicate(LayoutPredicate)
    case Number(Int)
    case Composition([VisualFormat])
    case Options(NSLayoutFormatOptions)

    public var description: String {
        switch self {
        case Superview:          return "|"
        case View(let v):        return "[" + v.description + "]"
        case Connection:         return "-"
        case Predicate(let p):   return "(" + p.description + ")"
        case Number(let n):      return "\(n)"
        case Composition(let c): return "".join(c.map { $0.description })
        case Options:            return ""
        }
    }

    // FIXME: report error for multiple options
    var options: NSLayoutFormatOptions {
        switch self {
        case Options(let opts): return opts
        case Composition(let c):
            for i in c {
                switch i {
                case Options(let opts): return opts
                default: continue
                }
            }
        default:
            break
        }
        return NSLayoutFormatOptions()
    }

    var relatedViews: [LayoutViewName] {
        var d = [LayoutViewName]()
        switch self {
        case View(let v):
            for i in v.relatedViews {
                d.append(i)
            }
        case Composition(let c):
            for i in c {
                for j in i.relatedViews {
                    d.append(j)
                }
            }
        default:
            break;
        }
        return d
    }

    var viewsDictionary: [NSObject:AnyObject] {
        var d = [NSObject:AnyObject]()
        for v in relatedViews {
            d[v.description] = v.view
        }
        return d
    }

    var superView: YAVView? {
        var s = [YAVView]()
        for v in relatedViews {
            if let sv = v.view.superview {
                s.append(sv)
            }
        }
        if count(s) > 0 {
            return s[0] // FIXME
        }
        return nil
    }

    public init(integerLiteral value: IntegerLiteralType) {
        self = .Number(value)
    }

    public init(arrayLiteral elements: ViewExpression...) {
        self = .View(LayoutView(elements))
    }

    public init(composition elements: VisualFormat...) {
        var t = [VisualFormat]()
        for elem in elements {
            switch elem {
            case Composition(let c):
                for i in c { t.append(i) }
            default:
                t.append(elem)
            }
        }
        self = .Composition(t)
    }
}

// MARK: helper funcs

private func createVisualFormatPredicate(view: ViewExpression, priority: Int? = nil) -> VisualFormat {
    switch view {
    case .Predicate(let p):
        return .Predicate(LayoutPredicate(relation: p.relation, object: p.object, priority: priority))
    default:
        fatalError("Error")
    }
}

private func createViewExpressionPredicate(view: ViewExpression, relation: LayoutRelation) -> ViewExpression {
    switch view {
    case .View(let v):
        return .Predicate(LayoutPredicate(relation: relation, object: .View(v)))
    default:
        fatalError("Error")
    }
}

// MARK: - operators

prefix operator | {}

public prefix func |(e: VisualFormat) -> VisualFormat {
    return VisualFormat(composition: .Superview, e)
}


postfix operator | {}

public postfix func |(e: VisualFormat) -> VisualFormat {
    return VisualFormat(composition: e, .Superview)
}


prefix operator |- {}

public prefix func |-(e: VisualFormat) -> VisualFormat {
    return VisualFormat(composition: .Superview, .Connection, e)
}

public prefix func |-(e: (ViewExpression)) -> VisualFormat {
    return VisualFormat(composition: .Superview, .Connection, createVisualFormatPredicate(e.0))
}


postfix operator -| {}

public postfix func -|(e: VisualFormat) -> VisualFormat {
    return VisualFormat(composition: e, .Connection, .Superview)
}

public postfix func -|(e: (ViewExpression)) -> VisualFormat {
    return VisualFormat(composition: createVisualFormatPredicate(e.0), .Connection, .Superview)
}


//infix operator - {}

public func -(lhs: VisualFormat, rhs: VisualFormat) -> VisualFormat {
    return VisualFormat(composition: lhs, .Connection, rhs)
}

public func -(lhs: VisualFormat, rhs: (ViewExpression)) -> VisualFormat {
    return VisualFormat(composition: lhs, .Connection, createVisualFormatPredicate(rhs.0))
}


prefix operator == {}

public prefix func ==(n: Int) -> ViewExpression {
    return .Predicate(LayoutPredicate(relation: .Equal, object: .Constant(n)))
}

public prefix func ==(view: ViewExpression) -> ViewExpression {
    return createViewExpressionPredicate(view, .Equal)
}


prefix operator <= {}

public prefix func <=(n: Int) -> ViewExpression {
    return .Predicate(LayoutPredicate(relation: .LessThanOrEqual, object: .Constant(n)))
}

public prefix func <=(view: ViewExpression) -> ViewExpression {
    return createViewExpressionPredicate(view, .LessThanOrEqual)
}


prefix operator >= {}

public prefix func >=(n: Int) -> ViewExpression {
    return .Predicate(LayoutPredicate(relation: .GreaterThanOrEqual, object: .Constant(n)))
}

public prefix func >=(view: ViewExpression) -> ViewExpression {
    return createViewExpressionPredicate(view, .GreaterThanOrEqual)
}


//infix operator % {}

public func %(lhs: VisualFormat, rhs: NSLayoutFormatOptions) -> VisualFormat {
    return VisualFormat(composition: lhs, .Options(rhs))
}


infix operator ~ {}

public func ~(lhs: ViewExpression, rhs: Int) -> ViewExpression {
    switch lhs {
    case .Predicate(let p):
        return .Predicate(LayoutPredicate(relation: p.relation, object: p.object, priority: rhs))
    default:
        fatalError("Error")
    }
}

public func ~(lhs: LayoutOrientation, rhs: VisualFormat) -> [AnyObject] {
    if let superView = rhs.superView {
        let exp = lhs.description + ":" + rhs.description
        let dic = rhs.viewsDictionary
        let opts = rhs.options
        //println("\(exp)")
        let c = NSLayoutConstraint.constraintsWithVisualFormat(exp, options: opts, metrics: nil, views: dic)
        superView.addConstraints(c)
        return c
    }
    return []
}
