//
//  SearchViewController.h
//  Gogo
//
//  Created by Thuong on 8/27/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchViewController : UIViewController<UISearchBarDelegate,UISearchDisplayDelegate , UITableViewDelegate , UITableViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource >

- (IBAction)changeSegment:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property  UISearchBar* searchBar;
@property NSMutableArray *results;
@property NSMutableArray *arrayHotel;
@property (weak, nonatomic) IBOutlet UILabel *lblWeatherTime;
@property (weak, nonatomic) IBOutlet UILabel *lblWeatherLocation;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblWeatherTemp;
@property (nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (weak, nonatomic) IBOutlet UIView *vWeather;
-(void)setEditSearchBar;
@end
