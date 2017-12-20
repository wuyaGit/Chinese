//
//  Stroke.m
//  Chinese
//
//  Created by Young on 16/1/12.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import "Stroke.h"

@implementation Stroke

@dynamic location;
@synthesize strokeLineGap = _strokeLineGap;

- (instancetype)init {
    if (self = [super init]) {
        _children = [[NSMutableArray alloc]init];
    }
    
    return self;
}


- (CGLineCap)strokeLineGap {
    
    return _strokeLineGap;
}

- (void)setStrokeLineGap:(CGLineCap)strokeLineGap {
    if (strokeLineGap) {
        _strokeLineGap = strokeLineGap;
    }else {
        _strokeLineGap = kCGLineCapButt;
    }
}

- (void)setLocation:(CGPoint)location {
    
}

- (CGPoint)location {
    //返回第1个子节点的位置
    if ([_children count] > 0) {
        return [(id <Mark>)_children[0] location];
    }
    
    //否则，返回原点
    return CGPointZero;
}

- (void)addMark:(id<Mark>)mark {
    [_children addObject:mark];
}

- (void)removeMark:(id<Mark>)mark {
    //如果mark在这一层，将其移除
    //否则，让每个子节点去找它
    if ([_children containsObject:mark]) {
        [_children removeObject:mark];
    }else {
        [_children makeObjectsPerformSelector:@selector(removeMark:) withObject:mark];
    }
}

- (id <Mark>)childMarkAtIndex:(NSUInteger)index {
    if (index >= _children.count) {
        return nil;
    }
    
    return _children[index];
}

//返回最后子节点
- (id <Mark>)lastChild {
    return _children.lastObject;
}

- (NSUInteger)count {
    return _children.count;
}

- (void)acceptMarkVisitor:(id<MarkVisitor>)visitor {
    for (id <Mark> dot in _children) {
        [dot acceptMarkVisitor:visitor];
    }
    [visitor visitStroke:self];
}

- (NSArray *)children {
    return _children;
}

//返回最后子节点
- (id<Mark>)midChild {
    return _children[[self count]/2];
}

#pragma mark - NSCopying Methods

- (id)copyWithZone:(NSZone *)zone {
    Stroke *strokeCopy = [[[self class]allocWithZone:zone]init];
    
    //复制color
    [strokeCopy setColor:[UIColor colorWithCGColor:[self.color CGColor]]];
    
    //复制size
    [strokeCopy setSize:self.size];
    
    //复制children
    for (id <Mark> child in _children) {
        id <Mark> childCopy = [child copy];
        [strokeCopy addMark:childCopy];
    }
    
    return strokeCopy;
}

#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _color = [aDecoder decodeObjectForKey:@"StrokeColor"];
        _size = [[aDecoder decodeObjectForKey:@"StrokeSize"]floatValue];
        _children = [aDecoder decodeObjectForKey:@"StrokeChildren"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_color forKey:@"StrokeColor"];
    [aCoder encodeObject:@(_size) forKey:@"StrokeSize"];
    [aCoder encodeObject:_children forKey:@"StrokeChildren"];
}


@end
