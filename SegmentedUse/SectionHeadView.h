//
//  SectionHeadView.h
//  SegmentedUse
//
//  Created by 高永杰 on 2017/7/20.
//  Copyright © 2017年 GYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SectionMode;

@interface SectionHeadView : UICollectionReusableView

@property (nonatomic, strong) SectionMode * mode;

@property (nonatomic, copy) void(^clickBlock)();

@end
