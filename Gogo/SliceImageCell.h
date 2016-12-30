//
//  SliceImageCell.h
//  Gogo
//
//  Created by Thuong on 8/31/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KIImagePager.h"
@protocol SliceImageDelegate <NSObject>

- (void)didSelectedImage:(id)sender atIndex:(NSUInteger)index atCellIndex:(NSInteger)cellIndex;
@end
@interface SliceImageCell : UITableViewCell<KIImagePagerDelegate, KIImagePagerDataSource>{
}
@property IBOutlet KIImagePager *imagePager;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property NSInteger cellIndex;
@property float timeSlice;
- (void)displayImages:(NSArray *)imageArray;
@property (weak, nonatomic) id <SliceImageDelegate> delegate;
@end
