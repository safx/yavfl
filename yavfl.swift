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

    closure(.View(LayoutViewName(view: v1, index: 1)))

    v1.updateConstraints()
}

public func visualFormat(v1: YAVView, _ v2: YAVView,
                         @noescape closure: (ViewExpression, ViewExpression) -> ()) {
    v1.translatesAutoresizingMaskIntoConstraints = false
    v2.translatesAutoresizingMaskIntoConstraints = false

    closure(.View(LayoutViewName(view: v1, index: 1)),
            .View(LayoutViewName(view: v2, index: 2)))

    v1.updateConstraints()
    v2.updateConstraints()
}

public func visualFormat(v1: YAVView, _ v2: YAVView, _ v3: YAVView,
                         @noescape closure: (ViewExpression, ViewExpression, ViewExpression) -> ()) {
    v1.translatesAutoresizingMaskIntoConstraints = false
    v2.translatesAutoresizingMaskIntoConstraints = false
    v3.translatesAutoresizingMaskIntoConstraints = false

    closure(.View(LayoutViewName(view: v1, index: 1)),
            .View(LayoutViewName(view: v2, index: 2)),
            .View(LayoutViewName(view: v3, index: 3)))

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

    closure(.View(LayoutViewName(view: v1, index: 1)),
            .View(LayoutViewName(view: v2, index: 2)),
            .View(LayoutViewName(view: v3, index: 3)),
            .View(LayoutViewName(view: v4, index: 4)))

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

    closure(.View(LayoutViewName(view: v1, index: 1)),
            .View(LayoutViewName(view: v2, index: 2)),
            .View(LayoutViewName(view: v3, index: 3)),
            .View(LayoutViewName(view: v4, index: 4)),
            .View(LayoutViewName(view: v5, index: 5)))

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

public struct LayoutViewName : CustomStringConvertible {
    internal let view: YAVView
    internal let index: Int

    public var description: String {
        return "v" + String(index)
    }
}

// MARK: <predicate>

public struct LayoutPredicate : CustomStringConvertible {
    private let relation: LayoutRelation
    private let object: LayoutObjectOfPredicate
    private let priority: Int?

    public var description: String {
        let d = relation.rawValue + object.description
        guard let p = priority else { return d }
        return d + "@" + String(p)
    }
}

// MARK: <relation>

public enum LayoutRelation : String {
    case Equal              = "=="
    case GreaterThanOrEqual = ">="
    case LessThanOrEqual    = "<="
}

// MARK: <objectOfPredicate>

public enum LayoutObjectOfPredicate : CustomStringConvertible {
    case Constant(Int)
    case View(LayoutViewName)

    public var description: String {
        switch self {
        case Constant(let n): return String(n)
        case View(let view):  return view.description
        }
    }
}

// MARK: <orientation>

public enum LayoutOrientation : String {
    case V
    case H
}

// MARK: <view>

public struct LayoutView : CustomStringConvertible {
    private let view: LayoutViewName
    private let predicates: [LayoutPredicate]

    public var description: String {
        let v = view.description
        if predicates.isEmpty { return v }
        return v + "(" + predicates.map { $0.description } .joinWithSeparator(",") + ")"
    }

    private var relatedViews: [LayoutViewName] {
        return [view] + predicates.flatMap { e -> LayoutViewName? in
            switch e.object {
            case .View(let v): return v
            default:           return nil
            }
        }
    }

    internal init(_ elements: [ViewExpression]) {
        assert(elements.count > 0)

        let len = elements.count
        let view_part = elements[0]
        let pred_part = elements[1..<len]

        guard case let .View(v) = view_part else { fatalError("Error") }
        view = v

        predicates = pred_part.map { e in
            if case let .Predicate(p) = e { return p }
            fatalError("Error")
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
        case Number(let n):      return String(n)
        case Composition(let c): return c.map { $0.description } .joinWithSeparator("")
        case Options:            return ""
        }
    }

    // FIXME: report error for multiple options
    internal var options: NSLayoutFormatOptions {
        switch self {
        case Options(let opts): return opts
        case Composition(let c):
            for case let Options(o) in c { return o }
        default: ()
        }
        return NSLayoutFormatOptions()
    }

    internal var relatedViews: [LayoutViewName] {
        switch self {
        case View(let v):        return v.relatedViews
        case Composition(let c): return c.flatMap { $0.relatedViews }
        default:                 return []
        }
    }

    private var viewsDictionary: [String:AnyObject] {
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

    internal init(composition elements: VisualFormat...) {
        let t = elements.flatMap { e -> [VisualFormat] in
            switch e {
            case Composition(let c): return c
            default:                 return [e]
            }
        }
        self = .Composition(t)
    }
}

// MARK: helper funcs

private func createVisualFormatPredicate(view: ViewExpression, priority: Int? = nil) -> VisualFormat {
    if case let .Predicate(p) = view {
        return .Predicate(LayoutPredicate(relation: p.relation, object: p.object, priority: priority))
    }
    fatalError("Error")
}

private func createViewExpressionPredicate(view: ViewExpression, relation: LayoutRelation) -> ViewExpression {
    if case let .View(v) = view {
        return .Predicate(LayoutPredicate(relation: relation, object: .View(v), priority: nil))
    }
    fatalError("Error")
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
    return VisualFormat(composition: .Superview, .Connection, createVisualFormatPredicate(e))
}


postfix operator -| {}

public postfix func -|(e: VisualFormat) -> VisualFormat {
    return VisualFormat(composition: e, .Connection, .Superview)
}

public postfix func -|(e: (ViewExpression)) -> VisualFormat {
    return VisualFormat(composition: createVisualFormatPredicate(e), .Connection, .Superview)
}


//infix operator - {}

public func -(lhs: VisualFormat, rhs: VisualFormat) -> VisualFormat {
    return VisualFormat(composition: lhs, .Connection, rhs)
}

public func -(lhs: VisualFormat, rhs: (ViewExpression)) -> VisualFormat {
    return VisualFormat(composition: lhs, .Connection, createVisualFormatPredicate(rhs))
}


prefix operator == {}

public prefix func ==(n: Int) -> ViewExpression {
    return .Predicate(LayoutPredicate(relation: .Equal, object: .Constant(n), priority: nil))
}

public prefix func ==(view: ViewExpression) -> ViewExpression {
    return createViewExpressionPredicate(view, relation: .Equal)
}


prefix operator <= {}

public prefix func <=(n: Int) -> ViewExpression {
    return .Predicate(LayoutPredicate(relation: .LessThanOrEqual, object: .Constant(n), priority: nil))
}

public prefix func <=(view: ViewExpression) -> ViewExpression {
    return createViewExpressionPredicate(view, relation: .LessThanOrEqual)
}


prefix operator >= {}

public prefix func >=(n: Int) -> ViewExpression {
    return .Predicate(LayoutPredicate(relation: .GreaterThanOrEqual, object: .Constant(n), priority: nil))
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
    if case let .Predicate(p) = lhs {
        return .Predicate(LayoutPredicate(relation: p.relation, object: p.object, priority: rhs))
    }
    fatalError("Error")
}

public func ~(lhs: LayoutOrientation, rhs: VisualFormat) -> [AnyObject] {
    let exp = lhs.rawValue + ":" + rhs.description
    let c = NSLayoutConstraint.constraintsWithVisualFormat(exp, options: rhs.options, metrics: nil, views: rhs.viewsDictionary)
    NSLayoutConstraint.activateConstraints(c)
    return c
}
