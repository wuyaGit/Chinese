//
//  TestWordViewController.h
//  Chinese
//
//  Created by Yanggl on 16/1/12.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordModel.h"

@interface TestWordViewController : UIViewController

@property (nonatomic, strong) WordModel *word;
@property (nonatomic, strong) NSMutableArray *words;

@end
