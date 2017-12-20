//
//  CoordinatingController.m
//  Chinese
//
//  Created by Yanggl on 16/1/12.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import "CoordinatingController.h"
#import "WordViewController.h"
#import "ShowWordViewController.h"
#import "TestWordViewController.h"

#import "Common.h"

@interface CoordinatingController () {
    WordViewController      *_wordViewController;
    ShowWordViewController  *_showViewController;
}

@end

@implementation CoordinatingController 

- (void)initialize:(UIViewController *)viewController {
    _wordViewController = (WordViewController *)viewController;
    _activeViewController = _wordViewController;
}

#pragma mark - Singleton Method

static CoordinatingController *instance = nil;

+ (CoordinatingController *)sharedInstance {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[CoordinatingController alloc]init];
    });
    
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    
    return instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return instance;
}

#pragma mark - Transitions Methods

- (void)requestViewChangeByObject:(id)sender otherObject:(id)other {
    if ([sender isKindOfClass:[UIButton class]]) {
        ShowWordViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"showVC"];
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        controller.word = (WordModel *)other;
        [_activeViewController presentViewController:controller animated:YES completion:nil];
        _showViewController = controller;
        _activeViewController = _showViewController;
        [_wordViewController.musicPlayer pause];

    }else if ([sender isKindOfClass:[WordViewController class]]) {
        TestWordViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"testVC"];
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        controller.words = (NSMutableArray *)other;
        [_activeViewController presentViewController:controller animated:YES completion:nil];
        [_wordViewController.musicPlayer pause];
        
    }else if ([sender isKindOfClass:[ShowWordViewController class]]) {
        if (other != nil) {
            TestWordViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"testVC"];
            controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            controller.word = (WordModel *)other;
            [_activeViewController presentViewController:controller animated:YES completion:nil];
        }else {
            [Common  common_playShortMusic:@"music_btnclick.m4a"];
            [_activeViewController dismissViewControllerAnimated:YES completion:^{
                _activeViewController = _wordViewController;
            }];
        }

    }else if ([sender isKindOfClass:[TestWordViewController class]]) {
        [Common  common_playShortMusic:@"music_btnclick.m4a"];
        [_activeViewController dismissViewControllerAnimated:YES completion:^{
            [_showViewController dismissViewControllerAnimated:YES completion:nil];
            _activeViewController = _wordViewController;
        }];
    }
}

/**
 else if ([sender isKindOfClass:[WordViewController class]]) {
 [_activeViewController dismissViewControllerAnimated:YES completion:^{
 _activeViewController = _startViewController;
 [_startViewController.view setNeedsDisplay];
 }];
 
 }
 *  else if ([sender isKindOfClass:[StartViewController class]]) {
 WordViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"wordVC"];
 controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
 [_activeViewController presentViewController:controller animated:YES completion:nil];
 _activeViewController = controller;
 _wordViewController = controller;
 
 }
 */

@end
