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

public func visualFormat(v1: YAVView,
                         @noescape closure: (ViewExpression) -> ()) {
    v1.translatesAutoresizingMaskIntoConstraints = false

    closure(.View(LayoutViewName(v1, 1)))

    v1.updateConstraints()
}

public func visualFormat(v1: YAVView, _ v2: YAVView,
                         @noescape closure: (ViewExpression, ViewExpression) -> ()) {
    v1.translatesAutoresizingMaskIntoConstraints = false
    v2.translatesAutoresizingMaskIntoConstraints = false

    closure(.View(LayoutViewName(v1, 1)),
            .View(LayoutViewName(v2, 2)))

    v1.updateConstraints()
    v2.updateConstraints()
}

public func visualFormat(v1: YAVView, _ v2: YAVView, _ v3: YAVView,
                         @noescape closure: (ViewExpression, ViewExpression, ViewExpression) -> ()) {
    v1.translatesAutoresizingMaskIntoConstraints = false
    v2.translatesAutoresizingMaskIntoConstraints = false
    v3.translatesAutoresizingMaskIntoConstraints = false

    closure(.View(LayoutViewName(v1, 1)),
            .View(LayoutViewName(v2, 2)),
            .View(LayoutViewName(v3, 3)))

    v1.updateConstraints()
    v2.updateConstraints()
    v3.updateConstraints()
}

public func visualFormat(v1: YAVView, _ v2: YAVView, _ v3: YAVView, _ v4: YAVView,
                         @noescape closure: (ViewExpression, ViewExpression, ViewExpression, ViewExpression) -> ()) {
    v1.translatesAutoresizingMaskIntoConstraints = false
    v2.translatesAutoresizingMaskIntoConstraints = false
    v3.translatesAutoresizingMaskIntoConstraints = false
    v4.translatesAutoresizingMaskIntoConstraints = false

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
                         @noescape closure: (ViewExpression, ViewExpression, ViewExpression, ViewExpression, ViewExpression) -> ()) {
    v1.translatesAutoresizingMaskIntoConstraints = false
    v2.translatesAutoresizingMaskIntoConstraints = false
    v3.translatesAutoresizingMaskIntoConstraints = false
    v4.translatesAutoresizingMaskIntoConstraints = false
    v5.translatesAutoresizingMaskIntoConstraints = false

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

public class LayoutViewName : CustomStringConvertible {
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

public class LayoutPredicate : CustomStringConvertible {
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

public enum LayoutRelation : String, CustomStringConvertible {
    case Equal = "=="
    case GreaterThanOrEqual = ">="
    case LessThanOrEqual = "<="

    public var description: String {
        return rawValue
    }
}

// MARK: <objectOfPredicate>

public enum LayoutObjectOfPredicate : CustomStringConvertible {
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

public enum LayoutOrientation : String, CustomStringConvertible {
    case V = "V"
    case H = "H"

    public var description: String {
        return rawValue
    }
}

// MARK: <view>

public class LayoutView : CustomStringConvertible {
    let view: LayoutViewName
    let predicates: [LayoutPredicate]

    public var description: String {
        let v = view.description
        if predicates.isEmpty {
            return v
        }
        let p = ",".join(predicates.map { $0.description })
        return v + "(" + p + ")"
    }

    var relatedViews: [LayoutViewName] {
        return [view] + predicates.flatMap { e -> [LayoutViewName] in
            if case let .View(v) = e.object {
                return [v]
            } else {
                return []
            }
        }
    }

    public init(_ elements: [ViewExpression]) {
        assert(elements.count > 0)

        let len = elements.count
        let view_part = elements[0]
        let pred_part = elements[1..<len]

        switch view_part {
        case .View(let v):
            self.view = v
        default:
            fatalError("Error")
        }

        self.predicates = pred_part.map { e in
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

public enum VisualFormat : CustomStringConvertible, IntegerLiteralConvertible, ArrayLiteralConvertible {
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
            for case let Options(o) in c {
                return o
            }
        default:
            break
        }
        return NSLayoutFormatOptions()
    }

    var relatedViews: [LayoutViewName] {
        switch self {
        case View(let v):
            return v.relatedViews
        case Composition(let c):
            return c.flatMap { $0.relatedViews }
        default:
            return []
        }
    }

    var viewsDictionary: [String:AnyObject] {
        var d = [String:AnyObject]()
        for v in relatedViews {
            d[v.description] = v.view
        }
        return d
    }

    public init(integerLiteral value: IntegerLiteralType) {
        self = .Number(value)
    }

    public init(arrayLiteral elements: ViewExpression...) {
        self = .View(LayoutView(elements))
    }

    public init(composition elements: VisualFormat...) {
        let t = elements.flatMap { e -> [VisualFormat] in
            switch e {
            case Composition(let c):
                return c
            default:
                return [e]
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
    return createViewExpressionPredicate(view, relation: .Equal)
}


prefix operator <= {}

public prefix func <=(n: Int) -> ViewExpression {
    return .Predicate(LayoutPredicate(relation: .LessThanOrEqual, object: .Constant(n)))
}

public prefix func <=(view: ViewExpression) -> ViewExpression {
    return createViewExpressionPredicate(view, relation: .LessThanOrEqual)
}


prefix operator >= {}

public prefix func >=(n: Int) -> ViewExpression {
    return .Predicate(LayoutPredicate(relation: .GreaterThanOrEqual, object: .Constant(n)))
}

public prefix func >=(view: ViewExpression) -> ViewExpression {
    return createViewExpressionPredicate(view, relation: .GreaterThanOrEqual)
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
    let exp = lhs.description + ":" + rhs.description
    let dic = rhs.viewsDictionary
    let opts = rhs.options
    //println("\(exp)")

    let c = NSLayoutConstraint.constraintsWithVisualFormat(exp, options: opts, metrics: nil, views: dic)
    NSLayoutConstraint.activateConstraints(c)
    return c
}
