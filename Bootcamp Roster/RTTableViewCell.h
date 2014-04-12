//
//  RTTableViewCell.h
//  Bootcamp Roster
//
//  Created by Ryo Tulman on 4/11/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTPerson.h"

@interface RTTableViewCell : UITableViewCell

@property (nonatomic, strong) RTPerson *person;

@end
