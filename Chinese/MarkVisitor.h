//
//  MarkVisitor.h
//  Chinese
//
//  Created by Young on 16/1/12.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Mark;
@class Vertex, Dot, Stroke;

@protocol MarkVisitor  <NSObject>

- (void)visitMark:(id <Mark>)mark;
- (void)visitDot:(Dot *)dot;
- (void)visitVertex:(Vertex *)vertex;
- (void)visitStroke:(Stroke *)stroke;


@end