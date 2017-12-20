//
//  TestWordViewController.m
//  Chinese
//
//  Created by Yanggl on 16/1/12.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import "TestWordViewController.h"
#import "CoordinatingController.h"
#import "ShowWordView.h"
#import "Scribble.h"
#import "Stroke.h"
#import "Dot.h"
#import "Common.h"
#import "StarModel.h"
#import "CommonAlView.h"

#import <TesseractOCR/TesseractOCR.h>
#import <AVFoundation/AVFoundation.h>

@interface TestWordViewController () {
    
    __weak IBOutlet UILabel *lblWords;
    __weak IBOutlet ShowWordView *showWordView;
    __weak IBOutlet NSLayoutConstraint *showViewLeadingConstraint;
    
    NSInteger wdIndex;
    NSInteger ciIndex;
    NSInteger starIndex;
    
    AVAudioPlayer *musicPlayer;
}

@property (nonatomic, strong) Scribble *scribble;
@property (nonatomic, strong) UIColor *storkeColor;
@property (nonatomic, assign) CGFloat strokeSize;

@property (nonatomic, assign) CGPoint startPoint;
@end

@implementation TestWordViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    showWordView.layer.shouldRasterize = YES;
    
    //初始化画板
    Scribble *scribble = [[Scribble alloc]init];
    [self setScribble:scribble];
    [self setStrokeSize:21.0];
    [self setStorkeColor:[UIColor whiteColor]];

    //评测时words不为空
    if (_words) {
        [self.view viewWithTag:11].hidden = YES;
        
        UIColor *wordColor = [Common common_colorFromRGB:@"2F3239"];
        self.view.backgroundColor = wordColor;
        
        [(UIButton *)[self.view viewWithTag:21] setTitleColor:wordColor forState:UIControlStateNormal];
        [(UIButton *)[self.view viewWithTag:22] setTitleColor:wordColor forState:UIControlStateNormal];
        [(UIButton *)[self.view viewWithTag:23] setTitleColor:wordColor forState:UIControlStateNormal];
        
        starIndex = 1;
        wdIndex = arc4random() % _words.count;
        _word = _words[wdIndex];
        ciIndex = arc4random() % _word.wordCis.count;
        [self drawLabel];

        [_words removeObjectAtIndex:wdIndex];
    }else {
        self.view.backgroundColor = _word.wordColor;
        
        [(UIButton *)[self.view viewWithTag:21] setTitleColor:_word.wordColor forState:UIControlStateNormal];
        [(UIButton *)[self.view viewWithTag:22] setTitleColor:_word.wordColor forState:UIControlStateNormal];
        [(UIButton *)[self.view viewWithTag:23] setTitleColor:_word.wordColor forState:UIControlStateNormal];
        
        ciIndex = 0;
        starIndex = 0;
        [self drawLabel];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_scribble removeObserver:self forKeyPath:@"mark"];
}

#pragma mark - Private Methods
/**
 *  加载词和田字格视图
 */
- (void)drawLabel {
    CGFloat centerX = [Common common_centerXWithType:[_word.wordCiType[ciIndex] integerValue]];
    showViewLeadingConstraint.constant = centerX - 157.0;
    
    lblWords.text = _word.wordCis[ciIndex];
    [(UIButton *)[self.view viewWithTag:21] setTitle:_word.wordCiPys[ciIndex] forState:UIControlStateNormal];
    
    musicPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSBundle mainBundle]URLForResource:[NSString stringWithFormat:@"music/%@.mp3",_word.wordCiPys[ciIndex]] withExtension:nil] error:nil];
}
/**
 *  返回：直接返回到首页
 *
 *  @param sender 传参
 */
- (IBAction)goback:(id)sender {
    [[CoordinatingController sharedInstance] requestViewChangeByObject:self otherObject:nil];
}

