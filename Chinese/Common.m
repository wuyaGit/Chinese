//
//  Common.m
//  Chinese
//
//  Created by Yanggl on 16/1/20.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import "Common.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation Common

+ (CGFloat)common_centerXWithType:(CIType)ciType {
    switch (ciType) {
        case CITypeFourIndexZero:
            return 126.0;
            break;
        case CITypeFourIndexOne:
            return 382.0;
            break;
        case CITypeFourIndexTwo:
            return 640.0;
            break;
        case CITypeFourIndexThree:
            return 896.0;
            break;
        case CITypeThreeIndexZero:
            return 254.0;
            break;
        case CITypeThreeIndexOne:
            return 512.0;
            break;
        case CITypeThreeIndexTwo:
            return 768.0;
            break;
        case CITypeTwoIndexZero:
            return 382.0;
            break;
        case CITypeTwoIndexOne:
            return 639.0;
            break;
        default:
            break;
    }
}

+ (UIColor *)common_colorFromRGB:(NSString *)rgb {
    CGFloat red     = strtoul([[rgb substringWithRange:NSMakeRange(0, 2)]UTF8String], 0, 16);
    CGFloat green   = strtoul([[rgb substringWithRange:NSMakeRange(2, 2)]UTF8String], 0, 16);
    CGFloat blue    = strtoul([[rgb substringWithRange:NSMakeRange(4, 2)]UTF8String], 0, 16);
    
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1.0];
}

+ (void)common_playShortMusic:(NSString *)path {
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"MUSIC"] ) {
        SystemSoundID soundID;
        
        //创建音乐文件路径
        NSString *thesoundFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"music/%@",path] ofType:nil];
        
        CFURLRef thesoundURL = (__bridge CFURLRef) [NSURL fileURLWithPath:thesoundFilePath];
        
        //变量SoundID与URL对应
        AudioServicesCreateSystemSoundID(thesoundURL, &soundID);
        
        //播放SoundID声音
        AudioServicesPlaySystemSound(soundID);
    }
}


@end
