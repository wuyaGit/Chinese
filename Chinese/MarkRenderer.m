//
//  MarkRenderer.m
//  Chinese
//
//  Created by Young on 16/1/12.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import "MarkRenderer.h"

@implementation MarkRenderer

- (id)initWithCGContext:(CGContextRef)context {
    if (self = [super init]) {
        _context = context;
        _shouldMoveContextToDot = YES;
    }
    return self;
}

- (void)visitMark:(id<Mark>)mark {
    
}

- (void)visitDot:(Dot *)dot {
    CGFloat x = [dot location].x;
    CGFloat y = [dot location].y;
    CGFloat frameSize = [dot size];
    CGRect frame = CGRectMake(x - frameSize / 2.0,
                              y - frameSize / 2.0,
                              frameSize,
                              frameSize);
    CGContextSetFillColorWithColor(_context, [dot color].CGColor);
    CGContextFillEllipseInRect(_context, frame);
    
}

- (void)visitVertex:(Vertex *)vertex {
    CGFloat x = [vertex location].x;
    CGFloat y = [vertex location].y;
    
    if (_shouldMoveContextToDot) {
        CGContextMoveToPoint(_context, x, y);
        _shouldMoveContextToDot = NO;
    }else {
        CGContextAddLineToPoint(_context, x, y);
    }
}

- (void)visitStroke:(Stroke *)stroke {
    CGContextSetStrokeColorWithColor(_context, [stroke color].CGColor);
    CGContextSetLineWidth(_context, [stroke size]);
    CGContextSetLineCap(_context, [stroke strokeLineGap]);
    CGContextStrokePath(_context);
    _shouldMoveContextToDot = YES;
}


@end
