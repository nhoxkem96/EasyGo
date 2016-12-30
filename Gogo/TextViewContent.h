//
//  TextViewContent.h
//  Gogo
//
//  Created by Thuong on 9/14/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostView.h"
@protocol TextViewContentDelegate <NSObject>

- (void)txtViewDidChange:(id)sender;
@end
@interface TextViewContent : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *txtContent;
@property (weak, nonatomic) id <TextViewContentDelegate> delegate;
@property NSString *content;
@end
