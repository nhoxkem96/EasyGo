//
//  ViewController.h
//  Demo
//
//  Created by Trung Đức on 8/27/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "HeaderCell.h"
#import "TextCell.h"
#import "CollectionCell.h"
#import "DetailCell.h"
#import "BottomCell.h"
#import "SliceImageCell.h"
#import "TextContent.h"
#import "Timeline.h"
#import "ImageGroup.h"
@protocol PostDetailDelegate <NSObject>
-(void)clickBtnLikePostDetail:(NSInteger)cellIndex;
-(void)commentPostDetail:(NSInteger)cellIndex;
-(void)deletePost:(NSInteger)cellIndex;
-(void)updatePost:(NSInteger)cellIndex post:(Timeline *)post;
@end
@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource >
- (IBAction)clickRightBarButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *arrayImage;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberFollow;
@property NSString *idPost;
@property NSMutableArray *arrayComment;
@property Timeline *detailPost;
@property NSString *commentID;
@property NSInteger cellIndex;
@property BOOL isClickComment;
@property (weak, nonatomic) id <PostDetailDelegate> delegate;
@end

