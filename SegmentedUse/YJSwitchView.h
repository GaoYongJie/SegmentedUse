//
//  YJSwitchView.h
//  SegmentedUse
//
//  Created by 高永杰 on 2017/7/12.
//  Copyright © 2017年 GYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJSwitchView : UIView

/**  点击block  */
@property (nonatomic, copy) void(^selectBlock)(NSInteger index);

/**  设置选中后的颜色  默认红色  */
@property (nonatomic, strong) UIColor *  selectedSliderColor;

/**  设置滑动部分的高度  */
@property (nonatomic, assign, readonly) NSInteger  sliderViewHeight;

/**  初始化方法  */
+ (instancetype)switchViewWithFrame:(CGRect)frame titles:(NSArray *)titlesArr;// block:(void(^)(NSInteger index))selectBlock;

/**  添加视图 index 最小值为0  */
- (void)addView:(UIView *)view atIndex:(NSInteger)index;

@end
