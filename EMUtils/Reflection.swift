//
//  Reflection.swift
//  EMUtils
//
//  Created by Ewan Mellor on 4/15/16.
//  Copyright © 2016 Ewan Mellor. All rights reserved.
//

import Foundation


enum ReflectionMatch {
    case doNotCare
    case requireNo
    case requireYes
}


/**
 - parameter predicate: A predicate that is applied to the attribute
   declaration string of each property (c.f. `property_getAttributes`).
   Return true to include the property in the result.
 - returns: The names of each property in the full class heirarchy that
   match the given predicate.
 */
func reflectionGetPropertyNames(_ cls: AnyClass, predicate: ((String) -> Bool)?) -> [String] {
    var result = [String]()
    reflectionGetPropertyNames_(cls, &result, predicate)
    return result
}

private func reflectionGetPropertyNames_(_ cls: AnyClass, _ result: inout [String], _ predicate: ((String) -> Bool)?) {
    reflectionGetPropertyNamesSingle(cls, &result, predicate);

    if let superclass = class_getSuperclass(cls), superclass != NSObject.self {
        reflectionGetPropertyNames_(superclass, &result, predicate);
    }
}


private func reflectionGetPropertyNamesSingle(_ cls: AnyClass, _ result: inout [String], _ predicate: ((String) -> Bool)?) {
    var outCount: CUnsignedInt = 0
    var properties = class_copyPropertyList(cls, &outCount)
    for _ in [0 ..< Int(outCount)] {
        let property = properties?.pointee
        properties = properties?.successor()
        let propertyName = property_getName(property)
        if propertyName != nil {
            if let name = String(validatingUTF8: propertyName!) {
                if predicate == nil || propertyMatchesPredicate(property!, predicate!) {
                    result.append(name)
                }
            }
        }
    }
    free(properties)
}


private func propertyMatchesPredicate(_ property: objc_property_t, _ predicate: (String) -> Bool) -> Bool {
    let attrs = String(cString: property_getAttributes(property))
    return predicate(attrs)
}


func reflectionPropertyAttributeStringMatches(_ attrs: String, isObject: ReflectionMatch, isReadonly: ReflectionMatch, isWeak: ReflectionMatch) -> Bool {
    let attrs_arr = attrs.components(separatedBy: ",")

    if isObject != .doNotCare {
        let typestr = attrs_arr[0]
        let is_obj = typestr.hasPrefix("T@\"")
        if is_obj != boolOfReflectionMatch(isObject) {
            return false
        }
    }

    for attr in attrs_arr {
        if attr == "R" {
            if isReadonly == .requireNo {
                return false
            }
        }
        else if attr == "W" {
            if isReadonly == .requireYes {
                return false
            }
        }
    }

    return true
}


private func boolOfReflectionMatch(_ m: ReflectionMatch) -> Bool {
    precondition(m != .doNotCare)
    return (m == .requireYes)
}
