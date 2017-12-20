//
//  ShowWordViewController.m
//  Chinese
//
//  Created by Yanggl on 16/1/12.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import "ShowWordViewController.h"
#import "CoordinatingController.h"
#import "ShowWordView.h"
#import "Common.h"
#import "Dot.h"
#import "Stroke.h"

#import <AVFoundation/AVFoundation.h>

@interface ShowWordViewController () {
    
    __weak IBOutlet ShowWordView *showWordView;
    
    NSInteger partIndex;       //当前部首坐标索引
    NSTimer *timer;
    NSInteger starIndex;       //点亮的星星坐标索引
    
    Vertex *tempLastVertex;
    
    NSMutableArray *tempPoints;
    Scribble    *currentScribble;
    
    AVAudioPlayer *musicPlayer;
    CGFloat       speed;
}

@property (weak, nonatomic) IBOutlet UIImageView *startImageView;
@property (weak, nonatomic) IBOutlet UIImageView *endImageView;

@property (nonatomic, strong) UIBezierPath  *currentPath;           //当前部首痕迹坐标
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;


@end

@implementation ShowWordViewController

#pragma mark Stroke color and size accessor methods

- (void)setStrokeSize:(CGFloat)strokeSize {
    if (strokeSize < 5.0) {
        _strokeSize = 5.0;
    }else {
        _strokeSize = strokeSize;
    }
}

- (void)setScribble:(Scribble *)scribble {
    if (scribble != _scribble) {
        _scribble = scribble;
        
        [_scribble addObserver:self
                    forKeyPath:@"mark"
                       options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                       context:nil];
    }
}

#pragma mark - Cycle life

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = _word.wordColor;
    
    musicPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSBundle mainBundle]URLForResource:[NSString stringWithFormat:@"music/%@.mp3",_word.wordPy] withExtension:nil] error:nil];
    [musicPlayer prepareToPlay];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"SPEED"]) {
        speed   = 25.0;
    }else {
        speed   = 45.0;
    }
    
    [self setStrokeSize:26.0];
    [self setStorkeColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    
    Scribble *scribble = [[Scribble alloc]init];
    [self setScribble:scribble];
    
    [(UIButton *)[self.view viewWithTag:17] setTitleColor:_word.wordColor forState:UIControlStateNormal];
    [(UIButton *)[self.view viewWithTag:17] setTitle:_word.wordPy forState:UIControlStateNormal];

    partIndex = 0;
    starIndex = 0;
    self.currentPath= _word.wordParts[partIndex];
    self.startPoint = [_word.wordPoints[partIndex][0] CGPointValue];
    self.endPoint   = [_word.wordPoints[partIndex][1] CGPointValue];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateWord) userInfo:nil repeats:YES];
    [timer setFireDate:[NSDate distantFuture]];
    
    [self performSelector:@selector(startDrawing) withObject:nil afterDelay:0.5];
}

- (void)startDrawing {
    self.startImageView.hidden = NO;
    self.startImageView.center = _startPoint;
    
    id<Mark> newStroke = [[Stroke alloc]init];
    [newStroke setColor:_storkeColor];
    [newStroke setSize:_strokeSize];
    [self.scribble addMark:newStroke shouldAddToPreviousMark:NO];
    
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyAnimation.path = _currentPath.CGPath;
    
    keyAnimation.removedOnCompletion = NO;
    keyAnimation.fillMode = kCAFillModeForwards;
    keyAnimation.duration = [_word.wordDurations[partIndex] floatValue];
    keyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [_startImageView.layer addAnimation:keyAnimation forKey:@"startAnimation"];
    
    [timer setFireDate:[NSDate date]];
}

- (void)updateWord {
    CGPoint tempMovePoint = [(CALayer *)[_startImageView.layer presentationLayer] position];
    
    Vertex *vertex = [[Vertex alloc]initWithLocation:tempMovePoint];
    [self.scribble addMark:vertex shouldAddToPreviousMark:YES];
    
    CGFloat xDist = (tempMovePoint.x - _endPoint.x);
    CGFloat yDist = (tempMovePoint.y - _endPoint.y);
    CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
    if (distance <= 2) {
        [timer setFireDate:[NSDate distantFuture]];
        
        if (partIndex < _word.wordParts.count - 1) {
            partIndex ++;
            self.currentPath= _word.wordParts[partIndex];
            self.startPoint = [_word.wordPoints[partIndex][0] CGPointValue];
            self.endPoint   =  [_word.wordPoints[partIndex][1] CGPointValue];
            [self startDrawing];
        }else {
            partIndex = 0;
            self.startPoint = [_word.wordPoints[partIndex][0] CGPointValue];
            self.endPoint   =  [_word.wordPoints[partIndex][1] CGPointValue];
            
            [_startImageView.layer removeAnimationForKey:@"startAnimation"];
            [_startImageView setCenter:_startPoint];
            [_endImageView setHidden:NO];
            [_endImageView setCenter:_endPoint];

            [self setStorkeColor:[UIColor whiteColor]];

            currentScribble = [Scribble scribbleWithScribble:_scribble];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_scribble removeObserver:self forKeyPath:@"mark"];
}

#pragma mark Scribble observer method

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([object isKindOfClass:[Scribble class]] && [keyPath isEqualToString:@"mark"] ) {
        id<Mark> mark = change[NSKeyValueChangeNewKey];
        [showWordView setMark:mark];
        [showWordView setNeedsDisplay];
    }
}

