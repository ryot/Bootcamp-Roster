//
//  RTStudent.m
//  Bootcamp Roster
//
//  Created by Ryo Tulman on 4/7/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "RTStudent.h"

@implementation RTStudent

-(id)init {
    self = [super init];
    if (self) {
        self.type = kStudent;
    }
    return self;
}

@end
