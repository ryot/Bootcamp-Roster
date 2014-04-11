//
//  RTPerson.m
//  Bootcamp Roster
//
//  Created by Ryo Tulman on 4/7/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "RTPerson.h"

@implementation RTPerson

-(id)init {
    self = [super init];
    if (self) {
        _nameInverted = NO;
        _imagePath = @"";
    }
    return self;
}

-(NSString *)fullName
{
    if (_nameInverted && [_lastName length] > 0) {
        return [[_lastName stringByAppendingString:@", "] stringByAppendingString:_firstName];
    } else if (!_nameInverted && [_lastName length] > 0){
        return [[_firstName stringByAppendingString:@" "] stringByAppendingString:_lastName];
    } else if ([_firstName length] > 0) {
        return _firstName;
    } else {
        return _lastName; //if firstname is also blank, just show last name even if blank too
    }
}

@end
