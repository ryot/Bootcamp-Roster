//
//  RTCellColorGradientView.h
//  Bootcamp Roster
//
//  Created by Ryo Tulman on 4/11/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTCellColorGradientView : UIView

@property (nonatomic, strong) UIColor *color;

- (id)initWithFrame:(CGRect)frame andColor:(UIColor *)color;

@end
