//
//  WordModel.m
//  Chinese
//
//  Created by Yanggl on 16/1/27.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import "WordModel.h"
#import "Common.h"

@interface WordModel () {
    NSArray *_wordParts;
    NSArray *_wordDurations;
    NSArray *_wordCis;
    NSArray *_wordCiPys;
    NSArray *_wordCiType;
    NSArray *_wordPoints;
    UIColor *_wordColor;
}

@end

@implementation WordModel

@synthesize wordParts = _wordPoints;
@synthesize wordDurations = _wordDurations;
@synthesize wordCis = _wordCis;
@synthesize wordCiPys = _wordCiPys;
@synthesize wordCiType = _wordCiType;
//@synthesize wordPoints = _wordPoints;
//@synthesize wordColor = _wordColor;

+ (NSString *)primaryKey {
    return @"id";
}

- (NSArray *)wordParts {
    if (!_wordParts) {
        NSArray *parts = [NSJSONSerialization JSONObjectWithData:[self.parts dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];

        NSMutableArray *bezierPaths = [NSMutableArray array];
        NSMutableArray *partPoints = [NSMutableArray array];
        
        for (NSDictionary *part in parts) {
            NSArray *aPoints = part.allValues[0];
            if ([part.allKeys[0] isEqualToString:@"line"]) {        //直线
                UIBezierPath *aPath = [UIBezierPath bezierPath];
                aPath.lineCapStyle = kCGLineCapButt;       //线条拐角
                aPath.lineJoinStyle = kCGLineJoinBevel;     //终点处理
                for (int i = 0; i < [aPoints count]; i++ ) {
                    CGPoint point = CGPointMake([aPoints[i][0] floatValue], [aPoints[i][1] floatValue]);
                    
                    if (i == 0) {
                        [aPath moveToPoint:point];
                    }else {
                        [aPath addLineToPoint:point];
                    }
                }
                
                [bezierPaths addObject:aPath];
            }else if ([part.allKeys[0] isEqualToString:@"curveline"]){//直线加曲线
                UIBezierPath *aPath = [UIBezierPath bezierPath];
                aPath.lineCapStyle = kCGLineCapButt;       //线条拐角
                aPath.lineJoinStyle = kCGLineJoinBevel;     //终点处理
                
                NSArray *clArray = part[@"curveline"];
                for (NSDictionary *clDict in clArray) {
                    NSArray *ps = clDict.allValues[0];
                    if ([clDict.allKeys[0] isEqualToString:@"line"]) {
                        for (int i = 0; i < [ps count]; i++ ) {
                            CGPoint point = CGPointMake([ps[i][0] floatValue], [ps[i][1] floatValue]);
                            if (i == 0) {
                                [aPath moveToPoint:point];
                            }else {
                                [aPath addLineToPoint:point];
                            }
                        }
                    }else {
                        [aPath moveToPoint:CGPointMake([ps[0][0] floatValue], [ps[0][1] floatValue])];
                        [aPath addQuadCurveToPoint:CGPointMake([ps[2][0] floatValue], [ps[2][1] floatValue]) controlPoint:CGPointMake([ps[1][0] floatValue], [ps[1][1] floatValue])];
                    }
                }
                [bezierPaths addObject:aPath];
                
            }else if ([part.allKeys[0] isEqualToString:@"curve"]){                                                 //曲线
                UIBezierPath *aPath = [UIBezierPath bezierPath];
                aPath.lineCapStyle = kCGLineCapButt;       //线条拐角
                aPath.lineJoinStyle = kCGLineJoinBevel;     //终点处理
                
                [aPath moveToPoint:CGPointMake([aPoints[0][0] floatValue], [aPoints[0][1] floatValue])];
                [aPath addQuadCurveToPoint:CGPointMake([aPoints[2][0] floatValue], [aPoints[2][1] floatValue]) controlPoint:CGPointMake([aPoints[1][0] floatValue], [aPoints[1][1] floatValue])];
                
                [bezierPaths addObject:aPath];
            }
            
            if ([part.allKeys[0] isEqualToString:@"curveline"]){
                NSValue *startPoint = [NSValue valueWithCGPoint:CGPointMake([((NSDictionary *)aPoints.firstObject).allValues[0][0][0] floatValue], [((NSDictionary *)aPoints.firstObject).allValues[0][0][1] floatValue])];
                NSValue *endPoint   = [NSValue valueWithCGPoint:CGPointMake([((NSArray *)((NSDictionary *)aPoints.lastObject).allValues[0]).lastObject[0] floatValue], [((NSArray *)((NSDictionary *)aPoints.lastObject).allValues[0]).lastObject[1] floatValue])];
                [partPoints addObject:@[startPoint, endPoint]];
            }else {
                NSValue *startPoint = [NSValue valueWithCGPoint:CGPointMake([aPoints.firstObject[0] floatValue], [aPoints.firstObject[1] floatValue])];
                NSValue *endPoint   = [NSValue valueWithCGPoint:CGPointMake([aPoints.lastObject[0] floatValue], [aPoints.lastObject[1] floatValue])];
                [partPoints addObject:@[startPoint, endPoint]];
            }
        }
        
        _wordParts = bezierPaths;
        _wordPoints = partPoints;
    }
    
    return _wordParts;
}

- (NSArray *)wordPoints {
    if (!_wordPoints) {
        [self wordParts];
    }
    
    return _wordPoints;
}

- (NSArray *)wordDurations {
    if (!_wordDurations ) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:[self.purations dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        _wordDurations = array;
    }

    return _wordDurations;
}

- (NSArray *)wordCis {
    if (!_wordCis) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:[self.pis dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        _wordCis = array;
    }
    
    return _wordCis;
}

- (NSArray *)wordCiPys {
    if (!_wordCiPys) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:[self.piPys dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        _wordCiPys = array;
    }
    
    return _wordCiPys;
}

- (NSArray *)wordCiType {
    if (!_wordCiType) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:[self.piType dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        _wordCiType = array;
    }
    
    return _wordCiType;
}

- (UIColor *)wordColor {
    if (!_wordColor) {
        _wordColor  = [Common common_colorFromRGB:self.wordColorRGB];
    }
    return _wordColor;
}

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
