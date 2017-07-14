//
//  AccessorySectionHeadView.h
//  SegmentedUse
//
//  Created by 高永杰 on 2017/7/14.
//  Copyright © 2017年 GYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SectionMode;

@interface AccessorySectionHeadView : UITableViewHeaderFooterView

@property (nonatomic, strong) SectionMode * mode;

@property (nonatomic, copy) void(^clickBlock)();

@end
