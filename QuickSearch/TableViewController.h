//
//  TableViewController.h
//  QuickSearch
//
//  Created by 融通汇信 on 15/8/31.
//  Copyright (c) 2015年 融通汇信. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IMQuickSearch;

@interface TableViewController : UITableViewController
@property (nonatomic, strong) IMQuickSearch *QuickSearch;
@property (nonatomic, strong) NSMutableArray *questionArr;
@property (nonatomic, strong) NSArray *FilteredResults;
@end
