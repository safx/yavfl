//
//  yavfl.swift
//
//  yavfl : Yet Another Visual Format Language for Auto layout
//
//  Created by Safx Developer on 2014/12/08.
//  Copyright (c) 2014 Safx Developers. All rights reserved.
//


import Foundation

#if os(iOS) || os(tvOS)
    import UIKit
    public typealias YAVView = UIView
    public typealias LayoutFormatOptions = NSLayoutFormatOptions
#else
    import AppKit
    public typealias YAVView = NSView
    public typealias LayoutFormatOptions = NSLayoutConstraint.FormatOptions
#endif

public func visualFormat(_ v1: YAVView,
                         closure: (ViewExpression) -> ()) {
    v1.translatesAutoresizingMaskIntoConstraints = false

    closure(.view(LayoutViewName(view: v1, index: 1)))

    v1.updateConstraints()
}

public func visualFormat(_ v1: YAVView, _ v2: YAVView,
                         closure: (ViewExpression, ViewExpression) -> ()) {
    v1.translatesAutoresizingMaskIntoConstraints = false
    v2.translatesAutoresizingMaskIntoConstraints = false

    closure(.view(LayoutViewName(view: v1, index: 1)),
            .view(LayoutViewName(view: v2, index: 2)))

    v1.updateConstraints()
    v2.updateConstraints()
}

public func visualFormat(_ v1: YAVView, _ v2: YAVView, _ v3: YAVView,
                         closure: (ViewExpression, ViewExpression, ViewExpression) -> ()) {
    v1.translatesAutoresizingMaskIntoConstraints = false
    v2.translatesAutoresizingMaskIntoConstraints = false
    v3.translatesAutoresizingMaskIntoConstraints = false

    closure(.view(LayoutViewName(view: v1, index: 1)),
            .view(LayoutViewName(view: v2, index: 2)),
            .view(LayoutViewName(view: v3, index: 3)))

    v1.updateConstraints()
    v2.updateConstraints()
    v3.updateConstraints()
}

public func visualFormat(_ v1: YAVView, _ v2: YAVView, _ v3: YAVView, _ v4: YAVView,
                         closure: (ViewExpression, ViewExpression, ViewExpression, ViewExpression) -> ()) {
    v1.translatesAutoresizingMaskIntoConstraints = false
    v2.translatesAutoresizingMaskIntoConstraints = false
    v3.translatesAutoresizingMaskIntoConstraints = false
    v4.translatesAutoresizingMaskIntoConstraints = false

    closure(.view(LayoutViewName(view: v1, index: 1)),
            .view(LayoutViewName(view: v2, index: 2)),
            .view(LayoutViewName(view: v3, index: 3)),
            .view(LayoutViewName(view: v4, index: 4)))

    v1.updateConstraints()
    v2.updateConstraints()
    v3.updateConstraints()
    v4.updateConstraints()
}

public func visualFormat(_ v1: YAVView, _ v2: YAVView, _ v3: YAVView, _ v4: YAVView, _ v5: YAVView,
                         closure: (ViewExpression, ViewExpression, ViewExpression, ViewExpression, ViewExpression) -> ()) {
    v1.translatesAutoresizingMaskIntoConstraints = false
    v2.translatesAutoresizingMaskIntoConstraints = false
    v3.translatesAutoresizingMaskIntoConstraints = false
    v4.translatesAutoresizingMaskIntoConstraints = false
    v5.translatesAutoresizingMaskIntoConstraints = false

    closure(.view(LayoutViewName(view: v1, index: 1)),
            .view(LayoutViewName(view: v2, index: 2)),
            .view(LayoutViewName(view: v3, index: 3)),
            .view(LayoutViewName(view: v4, index: 4)),
            .view(LayoutViewName(view: v5, index: 5)))

    v1.updateConstraints()
    v2.updateConstraints()
    v3.updateConstraints()
    v4.updateConstraints()
    v5.updateConstraints()
}

// MARK:

public enum ViewExpression {
    case view(LayoutViewName)
    case predicate(LayoutPredicate)
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
    fileprivate let relation: LayoutRelation
    fileprivate let object: LayoutObjectOfPredicate
    fileprivate let priority: Int?

    public var description: String {
        let d = relation.rawValue + object.description
        guard let p = priority else { return d }
        return d + "@" + String(p)
    }
}

// MARK: <relation>

public enum LayoutRelation : String {
    case equal              = "=="
    case greaterThanOrEqual = ">="
    case lessThanOrEqual    = "<="
}

// MARK: <objectOfPredicate>

public enum LayoutObjectOfPredicate : CustomStringConvertible {
    case constant(Int)
    case view(LayoutViewName)

    public var description: String {
        switch self {
        case .constant(let n): return String(n)
        case .view(let view):  return view.description
        }
    }
}

// MARK: <orientation>

public enum LayoutOrientation : String {
    case v = "V"
    case h = "H"
}

// MARK: <view>

public struct LayoutView : CustomStringConvertible {
    fileprivate let view: LayoutViewName
    fileprivate let predicates: [LayoutPredicate]

    public var description: String {
        let v = view.description
        if predicates.isEmpty { return v }
        return v + "(" + predicates.map { $0.description } .joined(separator: ",") + ")"
    }

    internal var relatedViews: [LayoutViewName] {
        return [view] + predicates.flatMap { e -> LayoutViewName? in
            switch e.object {
            case .view(let v): return v
            default:           return nil
            }
        }
    }

    fileprivate init(_ elements: [ViewExpression]) {
        guard let view_part = elements.first, case let .view(v) = view_part else {
            fatalError("View expected")
        }
        view = v

        let pred_part = elements.dropFirst()
        predicates = pred_part.map { e in
            if case let .predicate(p) = e { return p }
            fatalError("Predicate expected")
        }
    }
}

