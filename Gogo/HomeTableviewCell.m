//
//  HomeTableviewCell.m
//  Gogo
//
//  Created by Thuong on 8/24/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "HomeTableviewCell.h"
#import "Utils.h"
@implementation HomeTableviewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    
    //    self.contentView.userInteractionEnabled = NO;
    self.isLike = NO;
    self.isFollow = NO;
    self.vFollow.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.vFollow.layer.borderWidth = 1.0f;
    [_imagePager layoutIfNeeded];
    [_imagePager setNeedsDisplay];
    _imagePager.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    _imagePager.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];

    _imagePager.delegate = self;
    _imagePager.dataSource = self;
    
    UITapGestureRecognizer *tapGestureRecognizerUsername = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(usernameTapped)];
    tapGestureRecognizerUsername.numberOfTapsRequired = 1;
    [_lblUserName addGestureRecognizer:tapGestureRecognizerUsername];
    _lblUserName.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizerContent = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTapped)];
    tapGestureRecognizerContent.numberOfTapsRequired = 1;
    [_lblContent addGestureRecognizer:tapGestureRecognizerContent];
    _lblContent.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizerTitle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleTapped)];
    tapGestureRecognizerTitle.numberOfTapsRequired = 1;
    [_lblTitle addGestureRecognizer:tapGestureRecognizerTitle];
    _lblTitle.userInteractionEnabled = YES;
    [self setFont];
}
-(void)setFont{
    [_lblLocation setFont: [_lblLocation.font fontWithSize:[Utils fontSizeSmall]]];
    NSLog(@"%lu" , (unsigned long)[Utils fontSizeNormal]);
    [_lblTime setFont: [_lblTime.font fontWithSize:[Utils fontSizeSmall]]];
    [_lblUserName setFont: [_lblUserName.font fontWithSize:[Utils fontSizeBig]]];
    [_lblTitle setFont: [_lblTitle.font fontWithSize:[Utils fontSizeNormal]]];
    [_lblContent setFont: [_lblContent.font fontWithSize:[Utils fontSizeNormal]]];
    
    [_lblNumberLike setFont: [_lblNumberLike.font fontWithSize:[Utils fontSizeSmall]]];
    [_lblNumberComment setFont: [_lblNumberComment.font fontWithSize:[Utils fontSizeSmall]]];
}
-(void)titleTapped{
    if (self.delegate && [self.delegate respondsToSelector:@selector(titleTapped:)]) {
        [self.delegate titleTapped:_cellIndex];
        
    }
}
-(void)usernameTapped{
    if (self.delegate && [self.delegate respondsToSelector:@selector(usernameTapped:)]) {
        [self.delegate usernameTapped:_cellIndex];
        
    }
}
-(void)contentTapped{
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentTapped:)]) {
        [self.delegate contentTapped:_cellIndex];
        
    }
}
#pragma mark - KIImagePager DataSource
- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    return self.imageArray;
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager *)pager
{
    return UIViewContentModeScaleAspectFit;
}

#pragma mark - KIImagePager Delegate
- (void) imagePager:(KIImagePager *)imagePager didScrollToIndex:(NSUInteger)index
{
    //    NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
}

- (void) imagePager:(KIImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedImage:atIndex:atSection:)]) {
        [self.delegate didSelectedImage:self atIndex:index atSection:_cellIndex];
        
    }
    
    //    NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
}

- (IBAction)clickBtnComment:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickBtnComment:)]) {
        [self.delegate clickBtnComment:_cellIndex];
    }
}

- (IBAction)clickBtnLike:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickBtnLike:id:)]) {
        [self.delegate clickBtnLike:_cellIndex id:sender];
    }
}

- (IBAction)clickBtnReport:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickBtnReport:)]) {
        [self.delegate clickBtnReport:_cellIndex];
    }
}

- (void)displayImages:(NSMutableArray *)imageArray;
{
    self.imageArray = imageArray;
    
    [_imagePager reloadData];
}

- (IBAction)clickBtnShare:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickBtnShare:)]) {
        [self.delegate clickBtnShare:_cellIndex];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews;
{
    [super layoutSubviews];
    [self.imgAvatar layoutIfNeeded];
    [self.vBot layoutIfNeeded];
    CALayer *TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(15.0f, 0.0f, self.vBot.frame.size.width - 30,0.5f);
    TopBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.vBot.layer addSublayer:TopBorder];
    [[self.btnFollow layer] setBorderWidth:1.0f];
    [[self.lblNumberFollow layer] setBorderWidth:1.0f];
    [[self.lblNumberFollow layer] setBorderColor:[UIColor darkGrayColor].CGColor];
    [self.lblNumberFollow layer].cornerRadius = 3;
    self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.height /2 ;
    self.imgAvatar.layer.masksToBounds = YES;
    
    [_imagePager layoutIfNeeded];
    [_imagePager setNeedsDisplay];
    _imagePager.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    _imagePager.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _imagePager.slideshowShouldCallScrollToDelegate = YES;
    _imagePager.slideshowTimeInterval = self.timeSlice;
    [_imagePager layoutIfNeeded];
    [_imagePager setNeedsDisplay];
    [self.imgAvatar layoutIfNeeded];
}
- (IBAction)clickBtnFollow:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickBtnFollow:)]) {
        [self.delegate clickBtnFollow:_cellIndex];
    }
}

@end
