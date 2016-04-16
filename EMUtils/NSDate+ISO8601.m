//
//  NSDate+ISO8601.m
//  EMUtils
//
//  Created by Ewan Mellor on 4/16/16.
//  Copyright © 2016 Ewan Mellor. All rights reserved.
//

#import "NSDate+ISO8601.h"


// The iso8601String_* implementations here are 10x faster than using NSDateFormatter.


#define FORMAT_16 "%4d-%02d-%02dT%02d:%02d"
#define FORMAT_19 "%4d-%02d-%02dT%02d:%02d:%02d"
#define FORMAT_20 "%4d-%02d-%02dT%02d:%02d:%02dZ"
#define FORMAT_23 "%4d-%02d-%02dT%02d:%02d:%02d.%03d"
#define FORMAT_24 "%4d-%02d-%02dT%02d:%02d:%02d.%03dZ"


@implementation NSDate (ISO8601)


-(NSString *)em_iso8601String_16 {
    struct tm tm;
    gmtime_of_interval(self.timeIntervalSince1970, &tm);
    char buf[17];
    snprintf(buf, sizeof(buf), FORMAT_16, tm.tm_year + 1900, tm.tm_mon + 1,
             tm.tm_mday, tm.tm_hour, tm.tm_min);
    return [NSString stringWithCString:buf encoding:NSASCIIStringEncoding];
}


-(NSString *)em_iso8601String_19 {
    struct tm tm;
    gmtime_of_interval(self.timeIntervalSince1970, &tm);
    char buf[20];
    snprintf(buf, sizeof(buf), FORMAT_19, tm.tm_year + 1900, tm.tm_mon + 1,
             tm.tm_mday, tm.tm_hour, tm.tm_min, tm.tm_sec);
    return [NSString stringWithCString:buf encoding:NSASCIIStringEncoding];
}


-(NSString *)em_iso8601String_23 {
    struct tm tm;
    int ts_frac = gmtime_and_msec_of_interval(self.timeIntervalSince1970, &tm);
    char buf[24];
    snprintf(buf, sizeof(buf), FORMAT_23, tm.tm_year + 1900, tm.tm_mon + 1,
             tm.tm_mday, tm.tm_hour, tm.tm_min, tm.tm_sec, ts_frac);
    return [NSString stringWithCString:buf encoding:NSASCIIStringEncoding];
}


-(NSString *)em_iso8601String_local_23 {
    struct tm tm;
    int ts_frac = localtime_and_msec_of_interval(self.timeIntervalSince1970, &tm);
    char buf[24];
    snprintf(buf, sizeof(buf), FORMAT_23, tm.tm_year + 1900, tm.tm_mon + 1,
             tm.tm_mday, tm.tm_hour, tm.tm_min, tm.tm_sec, ts_frac);
    return [NSString stringWithCString:buf encoding:NSASCIIStringEncoding];
}


-(NSString *)em_iso8601String_24 {
    struct tm tm;
    int ts_frac = gmtime_and_msec_of_interval(self.timeIntervalSince1970, &tm);
    char buf[25];
    snprintf(buf, sizeof(buf), FORMAT_24, tm.tm_year + 1900, tm.tm_mon + 1,
             tm.tm_mday, tm.tm_hour, tm.tm_min, tm.tm_sec, ts_frac);
    return [NSString stringWithCString:buf encoding:NSASCIIStringEncoding];
}


static void gmtime_of_interval(NSTimeInterval ts, struct tm * tm) {
    time_t ts_whole = (time_t)ts;
    gmtime_r(&ts_whole, tm);
}


static int localtime_and_msec_of_interval(NSTimeInterval ts, struct tm * tm) {
    time_t ts_whole = (time_t)ts;
    localtime_r(&ts_whole, tm);
    return (int)round((ts - (double)ts_whole) * 1000.0);
}


static int gmtime_and_msec_of_interval(NSTimeInterval ts, struct tm * tm) {
    time_t ts_whole = (time_t)ts;
    gmtime_r(&ts_whole, tm);
    return (int)round((ts - (double)ts_whole) * 1000.0);
}


@end
