//
//  WordModel.h
//  Chinese
//
//  Created by Yanggl on 16/1/27.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface WordModel : RLMObject

@property NSInteger id;

@property NSString *wordImgName;
@property BOOL      wordClock;

@property NSString *wordName;
@property NSString *wordPy;
@property NSString *wordColorRGB;
@property NSString *parts;
@property NSString *purations;
@property NSString *pis;
@property NSString *piPys;
@property NSString *piType;

@property (nonatomic, strong, readonly) NSArray *wordParts;
@property (nonatomic, strong, readonly) NSArray *wordDurations;
@property (nonatomic, strong, readonly) NSArray *wordCis;
@property (nonatomic, strong, readonly) NSArray *wordCiPys;
@property (nonatomic, strong, readonly) NSArray *wordCiType;
@property (nonatomic, strong, readonly) NSArray *wordPoints;
@property (nonatomic, strong, readonly) UIColor *wordColor;


@end

RLM_ARRAY_TYPE(WordModel)

// This protocol enables typed collections. i.e.:
// RLMArray<WordModel>