// MARK: <visualFormatString>

public enum VisualFormat : CustomStringConvertible, ExpressibleByIntegerLiteral, ExpressibleByArrayLiteral {
    case superview
    case view(LayoutView)
    case connection
    case predicate(LayoutPredicate)
    case number(Int)
    case composition([VisualFormat])
    case options(LayoutFormatOptions)

    public var description: String {
        switch self {
        case .superview:          return "|"
        case .view(let v):        return "[" + v.description + "]"
        case .connection:         return "-"
        case .predicate(let p):   return "(" + p.description + ")"
        case .number(let n):      return String(n)
        case .composition(let c): return c.map { $0.description } .joined(separator: "")
        case .options:            return ""
        }
    }

    // FIXME: report error for multiple options
    internal var options: LayoutFormatOptions {
        switch self {
        case .options(let opts): return opts
        case .composition(let c):
            for case let .options(o) in c { return o }
        default: ()
        }
        return LayoutFormatOptions()
    }

    internal var relatedViews: [LayoutViewName] {
        switch self {
        case .view(let v):        return v.relatedViews
        case .composition(let c): return c.flatMap { $0.relatedViews }
        default:                 return []
        }
    }

    internal var viewsDictionary: [String:AnyObject] {
        var d = [String:AnyObject]()
        relatedViews.forEach { d[$0.description] = $0.view }
        return d
    }

    public init(integerLiteral value: IntegerLiteralType) {
        self = .number(value)
    }

    public init(arrayLiteral elements: ViewExpression...) {
        self = .view(LayoutView(elements))
    }

    fileprivate init(composition elements: VisualFormat...) {
        let t = elements.flatMap { e -> [VisualFormat] in
            switch e {
            case .composition(let c): return c
            default:                 return [e]
            }
        }
        self = .composition(t)
    }
}

// MARK: helper funcs

private func createVisualFormatPredicate(view: ViewExpression, priority: Int? = nil) -> VisualFormat {
    if case let .predicate(p) = view {
        return .predicate(LayoutPredicate(relation: p.relation, object: p.object, priority: priority))
    }
    fatalError("Error")
}

private func createViewExpressionPredicate(view: ViewExpression, relation: LayoutRelation) -> ViewExpression {
    if case let .view(v) = view {
        return .predicate(LayoutPredicate(relation: relation, object: .view(v), priority: nil))
    }
    fatalError("Error")
}

// MARK: - operators

prefix operator |

public prefix func |(e: VisualFormat) -> VisualFormat {
    return VisualFormat(composition: .superview, e)
}


postfix operator |

public postfix func |(e: VisualFormat) -> VisualFormat {
    return VisualFormat(composition: e, .superview)
}


prefix operator |-

public prefix func |-(e: VisualFormat) -> VisualFormat {
    return VisualFormat(composition: .superview, .connection, e)
}

public prefix func |-(e: (ViewExpression)) -> VisualFormat {
    return VisualFormat(composition: .superview, .connection, createVisualFormatPredicate(view: e))
}


postfix operator -|

public postfix func -|(e: VisualFormat) -> VisualFormat {
    return VisualFormat(composition: e, .connection, .superview)
}

public postfix func -|(e: (ViewExpression)) -> VisualFormat {
    return VisualFormat(composition: createVisualFormatPredicate(view: e), .connection, .superview)
}

//infix operator -: AdditionPrecedence

public func -(lhs: VisualFormat, rhs: VisualFormat) -> VisualFormat {
    return VisualFormat(composition: lhs, .connection, rhs)
}

public func -(lhs: VisualFormat, rhs: (ViewExpression)) -> VisualFormat {
    return VisualFormat(composition: lhs, .connection, createVisualFormatPredicate(view: rhs))
}


prefix operator ==

public prefix func ==(n: Int) -> ViewExpression {
    return .predicate(LayoutPredicate(relation: .equal, object: .constant(n), priority: nil))
}

public prefix func ==(view: ViewExpression) -> ViewExpression {
    return createViewExpressionPredicate(view: view, relation: .equal)
}


prefix operator <=

public prefix func <=(n: Int) -> ViewExpression {
    return .predicate(LayoutPredicate(relation: .lessThanOrEqual, object: .constant(n), priority: nil))
}

public prefix func <=(view: ViewExpression) -> ViewExpression {
    return createViewExpressionPredicate(view: view, relation: .lessThanOrEqual)
}


prefix operator >=

public prefix func >=(n: Int) -> ViewExpression {
    return .predicate(LayoutPredicate(relation: .greaterThanOrEqual, object: .constant(n), priority: nil))
}

public prefix func >=(view: ViewExpression) -> ViewExpression {
    return createViewExpressionPredicate(view: view, relation: .greaterThanOrEqual)
}


//infix operator % {}

public func %(lhs: VisualFormat, rhs: LayoutFormatOptions) -> VisualFormat {
    return VisualFormat(composition: lhs, .options(rhs))
}


infix operator ~: AssignmentPrecedence

@discardableResult
public func ~(lhs: ViewExpression, rhs: Int) -> ViewExpression {
    if case let .predicate(p) = lhs {
        return .predicate(LayoutPredicate(relation: p.relation, object: p.object, priority: rhs))
    }
    fatalError("Error")
}

@discardableResult
public func ~(lhs: LayoutOrientation, rhs: VisualFormat) -> [AnyObject] {
    let exp = lhs.rawValue + ":" + rhs.description
    let c = NSLayoutConstraint.constraints(withVisualFormat: exp, options: rhs.options, metrics: nil, views: rhs.viewsDictionary)
    NSLayoutConstraint.activate(c)
    return c
}
