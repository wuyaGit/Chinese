//
//  Common.h
//  Chinese
//
//  Created by Yanggl on 16/1/20.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CIType) {
    CITypeFourIndexZero = 1,
    CITypeFourIndexOne,
    CITypeFourIndexTwo,
    CITypeFourIndexThree,
    CITypeThreeIndexZero,
    CITypeThreeIndexOne,
    CITypeThreeIndexTwo,
    CITypeTwoIndexZero,
    CITypeTwoIndexOne
};

@interface Common : NSObject

+ (CGFloat)common_centerXWithType:(CIType)ciType ;
+ (UIColor *)common_colorFromRGB:(NSString *)rgb ;
+ (void)common_playShortMusic:(NSString *)path;

@end
