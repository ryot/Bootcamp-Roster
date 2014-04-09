//
//  RTDataSource.h
//  Bootcamp Roster
//
//  Created by Ryo Tulman on 4/9/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *teachers, *students;

@end
