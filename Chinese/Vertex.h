//
//  Vertex.h
//  Chinese
//
//  Created by Young on 16/1/12.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mark.h"

@protocol MarkVisitor;

@interface Vertex : NSObject <Mark>

@property(nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat size;
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) id<Mark> lastChild;
@property (nonatomic, assign) CGLineCap strokeLineGap;

- (id)initWithLocation:(CGPoint)location;
- (void)addMark:(id<Mark>)mark;
- (void)removeMark:(id<Mark>)mark;
- (id <Mark>)childMarkAtIndex:(NSUInteger)index;

- (id)copyWithZone:(NSZone *)zone;

// for the Visitor pattern
- (void) acceptMarkVisitor:(id <MarkVisitor>)visitor;

// for the Memento pattern
- (id)initWithCoder:(NSCoder *)coder;
- (void)encodeWithCoder:(NSCoder *)coder;


@end
