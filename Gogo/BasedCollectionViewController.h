//
//  BaseCollectionViewController.h
//  Nushi
//
//  Created by Ta Hoang Minh on 2/11/15.
//  Copyright (c) 2015 Ta Hoang Minh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "BasedViewController.h"

@interface BasedCollectionViewController : BasedViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property NSMutableDictionary *numberRowInSection;
@property NSArray *collectionData;
@property NSMutableDictionary *dictListImage;

@end
