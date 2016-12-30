//
//  EditPostViewController.h
//  Gogo
//
//  Created by Thuong on 11/11/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposePostController.h"
#import "Timeline.h"
@protocol UpdatePostDelegate <NSObject>
-(void)updateComplete;
@end
@interface EditPostViewController : UIViewController <UITableViewDelegate,ELCImagePickerControllerDelegate , UITableViewDataSource , UITextViewDelegate , UINavigationControllerDelegate , UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *postView;
@property int numberGroup;
@property (nonatomic) UITapGestureRecognizer *tapRecognizer;
@property(weak, nonatomic) UIView *activeTextView;
@property NSMutableArray *arrayImage;
@property NSMutableArray *arrayInfoImage;
@property NSMutableArray *arrayURL;
@property NSMutableArray *arrayContentGroup;
@property NSMutableArray *arrayCheckUpload;
@property NSMutableArray *arrayCheckUploadComplete;
@property NSString *idPost;
@property (weak, nonatomic) id <UpdatePostDelegate> delegate;
@property Timeline *detailPost;
@end
