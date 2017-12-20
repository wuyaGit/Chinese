//
//  WordViewController.m
//  Chinese
//
//  Created by Yanggl on 16/1/12.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import "WordViewController.h"
#import "CoordinatingController.h"
#import "WLTableViewController.h"
#import "ContentView.h"
#import "WordModel.h"
#import "CommonAlView.h"
#import "Common.h"

#import "AppDelegate.h"

@interface WordViewController ()<UIScrollViewDelegate> {
    
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIPageControl *pageControl;
    
}

@property (nonatomic, strong) UIPopoverController *popoverController;

@end

@implementation WordViewController

#pragma mark - Cycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [scrollView setContentSize:CGSizeMake(4 * CGRectGetWidth(self.view.frame), 0)];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"MUSIC"] ) {
        [self.musicPlayer play];
    }else {
        [self.musicPlayer pause];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateAllCards) name:@"UpdateAllWords" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateSettingMusic) name:@"UpdateSettingMusic" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateSettingReset) name:@"UpdateSettingReset" object:nil];

    CoordinatingController *coordinater = [CoordinatingController sharedInstance];
    [coordinater initialize:self];//本页面为活动页面
    
    [self updateAllCards];

    self.musicPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"music/music_background.mp3" withExtension:nil] error:nil];
    [self.musicPlayer prepareToPlay];
    [self.musicPlayer setVolume:1.0];
    [self.musicPlayer setNumberOfLoops:-1];      //一直循环
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"MUSIC"] ) {
        [self.musicPlayer play];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UpdateAllWords" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UpdateSettingMusic" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UpdateSettingReset" object:nil];
}

- (void)loadContentViewWithImages:(NSArray *)images {
    for (UIView *view in scrollView.subviews) {
        if ([view isKindOfClass:[ContentView class]]) {
            [view removeFromSuperview];
        }
    }
    for (int i = 0; i < images.count; i++) {
        ContentView *contentView = [[ContentView alloc] initWithFrame:
                                    CGRectMake(i * CGRectGetWidth(self.view.frame), 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) images:images[i]];
        
        [scrollView addSubview:contentView];
    }
    
}

- (void)updateAllCards {
    RLMResults *wordArray = [WordModel allObjects];
    
    NSMutableArray *mArray = [NSMutableArray array];
    for (NSInteger i = 0 ; i < wordArray.count / 12; i++) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger j = i * 12; j < i * 12 + 12; j++) {
            [array addObject:wordArray[j]];
        }
        [mArray addObject:array];
    }
    
    [self loadContentViewWithImages:mArray];
}
/**
 *  设置音乐
 */
- (void)updateSettingMusic {
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"MUSIC"] ) {
        [self.musicPlayer play];
    }else {
        [self.musicPlayer pause];
    }
}
/**
 *  重设系统
 */
- (void)updateSettingReset {
    [self.musicPlayer play];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    [appDelegate resetSystem];
    
    [self updateAllCards];
}

- (IBAction)goBack:(id)sender {
    [Common  common_playShortMusic:@"music_btnclick.m4a"];

    CommonAlView *alertView = [[NSBundle mainBundle]loadNibNamed:@"CommonAlView" owner:nil options:nil][1];
    [alertView showSettingView];

}

- (IBAction)btnShowWordlist:(id)sender {
    [Common  common_playShortMusic:@"music_btnclick.m4a"];
    WLTableViewController *tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"wlTVC"];
    __block UIPopoverController *popViewController = [[UIPopoverController alloc]initWithContentViewController:tableViewController];

    tableViewController.tableViewDidSelected = ^(NSArray *words) {
        NSLog(@"%@", words);
        
        NSMutableArray *wArray = [[NSMutableArray alloc]init];
        for (NSString *w in words) {
            WordModel *word = [[WordModel objectsWhere:[NSString stringWithFormat:@"wordName == '%@' ", w]]firstObject];
            [wArray addObject:word];
        }
        
        [popViewController dismissPopoverAnimated:YES];
        
        CoordinatingController *coordinater = [CoordinatingController sharedInstance];
        [coordinater requestViewChangeByObject:self otherObject:wArray];
    };
    
    popViewController.popoverContentSize = CGSizeMake(420.0, self.view.bounds.size.height);
    [popViewController presentPopoverFromRect:((UIView *)sender).bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
//    [popViewController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    self.popoverController = popViewController;
}


#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrView {
    pageControl.currentPage = scrView.contentOffset.x / self.view.frame.size.width;
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
