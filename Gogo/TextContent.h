//
//  TextContent.h
//  Gogo
//
//  Created by Thuong on 9/18/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextContent : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblContent;

- (void)displayString:(NSString *)content;

@end
