//
//  MarkRenderer.h
//  Chinese
//
//  Created by Young on 16/1/12.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MarkVisitor.h"
#import "Vertex.h"
#import "Dot.h"
#import "Stroke.h"

@interface MarkRenderer : NSObject <MarkVisitor>{
    @private
    BOOL _shouldMoveContextToDot;
    @protected
    CGContextRef _context;
}

- (id)initWithCGContext:(CGContextRef)context;
- (void)visitMark:(id<Mark>)mark;
- (void)visitDot:(Dot *)dot;
- (void)visitVertex:(Vertex *)vertex;
- (void)visitStroke:(Stroke *)stroke;

@end
