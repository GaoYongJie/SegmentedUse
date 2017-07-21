//
//  PhotoCollectionView.m
//  SegmentedUse
//
//  Created by 高永杰 on 2017/7/20.
//  Copyright © 2017年 GYJ. All rights reserved.
//

#import "PhotoCollectionView.h"
#import "SectionMode.h"
#import "AccessorySectionHeadView.h"
#import "SectionHeadView.h"
#import "VideoCellModel.h"
#import "PhotoCell.h"

static NSString * const kCellIdentifier = @"safasfa2";
static NSString * const kHeadIdentifier = @"qwfrgfhddg";

@interface PhotoCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *sectionData;

@end

@implementation PhotoCollectionView

- (void)setPhotoDataDic:(NSMutableDictionary *)photoDataDic
{
    if (_photoDataDic != photoDataDic)
    {
        _photoDataDic = nil;
        _photoDataDic = photoDataDic;
    }
    __weak PhotoCollectionView * ws = self;
    
    [_photoDataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        SectionMode * model = SectionMode.new;
        model.isExpanded = NO;
        model.sectionTitle = key;
        model.cellModelArr = obj;
        [ws.sectionData addObject:model];
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadData];
    });
    
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.dataSource = self;
        self.sectionData = [NSMutableArray array];
        [self registerNib:[UINib nibWithNibName:@"PhotoCell" bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
        [self registerNib:[UINib nibWithNibName:@"SectionHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeadIdentifier];
    }
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _sectionData.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    SectionMode *mode = _sectionData[section];
    if (mode.isExpanded)
    {
        return mode.cellModelArr.count;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    SectionMode * model =  _sectionData[indexPath.section];
    VideoCellModel * videoModel = model.cellModelArr[indexPath.row];
    cell.model = videoModel;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    SectionHeadView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeadIdentifier forIndexPath:indexPath];
    headerView.mode = _sectionData[indexPath.section];
    headerView.clickBlock = ^{
        [collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
    };
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = (PhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.model.isSign = !cell.model.isSign;
    
    if (cell.model.isSign)
    {
        cell.signImage.image = [UIImage imageNamed:@"round_sel"];
    }
    else
    {
        cell.signImage.image = [UIImage imageNamed:@"round"];
    }
}


@end
