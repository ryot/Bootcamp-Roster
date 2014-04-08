//
//  RTPerson.h
//  Bootcamp Roster
//
//  Created by Ryo Tulman on 4/7/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTPerson : NSObject

typedef NS_ENUM(NSInteger, PersonType) {
    kTeacher,
    kStudent,
};

@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) PersonType type;

-(void)invertFullName:(BOOL)inverted;

@end
