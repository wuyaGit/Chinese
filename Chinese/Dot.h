//
//  Dot.h
//  Chinese
//
//  Created by Young on 16/1/12.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vertex.h"

@protocol MarkVisitor;

@interface Dot : Vertex

// for the Visitor pattern
- (void) acceptMarkVisitor:(id <MarkVisitor>)visitor;

// for the Memento pattern
- (id)initWithCoder:(NSCoder *)coder;
- (void)encodeWithCoder:(NSCoder *)coder;

@end
