//
//  CollectionCell.m
//  Demo
//
//  Created by Trung Đức on 8/27/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import "CollectionCell.h"
#import "ImageItem.h"

@implementation CollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.pagingEnabled = YES;
    self.imageArray = [[NSMutableArray alloc] init];
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ImageItem class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ImageItem class])];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - CollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    ImageItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ImageItem class]) forIndexPath:indexPath];
    
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ImageItem class]) owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    
    return cell;
}

#pragma mark - CollectionView Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
    return 0.0f;
}

#pragma mark - Class funtions

- (void)displayImages:(NSMutableArray *)imageArray;
{
    self.imageArray = imageArray;
    
    [self.collectionView reloadData];
}

@end
