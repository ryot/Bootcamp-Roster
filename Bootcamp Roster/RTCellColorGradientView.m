//
//  RTCellColorGradientView.m
//  Bootcamp Roster
//
//  Created by Ryo Tulman on 4/11/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "RTCellColorGradientView.h"

@implementation RTCellColorGradientView

- (id)initWithFrame:(CGRect)frame andColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        if (color) {
            _color = color;
        } else {
            _color = [UIColor grayColor];
        }
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (_color) {
        //// General Declarations
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Gradient Declarations
        NSArray* gradientColors = [NSArray arrayWithObjects:
                                   (id)_color.CGColor,
                                   (id)[UIColor whiteColor].CGColor, nil];
        CGFloat gradientLocations[] = {0.2, 0.7, 1};
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
        
        //// CellGradient Drawing
        UIBezierPath* cellGradientPath = [UIBezierPath bezierPathWithRect: rect];
        CGContextSaveGState(context);
        [cellGradientPath addClip];
        CGContextDrawLinearGradient(context, gradient, CGPointMake(rect.origin.x, rect.origin.y * 2), CGPointMake(rect.origin.x + rect.size.width, rect.origin.y * 2), 0);
        CGContextRestoreGState(context);
        
        //// Cleanup
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
    }
}


@end
