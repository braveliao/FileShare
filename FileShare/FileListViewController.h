//
//  FileListViewController.h
//  FileShare
//
//  Created by liaoyong on 12/14/13.
//  Copyright (c) 2013 redcdn.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *_tableView;

@end
