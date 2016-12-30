//
//  UserTagViewController.h
//  Gogo
//
//  Created by Thuong on 11/16/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASJTagsView.h"
@protocol UserTagDelegate <NSObject>

- (void)clickBtnRightBarButton:(NSArray *)arrayTag;
@end

@interface UserTagViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)clickBtnRightButton:(id)sender;
@property (weak, nonatomic) id <UserTagDelegate> delegate;
@end
