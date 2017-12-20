//
//  StarModel.h
//  Chinese
//
//  Created by Yanggl on 16/1/28.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import <Realm/Realm.h>

@interface StarModel : RLMObject

@property NSInteger id;                 //主键

@property int starIndex;                //第几课
@property NSString *starWords;          //要完成的几个字“x，x，x，x”
@property NSString *starCompleted;      //已完成的任务“”
@property BOOL starLock;
@property int starNum;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<StarModel>
RLM_ARRAY_TYPE(StarModel)
