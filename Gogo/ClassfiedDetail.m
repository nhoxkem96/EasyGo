//
//  ClassfiedDetail.m
//  Gogo
//
//  Created by Thuong on 10/26/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "ClassfiedDetail.h"
#import "Utils.h"
@implementation ClassfiedDetail
-(void)awakeFromNib{
    [super awakeFromNib];
    NSLog(@"%@" , _classfied);
    [_lblLocation setFont: [_lblLocation.font fontWithSize:[Utils fontSizeSmall]]];
    [_lblTitle setFont: [_lblTitle.font fontWithSize:[Utils fontSizeNormal]]];
    [_lblPoster setFont: [_lblPoster.font fontWithSize:[Utils fontSizeSmall]]];
    [_lblContent setFont: [_lblContent.font fontWithSize:[Utils fontSizeNormal]]];

    
}

@end
