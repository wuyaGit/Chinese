//
//  ShowWordView.m
//  Chinese
//
//  Created by Young on 16/1/12.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import "ShowWordView.h"
#import "MarkRenderer.h"

@implementation ShowWordView

- (void)drawRect:(CGRect)rect {
    //绘图代码
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //创建renderer访问者
    MarkRenderer *markRenderer = [[MarkRenderer alloc]initWithCGContext:context];
    
    //把renderer沿着mark组合结构传递
    [_mark acceptMarkVisitor:markRenderer];
}

@end
