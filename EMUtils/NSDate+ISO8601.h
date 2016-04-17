//
//  NSDate+ISO8601.h
//  EMUtils
//
//  Created by Ewan Mellor on 4/16/16.
//  Copyright © 2016 Ewan Mellor. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN


@interface NSDate (ISO8601)

/**
 * @return NAN if the datetime is unparseable.
 */
+(NSTimeInterval)timeIntervalSinceReferenceDateFromIso8601:(NSString *)s;

/**
 * @return A truncated UTC ISO 8601 date string with no seconds part: yyyy-MM-dd'T'HH:mm
 */
-(NSString *)em_iso8601String_16;

/**
 * @return A 19-character UTC ISO 8601 date string with seconds but no msec or Z suffix: yyyy-MM-dd'T'HH:mm:ss
 */
-(NSString *)em_iso8601String_19;

/**
 * @return A full UTC ISO 8601 date string with msec and no timezone suffix: yyyy-MM-dd'T'HH:mm:ss.SSS
 */
-(NSString *)em_iso8601String_23;

/**
 * @return A full local timezone ISO 8601 date string with msec and no timezone suffix: yyyy-MM-dd'T'HH:mm:ss.SSS
 */
-(NSString *)em_iso8601String_local_23;

/**
 * @return A full UTC ISO 8601 date string with msec and a Z suffix: yyyy-MM-dd'T'HH:mm:ss.SSS'Z'
 */
-(NSString *)em_iso8601String_24;

@end


NS_ASSUME_NONNULL_END
