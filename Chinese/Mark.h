//
//  Mark.h
//  Chinese
//
//  Created by Young on 16/1/12.
//  Copyright © 2016年 yanggl. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MarkVisitor.h"

@protocol Mark <NSObject, NSCopying, NSCoding>

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat size;
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, readonly) NSUInteger count; //子节点的个数
@property (nonatomic, readonly) id <Mark> lastChild;
@property (nonatomic, assign) CGLineCap strokeLineGap;

- (id)copy;
- (void)addMark:(id<Mark>)mark;
- (void)removeMark:(id<Mark>)mark;
- (id <Mark>)childMarkAtIndex:(NSUInteger)index;

// for the Visitor pattern
- (void) acceptMarkVisitor:(id <MarkVisitor>) visitor;
@end
