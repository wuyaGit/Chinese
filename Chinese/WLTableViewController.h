//
//  WLTableViewController.h
//  Chinese
//
//  Created by Yanggl on 16/1/27.
//  Copyright © 2016年 yanggl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TableViewDidSelected)(NSArray* words);

@interface WLTableViewController : UITableViewController

@property (nonatomic, copy) TableViewDidSelected  tableViewDidSelected;

@end
