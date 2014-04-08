//
//  RTPerson.m
//  Bootcamp Roster
//
//  Created by Ryo Tulman on 4/7/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "RTPerson.h"

@implementation RTPerson

-(void)invertFullName:(BOOL)inverted
{
    if (_lastName) {
        if (inverted) {
            _fullName = [[_lastName stringByAppendingString:@", "] stringByAppendingString:_firstName];
        } else {
            _fullName = [[_firstName stringByAppendingString:@" "] stringByAppendingString:_lastName];
        }
    }
}

@end
