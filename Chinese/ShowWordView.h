//
//  ShowWordView.h
//  Chinese
//
//  Created by Young on 16/1/12.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Mark;

@interface ShowWordView : UIView

@property (nonatomic, strong) id <Mark> mark;

@end
