//
//  SearchFlightTableViewController.h
//  Gogo
//
//  Created by Thuong on 12/30/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchFlightTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSArray *result;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, retain) NSArray *result;
@end
