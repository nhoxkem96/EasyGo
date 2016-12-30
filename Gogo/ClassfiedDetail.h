//
//  ClassfiedDetail.h
//  Gogo
//
//  Created by Thuong on 10/26/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Classfieds.h"
@interface ClassfiedDetail : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblPoster;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property Classfieds *classfied;
@property NSString *string;
@end
