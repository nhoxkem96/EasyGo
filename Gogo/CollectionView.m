//
//  CollectionView.m
//  Gogo
//
//  Created by Thuong on 9/14/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "CollectionView.h"
#import "CollectionAdd.h"
#import "CollectionImage.h"
#import "Cloudinary.h"
#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface CollectionView ()<CollectionAddDelegate,CollectionImageDelegate,CLUploaderDelegate>

@end
@implementation CollectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.arrayImage = [[NSMutableArray alloc]init];
    self.arrayCheckUpload = [[NSMutableArray alloc]init];
    self.arrayURL= [[NSMutableArray alloc]init];
    self.arrayCheckUploadComplete = [[NSMutableArray alloc]init];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CollectionAdd class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([CollectionAdd class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CollectionImage class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([CollectionImage class])];
    // Initialization code
    
}
-(void)uploadImage:(UIImage *)image index:(NSInteger) index{
    NSDate *date = [[NSDate alloc] init];
    NSString *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%lld.jpg", [@(floor([date timeIntervalSince1970] * 1000)) longLongValue]]];
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:jpgPath atomically:YES];
    NSURL *url = [[NSURL alloc]initFileURLWithPath:jpgPath];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:@"http:easygo.com.vn/api/files/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:url name:@"file" error:nil];
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@" , responseObject);
        [self uploadComplete:index];
        NSString *urlImage = [responseObject objectForKey:@"path"];
        self.arrayURL[index] = urlImage;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
#pragma mark - Collectionview
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    for(int i = 0 ; i < self.arrayCheckUpload.count ; i++){
        if([self.arrayCheckUpload[i] caseInsensitiveCompare:@"NO"] == NSOrderedSame){
            self.arrayCheckUpload[i] = @"YES";
            [self uploadImage:self.arrayImage[i] index:i];
        }
    }
    return self.arrayImage.count + 1;;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if(indexPath.row == self.arrayImage.count){
        CollectionAdd *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CollectionAdd class]) forIndexPath:indexPath];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CollectionAdd class]) owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.delegate = self;
        return cell;
    }
    
    else{
        CollectionImage *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CollectionImage class]) forIndexPath:indexPath];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CollectionImage class]) owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        if([self.arrayImage[indexPath.row] isKindOfClass:[UIImage class]]){
            cell.imgItem.image = self.arrayImage[indexPath.row];
        }
        else{
            NSString *url = self.arrayImage[indexPath.row];
            NSString *match = @".vn/";
            NSString *pre;
            NSString *last;
            NSScanner *scanner = [NSScanner scannerWithString:url];
            [scanner scanUpToString:match intoString:&pre];
            [scanner scanString:match intoString:nil];
            last = [url substringFromIndex:scanner.scanLocation];
            NSString *newUrl = [NSString stringWithFormat:@"http://easygo.com.vn/api/image/resize?path=%@&width=%f&height=%f" ,last ,[UIScreen mainScreen].bounds.size.width/ 2 ,[UIScreen mainScreen].bounds.size.width/ 3];
            [cell.imgItem sd_setImageWithURL:[NSURL URLWithString:self.arrayImage[indexPath.row]]
                           placeholderImage:[UIImage imageNamed:@"1"]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                  }];
        }
        cell.progress.hidden = YES;
        cell.imgItem.alpha = 1.0f;
        cell.delegate = self;
        cell.cellIndex = indexPath.row;
        if([self.arrayCheckUploadComplete[indexPath.row] caseInsensitiveCompare:@"NO"] == NSOrderedSame){
            cell.imgItem.alpha = 0.5f;
            cell.progress.hidden = NO;
        }
        
        
        return cell;
    }
}
-(void)clickBtnAddImage:(NSInteger)cellIndex{
    
    if ([self.delegate respondsToSelector:@selector(clickBtnAddImage:)]) {
        [self.delegate clickBtnAddImage:self.cellIndex];
    }
}
-(void)deleteImage:(NSInteger)cellIndex{
    [self.arrayImage removeObjectAtIndex:cellIndex];
    [self.arrayURL removeObjectAtIndex:cellIndex];
    [self.arrayCheckUpload removeObjectAtIndex:cellIndex];
    [self.arrayCheckUploadComplete removeObjectAtIndex:cellIndex];
    [self.collectionView reloadData];
}
-(void)uploadComplete:(NSInteger)cellIndex{
    self.arrayCheckUploadComplete[cellIndex] = @"YES";
    if ([self.delegate respondsToSelector:@selector(uploadCompleteAImage:)]) {
        [self.delegate uploadCompleteAImage:_cellIndex];
    }
}
#pragma mark - CollectionView Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if(indexPath.row == self.arrayImage.count){
        return CGSizeMake([UIScreen mainScreen].bounds.size.width/ 3 ,[UIScreen mainScreen].bounds.size.width/ 3);
    }
    else return CGSizeMake([UIScreen mainScreen].bounds.size.width/ 2 ,[UIScreen mainScreen].bounds.size.width/ 3);
}

@end
