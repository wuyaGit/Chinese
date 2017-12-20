//
//  WLTableViewController.m
//  Chinese
//
//  Created by Yanggl on 16/1/27.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import "WLTableViewController.h"
#import "CommonAlView.h"
#import "Common.h"
#import "StarModel.h"

@interface WLTableViewController ()
@property (nonatomic, strong) NSArray *wordArray;

@end

@implementation WLTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSArray *array = [NSArray arrayWithObjects:@"土,火,水,口",@"木,川,山,文",@"月,去,风,上",@"飞,于,下,也",@"人,巴,日,有",@"天,少,在,刀",@"目,平,中,门",@"丰,大,田,女",@"未,子,手,西",@"首,白,生,已",@"元,里,兽,完",@"虫,问,鸟,鱼", nil];
    
    
    self.wordArray = (NSArray *)[StarModel allObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.wordArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wlCell" forIndexPath:indexPath];
    
    StarModel *starModel = self.wordArray[indexPath.row];
    ((UILabel *)[cell viewWithTag:5]).text = [NSString stringWithFormat:@"第%@课:%@",@(indexPath.row + 1),starModel.starWords ];
    if (starModel.starLock) {
        ((UILabel *)[cell viewWithTag:5]).textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        for (NSInteger i = 0; i < 5; i++) {
            ((UIImageView *)[cell viewWithTag:11 + i]).image = [UIImage imageNamed:@"show_star_normal"];
        }
    }else {
        ((UILabel *)[cell viewWithTag:5]).textColor = [UIColor blackColor];
        for (NSInteger i = 0; i < starModel.starNum; i++) {
            ((UIImageView *)[cell viewWithTag:11 + i]).image = [UIImage imageNamed:@"show_star_light"];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [Common  common_playShortMusic:@"music_btnclick.m4a"];
    StarModel *starModel = self.wordArray[indexPath.row];
    if (starModel.starLock) {
        CommonAlView *alertView = [[NSBundle mainBundle]loadNibNamed:@"CommonAlView" owner:nil options:nil][0];
        [alertView show:@"完成本课所有书写任务才能进行评测哦。"];

    }else {
        if (self.tableViewDidSelected) {
            NSArray *words = [((StarModel *)_wordArray[indexPath.row]).starWords componentsSeparatedByString:@","];
            self.tableViewDidSelected(words);
        }    
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
