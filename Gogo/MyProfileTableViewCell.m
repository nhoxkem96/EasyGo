//
//  MyProfileTableViewCell.m
//  Gogo
//
//  Created by Thuong on 9/8/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "MyProfileTableViewCell.h"

@implementation MyProfileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.userInteractionEnabled = NO;
    
    _imagePager.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    _imagePager.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    _imagePager.slideshowShouldCallScrollToDelegate = YES;
//    _imagePager.slideshowTimeInterval = 2.0f;
    self.imagePager.delegate = self;
    self.imagePager.dataSource = self;
    UITapGestureRecognizer *tapGestureRecognizerContent = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTapped)];
    tapGestureRecognizerContent.numberOfTapsRequired = 1;
    [_lblContent addGestureRecognizer:tapGestureRecognizerContent];
    _lblContent.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizerTitle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleTapped)];
    tapGestureRecognizerTitle.numberOfTapsRequired = 1;
    [_lblTitle addGestureRecognizer:tapGestureRecognizerContent];
    _lblTitle.userInteractionEnabled = YES;
    self.imgAvatar.layer.borderWidth = 1.0f;
    self.imgAvatar.layer.borderColor = [UIColor blackColor].CGColor;
}
#pragma mark - KIImagePager DataSource
- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    return self.imageArray;
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager *)pager
{
    return UIViewContentModeScaleAspectFill;
}

- (IBAction)clickBtnLike:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickBtnLike:id:)]) {
        [self.delegate clickBtnLike:_cellIndex id:sender];
    }
}
- (IBAction)clickBtnComment:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickBtnComment:)]) {
        [self.delegate clickBtnComment:_cellIndex];
    }
}
-(void)contentTapped{
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentTapped:)]) {
        [self.delegate contentTapped:_cellIndex];
        
    }
}
-(void)titleTapped{
    if (self.delegate && [self.delegate respondsToSelector:@selector(titleTapped:)]) {
        [self.delegate titleTapped:_cellIndex];
        
    }
}
- (void)displayImages:(NSMutableArray *)imageArray;
{
    self.imageArray = imageArray;
    
    [self.imagePager reloadData];
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
    
    self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.height / 2;
    self.imgAvatar.layer.masksToBounds = YES;
}

@end