#pragma mark - Private Methods

- (IBAction)goback:(id)sender {
    [[CoordinatingController sharedInstance]requestViewChangeByObject:self otherObject:nil];
}

- (IBAction)btnPlayMusic:(id)sender {
    [musicPlayer play];
}


- (IBAction)dragWord:(UIGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.view];
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            id<Mark> newStroke = [[Stroke alloc]init];
            [newStroke setColor:_storkeColor];
            [newStroke setSize:_strokeSize];
            [self.scribble addMark:newStroke shouldAddToPreviousMark:NO];
            
            Stroke *stroke = [currentScribble childMarkAtIndex:partIndex];
            tempPoints = [[stroke children] mutableCopy];
            tempLastVertex = nil;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            Vertex *vertex = [self requestClosePointFrom:point];
            if (vertex == nil) {
                
                break;
            }else {
                [_startImageView setCenter:vertex.location];
                [self.scribble addMark:vertex shouldAddToPreviousMark:YES];

                CGFloat xDist = (vertex.location.x - _endPoint.x);
                CGFloat yDist = (vertex.location.y - _endPoint.y);
                CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
                if (distance <= 10) {
                    Vertex *endVertex = [[Vertex alloc]initWithLocation:_endPoint];
                    [_startImageView setCenter:endVertex.location];
                    [self.scribble addMark:endVertex shouldAddToPreviousMark:YES];
                    
                    tempLastVertex = endVertex;
                    //没写完
                    if (partIndex < _word.wordParts.count - 1) {
                        [Common  common_playShortMusic:@"music_activity.mp3"];

                        partIndex ++;
                        self.startPoint = [_word.wordPoints[partIndex][0] CGPointValue];
                        self.endPoint   =  [_word.wordPoints[partIndex][1] CGPointValue];
                        
                        [_startImageView setCenter:_startPoint];
                        [_endImageView setCenter:_endPoint];
                    //写完了
                    }else {
                        [Common  common_playShortMusic:@"music_finish.mp3"];

                        [(UIImageView *)[self.view viewWithTag:34] setCenter:_endPoint];
                        [(UIImageView *)[self.view viewWithTag:34] setTransform:CGAffineTransformMakeScale(0.001, 0.001)];

                        [UIView animateWithDuration:0.5 animations:^{
                            [(UIImageView *)[self.view viewWithTag:34] setAlpha:1.0];
                            [(UIImageView *)[self.view viewWithTag:34] setCenter:self.view.center];
                            [(UIImageView *)[self.view viewWithTag:34] setTransform:CGAffineTransformMakeScale(8.0, 8.0)];
                        }completion:^(BOOL finished) {
                            [UIView animateWithDuration:0.4 animations:^{
                                starIndex++;
                                UIImageView *starImageView = (UIImageView *)[self.view viewWithTag:30 + starIndex];
                                [(UIImageView *)[self.view viewWithTag:34] setCenter:starImageView.center];
                                [(UIImageView *)[self.view viewWithTag:34] setTransform:CGAffineTransformMakeScale(1.0, 1.0)];

                            } completion:^(BOOL finished) {
                                [(UIImageView *)[self.view viewWithTag:30 + starIndex] setImage:[UIImage imageNamed:@"show_star_light"]];
                                [(UIImageView *)[self.view viewWithTag:34] setAlpha:0.0];

                                if (starIndex == 3) {
                                    [_startImageView setHidden:YES];
                                    [_endImageView setHidden:YES];
                                    
                                    CoordinatingController *coordinater = [CoordinatingController sharedInstance];
                                    [coordinater requestViewChangeByObject:self otherObject:_word];

                                    return;
                                }
                                
                                [_scribble removeObserver:self forKeyPath:@"mark"];
                                self.scribble = [[Scribble alloc]init];
                                [self setStorkeColor:[UIColor whiteColor]];
                                
                                partIndex = 0;
                                self.startPoint = [_word.wordPoints[partIndex][0] CGPointValue];
                                self.endPoint   =  [_word.wordPoints[partIndex][1] CGPointValue];
                                
                                [_startImageView setCenter:_startPoint];
                                [_endImageView setCenter:_endPoint];

                            }];

                        }];

                    }
                }
                
                
                
            }
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
        }
            break;
        default:
            break;
    }
}

- (id<Mark>)requestClosePointFrom:(CGPoint)point {
//    id<Mark> vertex = tempPoints[0];
//    CGPoint center = vertex.location;
//    
//    CGFloat xDist = (center.x - point.x);
//    CGFloat yDist = (center.y - point.y);
//    CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
//    if (distance <= 35) {
//        [tempPoints removeObjectAtIndex:0];
//
//    suǒ xū xìn xī
//    SUǑ XŪ XÌN XĪ 有__皆碑
//        return vertex;
//    }
    if (tempLastVertex) {
        return nil;
    }
    
    for (id <Mark> vertex in tempPoints) {
        CGPoint center = vertex.location;
        
        CGFloat xDist = (center.x - point.x);
        CGFloat yDist = (center.y - point.y);
        CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
        if (distance <= speed) {
            [tempPoints removeObject:vertex];
            return vertex;
        }
    }
    
    return nil;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
