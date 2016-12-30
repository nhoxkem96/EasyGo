//
//  ClassfiedViewController.h
//  Gogo
//
//  Created by Thuong on 10/26/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassfiedViewController : UIViewController<UITableViewDelegate,UISearchBarDelegate , UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)clickBtnAdd:(id)sender;
@property  UISearchBar* searchBar;
@end
