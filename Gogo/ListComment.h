//
//  ListComment.h
//  Gogo
//
//  Created by Thuong on 9/21/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListComment : UITableViewCell<UITableViewDelegate , UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *arrayComment;
@end
