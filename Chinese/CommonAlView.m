//
//  CommonAlView.m
//  Chinese
//
//  Created by Yanggl on 16/1/28.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import "CommonAlView.h"
#import "Common.h"

@interface CommonAlView ()

@property (weak, nonatomic) IBOutlet UIView *alertView;

@end

@implementation CommonAlView

- (void)show:(NSString *)message {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.backgroundColor = [UIColor blackColor];
    [window addSubview:self];
    
    self.frame = window.bounds;
    self.alpha = 0;
    
    ((UILabel *)[self viewWithTag:10]).text = message;
    
    [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^ {
        self.alpha = 1.0;
        self.alertView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.12 animations:^ {
            self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    }];

}

- (void)showSettingView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.backgroundColor = [UIColor blackColor];
    [window addSubview:self];
    
    self.frame = window.bounds;
    self.alpha = 0;
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"MUSIC"] ) {
        [((UIButton *)[self viewWithTag:1]) setSelected:YES];
        [((UIButton *)[self viewWithTag:2]) setSelected:NO];

    }else {
        [((UIButton *)[self viewWithTag:1]) setSelected:NO];
        [((UIButton *)[self viewWithTag:2]) setSelected:YES];
    }
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"SPEED"] ) {
        [((UIButton *)[self viewWithTag:11]) setSelected:YES];
        [((UIButton *)[self viewWithTag:12]) setSelected:NO];
        
    }else {
        [((UIButton *)[self viewWithTag:11]) setSelected:NO];
        [((UIButton *)[self viewWithTag:12]) setSelected:YES];
    }
    
    [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^ {
        self.alpha = 1.0;
        self.alertView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.12 animations:^ {
            self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    }];
    
}

- (void)hide {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            self.alertView.transform = CGAffineTransformMakeScale(0.0, 0.0);
            self.alpha = 0.0;
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIView *view = [[touches anyObject] view];
    if (view.tag == 66) {
        [self hide];
    }
}

- (IBAction)btnToHide:(id)sender {
    [Common  common_playShortMusic:@"music_btnclick.m4a"];
    [self hide];
}

- (IBAction)btnToBack:(id)sender {
    [Common  common_playShortMusic:@"music_btnclick.m4a"];
    [self hide];
    if (self.didUpSide) {
        self.didUpSide();
    }
}

- (IBAction)btnSetMusic:(id)sender {
    [Common  common_playShortMusic:@"music_btnclick.m4a"];

    UIButton *button = sender;
    [button setSelected:!button.selected];
    
    if (button.tag == 1) {
        if (button.selected) {
            [((UIButton *)[self viewWithTag:2]) setSelected:NO];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MUSIC"];
        }
    }else {
        if (button.selected) {
            [((UIButton *)[self viewWithTag:1]) setSelected:NO];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"MUSIC"];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSettingMusic" object:nil];
}

- (IBAction)btnSetSpeed:(id)sender {
    [Common  common_playShortMusic:@"music_btnclick.m4a"];

    UIButton *button = sender;
    [button setSelected:!button.selected];
    
    if (button.tag == 11) {
        if (button.selected) {
            [((UIButton *)[self viewWithTag:12]) setSelected:NO];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SPEED"];

        }
    }else {
        if (button.selected) {
            [((UIButton *)[self viewWithTag:11]) setSelected:NO];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"SPEED"];

        }
    }
    
}

- (IBAction)btnSetReSet:(id)sender {
    [Common  common_playShortMusic:@"music_btnclick.m4a"];
    
    CommonAlView *alertView = [[NSBundle mainBundle]loadNibNamed:@"CommonAlView" owner:nil options:nil][2];
    [alertView show:@"确定要重新设置系统吗？"];
    alertView.didUpSide = ^ {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MUSIC"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SPEED"];
        
        [((UIButton *)[self viewWithTag:1]) setSelected:YES];
        [((UIButton *)[self viewWithTag:2]) setSelected:NO];
        [((UIButton *)[self viewWithTag:11]) setSelected:YES];
        [((UIButton *)[self viewWithTag:12]) setSelected:NO];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSettingReset" object:nil];

        [self hide];
    };

}


@end
