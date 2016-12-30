//
//  TextCell.h
//  Demo
//
//  Created by Trung Đức on 8/27/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;


- (void)displayString:(NSString *)title;

@end
