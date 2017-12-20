//
//  ContentView.h
//  Chinese
//
//  Created by Yanggl on 16/1/12.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentView : UIView

@property (nonatomic, strong) NSArray *images;

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images;

@end
