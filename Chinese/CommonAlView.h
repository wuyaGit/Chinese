//
//  CommonAlView.h
//  Chinese
//
//  Created by Yanggl on 16/1/28.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidUpSide)();

@interface CommonAlView : UIView

@property (nonatomic, copy) DidUpSide  didUpSide;

- (void)show:(NSString *)message;
- (void)showSettingView;

@end
