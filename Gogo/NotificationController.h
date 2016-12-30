//
//  NotificationController.h
//  Gogo
//
//  Created by Thuong on 8/28/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationTableViewCell.h"
@interface NotificationController : UIViewController<UITableViewDelegate , UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *results;
@end
