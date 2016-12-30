//
//  DetailView.m
//  Gogo
//
//  Created by Thuong on 9/10/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "DetailView.h"
#import "Object.h"
#import "Category.h"
#import "AFNetworking.h"
#import "Utils.h"
@implementation DetailView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self getData];
    _btnCategory.layer.borderWidth = 1;
    _btnCategory.layer.borderColor = [[UIColor clearColor] CGColor];
    _btnCategory.layer.cornerRadius = 5;
    self.contentView.layer.cornerRadius = 3;
    self.arrayCategory = [[NSMutableArray alloc] init];
    NSMutableArray* bandArray = [[NSMutableArray alloc] init];
    
    // add some sample data
    
    // bind yourTextField to DownPicker
    [_txtLocation setFont: [_txtLocation.font fontWithSize:[Utils fontSizeBig]]];
    [_btnCategory.titleLabel setFont: [_btnCategory.titleLabel.font fontWithSize:[Utils fontSizeBig]]];
}
-(void)getData{
    NSURL *URL = [NSURL URLWithString:@"http:easygo.com.vn/api/categories"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        Object *object = [[Object alloc]init];
        object.code = [[responseObject objectForKey:@"code"] integerValue];
        object.result =  [responseObject objectForKey:@"result"];
        if(object.code == 1){
            NSArray *array = [[NSArray alloc]init];
            array = [MTLJSONAdapter modelsOfClass:[Category class] fromJSONArray:object.result error:nil];
            for(Category *category in array){
                [self.arrayCategory addObject:category.name];
            }
            NSLog(@"%@" , self.arrayCategory);
//            self.downPicker = [[DownPicker alloc] initWithTextField:self.txtCategory withData:self.arrayCategory];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
- (IBAction)clickBtnCategory:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :self.arrayCategory :nil :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    [self rel];
    NSLog(@"%@", _btnCategory.titleLabel.text);
}

-(void)rel{
    //    [dropDown release];
    dropDown = nil;
}
@end
