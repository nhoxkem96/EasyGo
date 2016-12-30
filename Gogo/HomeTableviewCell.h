//
//  HomeTableviewCell.h
//  Gogo
//
//  Created by Thuong on 8/24/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "KIImagePager.h"
@protocol HomeTableviewCellDelegate <NSObject>

- (void)didSelectedImage:(id)sender atIndex:(NSUInteger)index atSection:(NSInteger)cellIndex;
-(void)clickBtnComment:(NSInteger) cellIndex;
-(void)usernameTapped:(NSInteger) cellIndex;
-(void)contentTapped:(NSInteger) cellIndex;
-(void)titleTapped:(NSInteger) cellIndex;
-(void)clickBtnLike:(NSInteger) cellIndex id:(id)sender;
-(void)clickBtnFollow:(NSInteger) cellIndex;
-(void)clickBtnShare:(NSInteger)cellIndex;
-(void)clickBtnReport:(NSInteger) cellIndex;
@end

@interface HomeTableviewCell : UITableViewCell <KIImagePagerDelegate, KIImagePagerDataSource>{
    
    
}
@property (weak,nonatomic) IBOutlet KIImagePager *imagePager;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UIView *vUtils;

@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberFollow;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberLike;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberComment;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UIView *vTop;
@property (weak, nonatomic) IBOutlet UIView *vBot;
- (IBAction)clickBtnFollow:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *vStatus;
@property (weak, nonatomic) IBOutlet UIView *vFollow;
@property BOOL isLike;
- (IBAction)clickBtnReport:(id)sender;
@property BOOL isFollow;
@property float timeSlice;
@property (nonatomic, strong) NSMutableArray *imageArray;
- (IBAction)clickBtnComment:(id)sender;
- (IBAction)clickBtnLike:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constantImagePagerRaito;

- (void)displayImages:(NSArray *)imageArray;
- (IBAction)clickBtnShare:(id)sender;
@property NSInteger cellIndex;
@property (weak, nonatomic) id <HomeTableviewCellDelegate> delegate;

@end
