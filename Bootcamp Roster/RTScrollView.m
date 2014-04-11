//
//  RTScrollView.m
//  Bootcamp Roster
//
//  Created by Ryo Tulman on 4/10/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "RTScrollView.h"

@implementation RTScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self endEditing:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
