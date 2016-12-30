//
//  BaseCollectionViewController.m
//  Nushi
//
//  Created by Ta Hoang Minh on 2/11/15.
//  Copyright (c) 2015 Ta Hoang Minh. All rights reserved.
//

#import "BasedCollectionViewController.h"

@implementation BasedCollectionViewController

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.numberRowInSection.allKeys.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger numberRow = [[self.numberRowInSection objectForKey:@(section)]integerValue];
    return numberRow;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
@end