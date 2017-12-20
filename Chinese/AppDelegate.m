//
//  AppDelegate.m
//  Chinese
//
//  Created by Yanggl on 16/1/12.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import "AppDelegate.h"
#import "WordModel.h"
#import "StarModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupSystem];
    
    return YES;
}

/**
 *  第一次加载时加载数据
 */
- (void)setupSystem {
    if (![[NSFileManager defaultManager] fileExistsAtPath:[RLMRealmConfiguration defaultConfiguration].path]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MUSIC"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SPEED"];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"JSON.json" ofType:nil];
        NSData *jsonData = [NSData dataWithContentsOfFile:path];
        
        NSError *error;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        
        for (NSInteger index = 0; index < jsonArray.count; index++) {
            NSDictionary *json = jsonArray[index];
            
            WordModel *word = [[WordModel alloc]init];
            word.id         = index;
            word.wordImgName= json[@"wordImgName"];
            word.wordClock  = [json[@"wordClock"] boolValue];
            word.wordName   = json[@"wordName"];
            word.wordPy     = json[@"wordPy"];
            word.wordColorRGB = json[@"wordColorRGB"] ;
            NSData *data = [NSJSONSerialization dataWithJSONObject:json[@"wordParts"] options:NSJSONWritingPrettyPrinted error:&error];
            word.parts      = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            
            data = [NSJSONSerialization dataWithJSONObject:json[@"wordDurations"] options:NSJSONWritingPrettyPrinted error:&error];
            word.purations  = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            
            data = [NSJSONSerialization dataWithJSONObject:json[@"wordCis"] options:NSJSONWritingPrettyPrinted error:&error];
            word.pis        = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            
            data = [NSJSONSerialization dataWithJSONObject:json[@"wordCiPys"] options:NSJSONWritingPrettyPrinted error:&error];
            word.piPys      = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            
            data = [NSJSONSerialization dataWithJSONObject:json[@"wordCiType"] options:NSJSONWritingPrettyPrinted error:&error];
            word.piType     = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            
            [realm addObject:word];
        }
        
        NSArray *starArray = [NSArray arrayWithObjects:@"土,火,水,口",@"木,川,山,文",@"月,去,风,上",@"飞,于,下,也",@"人,巴,日,有",@"天,少,在,刀",@"目,平,中,门",@"丰,大,田,女",@"未,子,手,西",@"首,白,生,已",@"元,里,兽,完",@"虫,问,鸟,鱼", nil];
        for (int index = 0; index < starArray.count; index++) {
            StarModel *starModel = [[StarModel alloc]init];
            starModel.id = index;
            starModel.starIndex = index+1;
            starModel.starLock = YES;
            starModel.starNum = 0;
            starModel.starWords = starArray[index];
            starModel.starCompleted = @"";
            [realm addObject:starModel];
        }
        
        [realm commitWriteTransaction];
    }
}

- (void)resetSystem {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"JSON.json" ofType:nil];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    for (NSInteger index = 0; index < jsonArray.count; index++) {
        NSDictionary *json = jsonArray[index];
        
        WordModel *word = [[WordModel alloc]init];
        word.id         = index;
        word.wordImgName= json[@"wordImgName"];
        word.wordClock  = [json[@"wordClock"] boolValue];
        word.wordName   = json[@"wordName"];
        word.wordPy     = json[@"wordPy"];
        word.wordColorRGB = json[@"wordColorRGB"] ;
        NSData *data = [NSJSONSerialization dataWithJSONObject:json[@"wordParts"] options:NSJSONWritingPrettyPrinted error:&error];
        word.parts      = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        data = [NSJSONSerialization dataWithJSONObject:json[@"wordDurations"] options:NSJSONWritingPrettyPrinted error:&error];
        word.purations  = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        data = [NSJSONSerialization dataWithJSONObject:json[@"wordCis"] options:NSJSONWritingPrettyPrinted error:&error];
        word.pis        = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        data = [NSJSONSerialization dataWithJSONObject:json[@"wordCiPys"] options:NSJSONWritingPrettyPrinted error:&error];
        word.piPys      = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        data = [NSJSONSerialization dataWithJSONObject:json[@"wordCiType"] options:NSJSONWritingPrettyPrinted error:&error];
        word.piType     = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        [realm addOrUpdateObject:word];
    }
    
    NSArray *starArray = [NSArray arrayWithObjects:@"土,火,水,口",@"木,川,山,文",@"月,去,风,上",@"飞,于,下,也",@"人,巴,日,有",@"天,少,在,刀",@"目,平,中,门",@"丰,大,田,女",@"未,子,手,西",@"首,白,生,已",@"元,里,兽,完",@"虫,问,鸟,鱼", nil];
    for (int index = 0; index < starArray.count; index++) {
        StarModel *starModel = [[StarModel alloc]init];
        starModel.id = index;
        starModel.starIndex = index+1;
        starModel.starLock = YES;
        starModel.starNum = 0;
        starModel.starWords = starArray[index];
        starModel.starCompleted = @"";
        [realm addOrUpdateObject:starModel];
    }
    
    [realm commitWriteTransaction];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