- (IBAction)next:(id)sender {
    [Common  common_playShortMusic:@"music_btnclick.m4a"];
    //1，2
    G8Tesseract *tesseract = [[G8Tesseract alloc]initWithLanguage:@"chi_sim"];
    
    //3
    tesseract.engineMode = G8OCREngineModeTesseractOnly;
    
    //4
//    tesseract.pageSegmentationMode = G8PageSegmentationModeAuto;
    
    //5
    tesseract.maximumRecognitionTime = 60.0;
    
    //6
    tesseract.image = [self getViewImage].g8_blackAndWhite;
    
    //7
    if ([tesseract recognize]) {
        NSLog(@"%@",tesseract.recognizedText);
        if (tesseract.recognizedText.length - [tesseract.recognizedText stringByReplacingOccurrencesOfString:_word.wordName withString:@""].length == 1) {
            [Common  common_playShortMusic:@"music_finish.mp3"];
            
            [(UIImageView *)[self.view viewWithTag:16] setCenter:showWordView.center];
            [(UIImageView *)[self.view viewWithTag:16] setTransform:CGAffineTransformMakeScale(0.001, 0.001)];
            
            [UIView animateWithDuration:0.5 animations:^{
                [(UIImageView *)[self.view viewWithTag:16] setAlpha:1.0];
                [(UIImageView *)[self.view viewWithTag:16] setCenter:self.view.center];
                [(UIImageView *)[self.view viewWithTag:16] setTransform:CGAffineTransformMakeScale(8.0, 8.0)];
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.4 animations:^{
                    starIndex++;
                    UIImageView *starImageView = (UIImageView *)[self.view viewWithTag:10 + starIndex];
                    [(UIImageView *)[self.view viewWithTag:16] setCenter:starImageView.center];
                    [(UIImageView *)[self.view viewWithTag:16] setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
                    
                } completion:^(BOOL finished) {
                    [(UIImageView *)[self.view viewWithTag:10 + starIndex] setImage:[UIImage imageNamed:@"show_star_light"]];
                    [(UIImageView *)[self.view viewWithTag:16] setAlpha:0.0];
                    
                    if (_words) {
                        if (_words.count == 0) {            //评测全部练习完毕
                            RLMRealm *realm = [RLMRealm defaultRealm];
                            [realm transactionWithBlock:^ {
                                for (StarModel *star in [StarModel objectsInRealm:realm where:[NSString stringWithFormat:@"starWords contains '%@' ",_word.wordName]]) {
                                    star.starNum++;
                                    if (star.starNum == 5) {
                                        NSLog(@"解锁下一课！");
                                        
                                        StarModel *sM = [[StarModel objectsInRealm:realm where:[NSString stringWithFormat:@"starIndex == %d ",star.starIndex+1]]firstObject];
                                        for (NSString *word in [sM.starWords componentsSeparatedByString:@","]) {
                                            ((WordModel *)[[WordModel objectsWhere:[NSString stringWithFormat:@"wordName == '%@' ", word]]firstObject]).wordClock = NO;
                                        }
                                        
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateAllWords" object:nil];
                                        
                                        CommonAlView *alertView = [[NSBundle mainBundle]loadNibNamed:@"CommonAlView" owner:nil options:nil][0];
                                        [alertView show:@"恭喜你成功解锁下一课！"];
                                        alertView.didUpSide = ^ {
                                            [self goback:nil];
                                        };
                                    }
                                }
                            }];
                            
                            [Common  common_playShortMusic:@"music_complete.mp3"];

                            CommonAlView *alertView = [[NSBundle mainBundle]loadNibNamed:@"CommonAlView" owner:nil options:nil][0];
                            [alertView show:@"你已经完成本次评测，获得一颗星。获得五颗星后可解锁下一课哦！"];
                            alertView.didUpSide = ^ {
                                [self goback:nil];
                            };
                            return ;
                        }else {
                            wdIndex = arc4random() % _words.count;
                            _word = _words[wdIndex];
                            
                            ciIndex = arc4random() % _word.wordCis.count;
                            [self drawLabel];
                            
                            [_words removeObjectAtIndex:wdIndex];
                        }
                    }else {
                        ciIndex++;
                        if (ciIndex == 5) {                 //全部练习完毕
                            RLMRealm *realm = [RLMRealm defaultRealm];                            
                            [realm transactionWithBlock:^ {
                                for (StarModel *star in [StarModel objectsInRealm:realm where:[NSString stringWithFormat:@"starWords contains '%@' ",_word.wordName]]) {
                                    star.starCompleted = [star.starCompleted stringByReplacingOccurrencesOfString:_word.wordName withString:@""];
                                    star.starCompleted = [NSString stringWithFormat:@"%@%@",star.starCompleted, _word.wordName];
                                    if (star.starCompleted.length == 4) {
                                        star.starLock = NO;
                                    }
                                }
                            }];
                            
                            [Common  common_playShortMusic:@"music_complete.mp3"];

                            CommonAlView *alertView = [[NSBundle mainBundle]loadNibNamed:@"CommonAlView" owner:nil options:nil][0];
                            [alertView show:[NSString stringWithFormat:@"已经完成\"%@\"字的书写任务，要再接再厉哦。",_word.wordName]];
                            alertView.didUpSide = ^ {
                                [self goback:nil];
                            };

                            return;
                        }else {
                            
                            [self drawLabel];
                        }
                    }
                    
                }];
            }];

            
        }else {
            [Common  common_playShortMusic:@"music_bounce.mp3"];
            CommonAlView *alertView = [[NSBundle mainBundle]loadNibNamed:@"CommonAlView" owner:nil options:nil][0];
            [alertView show:@"要书写规范哦!"];
        }
        
        [_scribble removeObserver:self forKeyPath:@"mark"];
        self.scribble = [[Scribble alloc]init];
    }
    
}

- (IBAction)btnPlayMusic:(id)sender {
    [musicPlayer play];
}


- (IBAction)undo:(id)sender {
    [Common  common_playShortMusic:@"music_btnclick.m4a"];
    [self.undoManager undo];
}


