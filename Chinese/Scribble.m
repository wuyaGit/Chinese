//
//  Scribble.m
//  Chinese
//
//  Created by Young on 16/1/12.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import "Scribble.h"
#import "Stroke.h"

@interface Scribble ()

@property (nonatomic, strong)id<Mark> mark;

@end

@implementation Scribble

@synthesize mark = parentMark_;

- (instancetype)init {
    if (self = [super init]) {
        //父节点应该是个组合对象（Stroke）
        parentMark_ = [[Stroke alloc]init];
    }
    
    return self;
}

+ (Scribble *)scribbleWithScribble:(Scribble *)scribble {
    Scribble *scb = [[Scribble alloc]init];
    [scb setMark:scribble->parentMark_];
    
    return scribble;
}

//与Mark管理相关的方法

- (void)addMark:(id<Mark>)mark shouldAddToPreviousMark:(BOOL)shouldAddToPreviousMark {
    //手工调用KVO
    [self willChangeValueForKey:@"mark"];
    
    //如果should设置为YES，就把mark添加到前一个mark中作为聚合体一部分，它是根节点的最后一个子节点
    //
    if (shouldAddToPreviousMark) {
        [[parentMark_ lastChild] addMark:mark];
    }else { //否则附加到父节点
        [parentMark_ addMark:mark];
        incrementalMark_ = mark;
    }
    
    //手工调用KVO
    [self didChangeValueForKey:@"mark"];
}

- (void)removeMark:(id<Mark>)mark {
    //如果mark是父节点则什么都不做
    if (mark == parentMark_) {
        return;
    }
    
    [self willChangeValueForKey:@"mark"];
    
    [parentMark_ removeMark:mark];
    
    //不需要保存incrementalMark引用，因为他刚从父节点删除
    if (mark == incrementalMark_) {
        incrementalMark_ = nil;
    }
    
    [self didChangeValueForKey:@"mark"];
}

- (void)removeLastMark {
    id<Mark> mark = [parentMark_ lastChild];
    [self removeMark:mark];
}

//寻找线段
- (id <Mark>)childMarkAtIndex:(NSUInteger)index {
    if (index >= parentMark_.count) {
        return nil;
    }
    
    return [parentMark_ childMarkAtIndex:index];// [(Stroke *)parentMark_ children][index];
}

@end
