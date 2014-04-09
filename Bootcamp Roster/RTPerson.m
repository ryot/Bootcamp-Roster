//
//  RTPerson.m
//  Bootcamp Roster
//
//  Created by Ryo Tulman on 4/7/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "RTPerson.h"

@implementation RTPerson

-(NSString *)fullName
{
    if (_fullNameInverted && _lastName) {
        return [[_lastName stringByAppendingString:@", "] stringByAppendingString:_firstName];
    } else if (!_fullNameInverted && _lastName){
        return [[_firstName stringByAppendingString:@" "] stringByAppendingString:_lastName];
    } else if (!_lastName) {
        return _firstName;
    }
    return @"Name Error!";
}

@end
