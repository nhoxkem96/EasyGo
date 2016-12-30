//
//  HomeViewController.h
//  Gogo
//
//  Created by Thuong on 8/24/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "Timeline.h"
#import "Object.h"
@interface HomeViewController : UIViewController<UITableViewDelegate ,UITableViewDataSource , UISearchBarDelegate,UISearchDisplayDelegate  , UITabBarControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *homeTableview;
@property(strong,nonatomic) NSArray *arr;
@property(strong,nonatomic) Timeline *timeline;
@property(strong,nonatomic) Object *object;
@property(nonatomic,retain) NSMutableArray *results;
@property NSMutableArray *arrayImageRandom;
@property(strong,nonatomic) UIRefreshControl *refreshControl;
@property UISearchBar *searchBar;
-(void)getData;
-(void)resetData;
-(void)login;
@end
