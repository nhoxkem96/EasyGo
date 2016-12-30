//
//  SearchFlightTableViewController.m
//  Gogo
//
//  Created by Thuong on 12/30/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "SearchFlightTableViewController.h"
#import "SearchFlightTableViewCell.h"
#import "FlightModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface SearchFlightTableViewController ()

@end

@implementation SearchFlightTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchFlightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchFlightTableViewCell"];
    FlightModel *flight = self.result[indexPath.row];
    NSString *flightName = [NSString stringWithFormat:@"%@ - %@" , flight.fromPlace,flight.toPlace];
    cell.lblFlightName.text = flightName;
    NSString *departTime = [flight.departTime substringWithRange:NSMakeRange(11, 5)];
    NSString *landingTime = [flight.landingTime substringWithRange:NSMakeRange(11, 5)];
    cell.lblFlightTime.text = [NSString stringWithFormat:@"%@ - %@", departTime , landingTime];
    cell.lblFlightPrice.text = [NSString stringWithFormat:@"%@VND", flight.totalPrice];
    NSString *linkImage;
    if([flight.airlines caseInsensitiveCompare:@"JetStar"] == NSOrderedSame){
        linkImage = @"https://www.ivivu.com/ve-may-bay/content/img/brands/w300/jetstar.png";
    }
    else if([flight.airlines caseInsensitiveCompare:@"VietnamAirlines"] == NSOrderedSame){
        linkImage = @"https://www.ivivu.com/ve-may-bay/content/img/brands/w300/logo_vna.png";
    }
    else{
        linkImage = @"https://www.ivivu.com/ve-may-bay/content/img/brands/w300/vietjetair.png";
    }
    [cell.image sd_setImageWithURL:[NSURL URLWithString:[linkImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                  placeholderImage:[UIImage imageNamed:@"1"]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UIScreen mainScreen].bounds.size.height * 80/568;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.result.count;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
