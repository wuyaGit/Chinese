//
//  Scribble.h
//  Chinese
//
//  Created by Young on 16/1/12.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mark.h"

@interface Scribble : NSObject{
@private
    id<Mark> parentMark_;
    id<Mark> incrementalMark_;
}

+ (Scribble *)scribbleWithScribble:(Scribble *)scribble;

- (void)addMark:(id<Mark>)mark shouldAddToPreviousMark:(BOOL)shouldAddToPreviousMark;
- (void)removeMark:(id<Mark>)mark;

- (void)removeLastMark;

- (id <Mark>)childMarkAtIndex:(NSUInteger)index;
@end
