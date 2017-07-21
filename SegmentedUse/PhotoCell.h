//
//  PhotoCell.h
//  SegmentedUse
//
//  Created by 高永杰 on 2017/7/20.
//  Copyright © 2017年 GYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoCellModel;

@interface PhotoCell : UICollectionViewCell

@property (nonatomic, strong) VideoCellModel * model;

@property (weak, nonatomic) IBOutlet UIImageView *signImage;

@end
