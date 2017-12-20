//
//  Dot.m
//  Chinese
//
//  Created by Young on 16/1/12.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import "Dot.h"

@implementation Dot

#pragma mark - NSCopying Methods

- (id)copyWithZone:(NSZone *)zone {
    Dot *dotCopy = [[[self class]allocWithZone:zone]initWithLocation:self.location];
    
    //复制color
    [dotCopy setColor:[UIColor colorWithCGColor:[self.color CGColor]]];
    
    //复制size
    [dotCopy setSize:self.size];
    
    return dotCopy;
}

- (void)acceptMarkVisitor:(id<MarkVisitor>)visitor {
    [visitor visitDot:self];
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.color = [aDecoder decodeObjectForKey:@"DotColor"];
        self.size = [[aDecoder decodeObjectForKey:@"DotSize"]floatValue];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:self.color forKey:@"DotColor"];
    [aCoder encodeObject:@(self.size) forKey:@"DotSize"];
    
}

@end
