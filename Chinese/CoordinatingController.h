//
//  CoordinatingController.h
//  Chinese
//
//  Created by Yanggl on 16/1/12.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CoordinatingController : NSObject <NSCopying>

@property (nonatomic, readonly) UIViewController *activeViewController;

+ (CoordinatingController *)sharedInstance;
- (void)initialize:(UIViewController *)viewController;

- (void)requestViewChangeByObject:(id)sender otherObject:(id)other;

@end
