//
//  SearchFlightTableViewCell.h
//  Gogo
//
//  Created by Thuong on 12/30/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchFlightTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *lblFlightName;
@property (weak, nonatomic) IBOutlet UILabel *lblFlightTime;
@property (weak, nonatomic) IBOutlet UILabel *lblFlightPrice;
@property (weak, nonatomic) IBOutlet UIView *vFlightContent;

@end
