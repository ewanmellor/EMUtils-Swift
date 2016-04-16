//
//  Reflection.swift
//  EMUtils
//
//  Created by Ewan Mellor on 4/15/16.
//  Copyright © 2016 Ewan Mellor. All rights reserved.
//

import Foundation


enum ReflectionMatch {
    case DoNotCare
    case RequireNo
    case RequireYes
}


/**
 - parameter predicate: A predicate that is applied to the attribute
   declaration string of each property (c.f. `property_getAttributes`).
   Return true to include the property in the result.
 - returns: The names of each property in the full class heirarchy that
   match the given predicate.
 */
func reflectionGetPropertyNames(cls: AnyClass, predicate: (String -> Bool)?) -> [String] {
    var result = [String]()
    reflectionGetPropertyNames_(cls, &result, predicate)
    return result
}

private func reflectionGetPropertyNames_(cls: AnyClass, inout _ result: [String], _ predicate: (String -> Bool)?) {
    reflectionGetPropertyNamesSingle(cls, &result, predicate);

    if let superclass = class_getSuperclass(cls) where superclass != NSObject.self {
        reflectionGetPropertyNames_(superclass, &result, predicate);
    }
}


private func reflectionGetPropertyNamesSingle(cls: AnyClass, inout _ result: [String], _ predicate: (String -> Bool)?) {
    var outCount: CUnsignedInt = 0
    var properties = class_copyPropertyList(cls, &outCount)
    for _ in [0 ..< Int(outCount)] {
        let property = properties.memory
        properties = properties.successor()
        let propertyName = property_getName(property)
        if propertyName != nil {
            if let name = String.fromCString(propertyName) {
                if predicate == nil || propertyMatchesPredicate(property, predicate!) {
                    result.append(name)
                }
            }
        }
    }
    free(properties)
}


private func propertyMatchesPredicate(property: objc_property_t, _ predicate: String -> Bool) -> Bool {
    let attrs = String.fromCString(property_getAttributes(property))!
    return predicate(attrs)
}


func reflectionPropertyAttributeStringMatches(attrs: String, isObject: ReflectionMatch, isReadonly: ReflectionMatch, isWeak: ReflectionMatch) -> Bool {
    let attrs_arr = attrs.componentsSeparatedByString(",")

    if isObject != .DoNotCare {
        let typestr = attrs_arr[0]
        let is_obj = typestr.hasPrefix("T@\"")
        if is_obj != boolOfReflectionMatch(isObject) {
            return false
        }
    }

    for attr in attrs_arr {
        if attr == "R" {
            if isReadonly == .RequireNo {
                return false
            }
        }
        else if attr == "W" {
            if isReadonly == .RequireYes {
                return false
            }
        }
    }

    return true
}


private func boolOfReflectionMatch(m: ReflectionMatch) -> Bool {
    precondition(m != .DoNotCare)
    return (m == .RequireYes)
}
