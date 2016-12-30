//
//  ListComment.m
//  Gogo
//
//  Created by Thuong on 9/21/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "ListComment.h"
#import "CommentCell.h"
#import "Comment.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation ListComment

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tableView.delegate = self;
    self.tableView.dataSource= self;
    self.arrayComment = [[NSMutableArray alloc]init];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    self.tableView.scrollEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - tableview
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    if(!cell){
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"CommentCell"
                                                      owner:self options:nil];
        cell = (CommentCell *)[nibs objectAtIndex:0];
    }
    cell.imgCommentAvatar.image = [UIImage imageNamed: @"1"];
    cell.lblCommentName.text = @"Thuong";
    cell.lblCommentTime.text = @"2 ngày trước";
    cell.lblCommentContent.text = @"hay lắm";
    if(indexPath.row == 1){
        cell.imgCommentAvatar.image = [UIImage imageNamed: @"1"];
        cell.lblCommentName.text = @"Thuong";
        cell.lblCommentTime.text = @"2 ngày trước";
        cell.lblCommentContent.text = @"hay lắm d sd fds fda fkda fnkjda fdaj fjdka fkldja klfdja kfjklda jfkldaj fkldaj fklaj flkadj fklasdjf lkajfk ladjslk lkfadj flkadjs klfajd klf";
    }
//    Comment *comment = self.arrayComment[indexPath.row];
//    NSString *linkAvatar = [NSString stringWithFormat:@"%@" , comment.authorAvatar];
//    [cell.imgCommentAvatar sd_setImageWithURL:[NSURL URLWithString:[linkAvatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
//                      placeholderImage:[UIImage imageNamed:@"1"]];
//    cell.lblCommentName.text = comment.authorName;
//    cell.lblCommentTime.text = @"2 ngày trước";
//    cell.lblCommentContent.text = comment.content;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
@end
