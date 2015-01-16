//
//  yavfl.swift
//
//  yavfl : Yet Another Visual Format Language for Auto layout
//
//  Created by Safx Developer on 2014/12/08.
//  Copyright (c) 2014 Safx Developers. All rights reserved.
//

import UIKit


public func visualFormat(v1: UIView,
                         block: (ViewExpression) -> ()) {
    v1.setTranslatesAutoresizingMaskIntoConstraints(false)

    block(.View(LayoutViewName(v1, 1)))

    v1.updateConstraints()
}

public func visualFormat(v1: UIView, v2: UIView,
                         block: (ViewExpression, ViewExpression) -> ()) {
    v1.setTranslatesAutoresizingMaskIntoConstraints(false)
    v2.setTranslatesAutoresizingMaskIntoConstraints(false)

    block(.View(LayoutViewName(v1, 1)),
          .View(LayoutViewName(v2, 2)))

    v1.updateConstraints()
    v2.updateConstraints()
}

public func visualFormat(v1: UIView, v2: UIView, v3: UIView,
                         block: (ViewExpression, ViewExpression, ViewExpression) -> ()) {
    v1.setTranslatesAutoresizingMaskIntoConstraints(false)
    v2.setTranslatesAutoresizingMaskIntoConstraints(false)
    v3.setTranslatesAutoresizingMaskIntoConstraints(false)

    block(.View(LayoutViewName(v1, 1)),
          .View(LayoutViewName(v2, 2)),
          .View(LayoutViewName(v3, 3)))

    v1.updateConstraints()
    v2.updateConstraints()
    v3.updateConstraints()
}

public func visualFormat(v1: UIView, v2: UIView, v3: UIView, v4: UIView,
                         block: (ViewExpression, ViewExpression, ViewExpression, ViewExpression) -> ()) {
    v1.setTranslatesAutoresizingMaskIntoConstraints(false)
    v2.setTranslatesAutoresizingMaskIntoConstraints(false)
    v3.setTranslatesAutoresizingMaskIntoConstraints(false)
    v4.setTranslatesAutoresizingMaskIntoConstraints(false)

    block(.View(LayoutViewName(v1, 1)),
          .View(LayoutViewName(v2, 2)),
          .View(LayoutViewName(v3, 3)),
          .View(LayoutViewName(v4, 4)))

    v1.updateConstraints()
    v2.updateConstraints()
    v3.updateConstraints()
    v4.updateConstraints()
}

public func visualFormat(v1: UIView, v2: UIView, v3: UIView, v4: UIView, v5: UIView,
                         block: (ViewExpression, ViewExpression, ViewExpression, ViewExpression, ViewExpression) -> ()) {
    v1.setTranslatesAutoresizingMaskIntoConstraints(false)
    v2.setTranslatesAutoresizingMaskIntoConstraints(false)
    v3.setTranslatesAutoresizingMaskIntoConstraints(false)
    v4.setTranslatesAutoresizingMaskIntoConstraints(false)
    v5.setTranslatesAutoresizingMaskIntoConstraints(false)

    block(.View(LayoutViewName(v1, 1)),
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
    let view: UIView
    let index: Int

    public var description: String {
        return "v\(index)"
    }

    init(_ view: UIView, _ index: Int) {
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
        return self.rawValue
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
        return self.rawValue
    }
}

// MARK: <view>

public class LayoutView : Printable {
    let view: LayoutViewName
    let predicates: [LayoutPredicate]

    public var description: String {
        let v = view.description
        if countElements(predicates) == 0 {
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
        assert(countElements(elements) > 0)
        switch elements[0] {
        case .View(let v):
            self.view = v
        case .Predicate:
            fatalError("Error")
        }

        var preds = [LayoutPredicate]()
        var i = 0
        for e in elements {
            ++i
            if i == 1 { continue }
            switch e {
            case .View(let v):
                fatalError("Error")
            case .Predicate(let p):
                preds.append(p)
            }
        }
        self.predicates = preds
    }
}

// MARK: <visualFormatString>

public enum VisualFormat : Printable, IntegerLiteralConvertible, ArrayLiteralConvertible {
    case Orientation(LayoutOrientation)
    case Superview
    case View(LayoutView)
    case Connection
    case Predicate(LayoutPredicate)
    case Number(Int)
    case Composition([VisualFormat])
    case Options(NSLayoutFormatOptions)
    
    public var description: String {
        switch self {
        case Orientation(let o): return o.description
        case Superview:          return "|"
        case View(let v):        return "[" + v.description + "]"
        case Connection:         return "-"
        case Predicate(let p):   return "(" + p.description + ")"
        case Number(let n):      return "\(n)"
        case Composition(let c): return "".join(c.map { $0.description })
        case Options:            return ""
        }
    }
    
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
            break;
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

    var superView: UIView? {
        var s = [UIView]()
        for v in relatedViews {
            if let sv = v.view.superview {
                s.append(sv)
            }
        }
        if countElements(s) > 0 {
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

public func ~(lhs: LayoutOrientation, rhs: VisualFormat) -> () {
    if let superView = rhs.superView? {
        let exp = lhs.description + ":" + rhs.description
        let dic = rhs.viewsDictionary
        let opts = rhs.options
        //println("\(exp)")
        let c = NSLayoutConstraint.constraintsWithVisualFormat(exp, options: opts, metrics: nil, views: dic)
        superView.addConstraints(c)
    }
    return ()
}