- (UIImage *)getViewImage {
    CGSize scaledSize = showWordView.frame.size;
    
    UIGraphicsBeginImageContext(scaledSize);
    [showWordView drawRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark Scribble observer method

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([object isKindOfClass:[Scribble class]] && [keyPath isEqualToString:@"mark"] ) {
        id<Mark> mark = change[NSKeyValueChangeNewKey];
        [showWordView setMark:mark];
        [showWordView setNeedsDisplay];
    }
}

#pragma mark - Touch Event Handlers

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _startPoint = [[touches anyObject] locationInView:showWordView];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint lastPoint = [[touches anyObject]previousLocationInView:showWordView];
    
    //如果手指拖动，向涂鸦添加一个线条(上一次触摸是第一次触摸，创建Stroke附加到scribble根节点上)
    if (CGPointEqualToPoint(lastPoint, _startPoint)) {
        id<Mark> newStroke = [[Stroke alloc]init];
        [newStroke setColor:_storkeColor];
        [newStroke setSize:_strokeSize];
        [newStroke setStrokeLineGap:kCGLineCapRound];
//        [self.scribble addMark:newStroke shouldAddToPreviousMark:NO];

        //取得用于绘图的NSinvocation，并为绘图命令设置新的参数
        NSInvocation *drawInvocation = [self drawScribbleInvocation];
        [drawInvocation setArgument:&newStroke atIndex:2];
    
        //取得用于撤销绘图的NSinvocation，并为撤销绘图命令设置新的参数
        NSInvocation *undrawInvocation = [self undrawScribbleInvocation];
        [undrawInvocation setArgument:&newStroke atIndex:2];
    
        //执行带有撤销命令的绘图命令
        [self executeInvocation:drawInvocation withUndoInvocation:undrawInvocation];
    }
    
    //把当前触摸作为顶点添加到临时线条
    CGPoint thisPoint = [[touches anyObject]locationInView:showWordView];
    Vertex *vertex = [[Vertex alloc]initWithLocation:thisPoint];
    
    [self.scribble addMark:vertex shouldAddToPreviousMark:YES];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint lastPoint = [[touches anyObject]previousLocationInView:showWordView];
    CGPoint thisPoint = [[touches anyObject]locationInView:showWordView];
    
    //如果触摸未移动，向组合Stroke组合体添加一个点，否则把它作为最后一个顶点添加到临时线条
    if (CGPointEqualToPoint(lastPoint, thisPoint)) {
        Dot *singleDot = [[Dot alloc]initWithLocation:thisPoint];
        [singleDot setColor:_storkeColor];
        [singleDot setSize:_strokeSize];
        
        //取得用于绘图的NSinvocation，并为绘图命令设置新的参数
        NSInvocation *drawInvocation = [self drawScribbleInvocation];
        [drawInvocation setArgument:&singleDot atIndex:2];
        
        //取得用于撤销绘图的NSinvocation，并为撤销绘图命令设置新的参数
        NSInvocation *undrawInvocation = [self undrawScribbleInvocation];
        [undrawInvocation setArgument:&singleDot atIndex:2];
        
        //执行带有撤销命令的绘图命令
        [self executeInvocation:drawInvocation withUndoInvocation:undrawInvocation];
    }
    
    self.startPoint = CGPointZero;
    
    //如果是线条的最后一个点不用画，因为看不出有什么区别
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //其实不必在此处重置起点，但要以防万一
    self.startPoint = CGPointZero;
}

#pragma mark Draw Scribble Invocation Generation Methods

- (NSInvocation *)drawScribbleInvocation {
    NSMethodSignature *executeMethodSignature = [_scribble methodSignatureForSelector:@selector(addMark:shouldAddToPreviousMark:)];
    NSInvocation *drawInvocation = [NSInvocation invocationWithMethodSignature:executeMethodSignature];
    [drawInvocation setTarget:_scribble];
    [drawInvocation setSelector:@selector(addMark:shouldAddToPreviousMark:)];
    
    BOOL attachToPreviousMark = NO;
    [drawInvocation setArgument:&attachToPreviousMark atIndex:3];
    
    return drawInvocation;
}

- (NSInvocation *)undrawScribbleInvocation {
    NSMethodSignature *unexecuteMethodSignature = [_scribble methodSignatureForSelector:@selector(removeMark:)];
    NSInvocation *drawInvocation = [NSInvocation invocationWithMethodSignature:unexecuteMethodSignature];
    [drawInvocation setTarget:_scribble];
    [drawInvocation setSelector:@selector(removeMark:)];
    
    return drawInvocation;
}

#pragma mark Draw Scribble Command Methods 注册到NSUndoManager

- (void)executeInvocation:(NSInvocation *)invocation
       withUndoInvocation:(NSInvocation *)undoInvocation {
    [invocation retainArguments];
    
    [[self.undoManager prepareWithInvocationTarget:self]
     unexecuteInvocation:undoInvocation
     withRedoInvocation:invocation];
    
    [invocation invoke];
}

- (void)unexecuteInvocation:(NSInvocation *)invocation
         withRedoInvocation:(NSInvocation *)redoInvocation {
    [[self.undoManager prepareWithInvocationTarget:self]
     executeInvocation:redoInvocation
     withUndoInvocation:invocation];
    
    [invocation invoke];
}


@end
