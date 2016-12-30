//
//  SearchHotelTableViewCell.h
//  Gogo
//
//  Created by Thuong on 12/29/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchHotelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblHotelName;
@property (weak, nonatomic) IBOutlet UILabel *lblHotelAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblHotelPrice;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
