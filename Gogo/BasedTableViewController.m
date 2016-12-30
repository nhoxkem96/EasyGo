//
//  BasedTableViewController.m
//  Speedboy
//
//  Created by Ta Hoang Minh on 6/27/15.
//  Copyright (c) 2015 Ta Hoang Minh. All rights reserved.
//

#import "BasedTableViewController.h"

@interface BasedTableViewController ()

@end

@implementation BasedTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberRow = [[self.numberRowInSection objectForKey:@(section)]integerValue];
    return numberRow;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.numberRowInSection.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void) refreshTableViewIfNoData:(BOOL) hasData text:(NSString *)text;
{
    if (!hasData) {
        self.noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
        if (text == nil) {
            // default one
            self.noDataLabel.text             = @"No data available";
        } else {
            self.noDataLabel.text             = text;
        }
        self.noDataLabel.textColor        = [UIColor blackColor];
        self.noDataLabel.textAlignment    = NSTextAlignmentCenter;
        self.tableView.backgroundView = self.noDataLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.tableView.backgroundView = nil;
        self.noDataLabel = nil;
        self.tableView.separatorStyle = UITableViewCellStyleDefault;
    }
}
@end
