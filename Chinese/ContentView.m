//
//  ContentView.m
//  Chinese
//
//  Created by Yanggl on 16/1/12.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import "ContentView.h"
#import "CoordinatingController.h"
#import "WordModel.h"
#import "CommonAlView.h"
#import "Common.h"

@implementation ContentView

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images{
    if (self = [super initWithFrame:frame]) {
        
    }
    
    self.images = images;
    [self layoutContentviews];
    
    return self;
}

/**
 *  加载各个卡片
 */
- (void)layoutContentviews {
    CGFloat width = self.frame.size.width / 4;
    CGFloat height = self.frame.size.height / 3;
    
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 4; j++) {
            NSInteger index = i * 4 + j;
            WordModel *word = self.images[index];
            NSString *imageName = [NSString stringWithFormat:@"card_%@",word.wordImgName];
            
            UIButton *bCard = [[UIButton alloc]initWithFrame:CGRectMake(j * width, i * height, width, height)];
            [bCard setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            [bCard setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
            [bCard addTarget:self action:@selector(showWord:) forControlEvents:UIControlEventTouchUpInside];
            [bCard setTag:index];
            [self addSubview:bCard];

            UIImageView *lockImage = [[UIImageView alloc]initWithFrame:CGRectMake(bCard.frame.origin.x + 10, bCard.frame.origin.y + 10, 48, 60)];
            lockImage.image = [UIImage imageNamed:@"card_lock"];
            lockImage.hidden = !word.wordClock;
            [self addSubview:lockImage];
        }
    }
    
}

#pragma mark - Private

/**
 *  跳转到练习页面
 *
 *  @param sender card
 */
- (void)showWord:(id)sender {
    [Common  common_playShortMusic:@"music_btnclick.m4a"];
    UIButton *button = sender;
    __block WordModel  *word = self.images[button.tag];
    
    if (word.wordClock) {
        CommonAlView *alertView = [[NSBundle mainBundle]loadNibNamed:@"CommonAlView" owner:nil options:nil][0];
        [alertView show:@"你还没有完成上一课的评测任务哦。"];
        
    }else {
        [self bringSubviewToFront:button];
        CGPoint tempCenter = button.center;
        
        CoordinatingController *coordinater = [CoordinatingController sharedInstance];
        [UIView animateWithDuration:0.5 animations:^{
            button.center = coordinater.activeViewController.view.center;
            [button setTransform:CGAffineTransformMakeScale(4, 3)];
        } completion:^(BOOL finished) {
            [coordinater requestViewChangeByObject:button otherObject:word];
            
            [UIView animateWithDuration:2.0 animations:^{
                button.center = tempCenter;
                [button setTransform:CGAffineTransformMakeScale(1, 1)];
                
            }];
        }];
    }
    
}

//- (WordModel *)converToModel:(NSInteger)tag {
//    NSString *imageName = self.images[tag];
//    imageName = [[imageName substringFromIndex:5]stringByReplacingOccurrencesOfString:@".png" withString:@""];
//    
//    WordModel *word = [[WordModel objectsWhere:[NSString stringWithFormat:@"wordImgName == '%@' ",imageName]]firstObject];
//    return word;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
