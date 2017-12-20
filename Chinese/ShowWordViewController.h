//
//  ShowWordViewController.h
//  Chinese
//
//  Created by Yanggl on 16/1/12.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordModel.h"
#import "Mark.h"
#import "Scribble.h"

@interface ShowWordViewController : UIViewController

@property (nonatomic, strong) WordModel *word;

@property (nonatomic, strong) Scribble *scribble;

@property (nonatomic, strong) UIColor *storkeColor;
@property (nonatomic, assign) CGFloat strokeSize;

@end
