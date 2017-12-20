//
//  Vertex.m
//  Chinese
//
//  Created by Young on 16/1/12.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import "Vertex.h"

@implementation Vertex

@dynamic color, size;

- (id)initWithLocation:(CGPoint)location {
    if (self = [super init]) {
        [self setLocation:location];
    }
    
    return self;
}

//默认属性什么也不做
- (void)setColor:(UIColor *)color {}
- (UIColor *) color {return nil;}
- (void) setSize:(CGFloat)size {}
- (CGFloat) size {return  0.0; }

//Mark 操作什么也不做
- (void)addMark:(id<Mark>)mark {}
- (void)removeMark:(id<Mark>)mark {}
- (id<Mark>)childMarkAtIndex:(NSUInteger)index {return nil;}
- (id<Mark>)lastChild {return nil;}
- (NSUInteger)count {return 0;}
- (NSEnumerator *)enumerator { return  nil;}

#pragma mark - NSCopying methods

- (id)copyWithZone:(NSZone *)zone {
    Vertex *vertexCopy = [[[self class] allocWithZone:zone] initWithLocation:_location];
    return vertexCopy;
}

- (void)acceptMarkVisitor:(id<MarkVisitor>)visitor {
    [visitor visitVertex:self];
}

#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _location = [[aDecoder decodeObjectForKey:@"VertexLocation"]CGPointValue];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSValue valueWithCGPoint:_location] forKey:@"VertexLocation"];
}


@end
