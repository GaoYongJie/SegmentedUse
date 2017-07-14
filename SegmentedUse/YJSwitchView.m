//
//  YJSwitchView.m
//  SegmentedUse
//
//  Created by 高永杰 on 2017/7/12.
//  Copyright © 2017年 GYJ. All rights reserved.
//

#import "YJSwitchView.h"
@interface YJSwitchView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView              * bottomView;

@property (nonatomic, strong) UISegmentedControl  * segmented;

@property (nonatomic, strong) UIScrollView        * scrollView;

@property (nonatomic, strong) NSArray             * titles;

@property (nonatomic, assign) NSInteger             itemCount;

@end

@implementation YJSwitchView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initialization];
    }
    return self;
}
//- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titlesArr block:(void(^)(NSInteger index))selectBlock

+ (instancetype)switchViewWithFrame:(CGRect)frame titles:(NSArray *)titlesArr
{
    YJSwitchView * switchView = [[self alloc] initWithFrame:frame];
    switchView.titles = [NSArray arrayWithArray:titlesArr];
    switchView.itemCount = titlesArr.count;
    
    [switchView setupView];
    return switchView;
}

- (void)initialization
{
    _selectedSliderColor = [UIColor redColor];
    _sliderViewHeight = 30;
}
//- (void)setTitles:(NSArray *)titles
//{
//    _titles = titles;
//    _segmented seti
//}
- (void)addView:(UIView *)view atIndex:(NSInteger)index
{
    float x = index * self.bounds.size.width;
    view.frame = CGRectMake(x, 0, self.bounds.size.width, _scrollView.bounds.size.height);
    [_scrollView addSubview:view];
}
- (void)setupView
{
    UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:_titles];
    [segmented setSelectedSegmentIndex:0];
    [segmented setTintColor:[UIColor clearColor]];
    [segmented setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateNormal];
    [segmented setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName: self.selectedSliderColor} forState:UIControlStateSelected];
    [segmented addTarget:self action:@selector(clickSemented:) forControlEvents:UIControlEventValueChanged];
    segmented.frame = (CGRect){0, 0, self.bounds.size.width, _sliderViewHeight};
    
    [self addSubview:segmented];
    _segmented = segmented;
    
    UIView * bottomView = [UIView new];
    bottomView.backgroundColor = _selectedSliderColor;
    bottomView.frame = (CGRect){0, 28, self.bounds.size.width / _itemCount, 2};
    
    [_segmented addSubview:bottomView];
    _bottomView = bottomView;
    
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:(CGRect){0, _sliderViewHeight, self.bounds.size.width, self.bounds.size.height - _sliderViewHeight}];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.contentSize = (CGSize){self.bounds.size.width * _itemCount, self.bounds.size.height - _sliderViewHeight};
    scrollView.backgroundColor = [UIColor grayColor];
    
    [self addSubview:scrollView];
    _scrollView = scrollView;
}

- (void)setSelectedSliderColor:(UIColor *)selectedSliderColor
{
    _selectedSliderColor = selectedSliderColor;
    [_segmented setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:_selectedSliderColor} forState:UIControlStateSelected];
    _bottomView.backgroundColor = _selectedSliderColor;
    
//    [_segmented setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName: self.selectedSliderColor} forState:UIControlStateSelected];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    
//    NSLog(@"%f,%f",point.x, point.y);
    _bottomView.transform = CGAffineTransformMakeTranslation(point.x / _itemCount, 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    //    point.x / self.view.bounds.size.width;
    [_segmented setSelectedSegmentIndex:point.x / self.bounds.size.width];
}

- (void)clickSemented:(UISegmentedControl *)tempSegmented
{
    NSInteger index = tempSegmented.selectedSegmentIndex;
    if (self.selectBlock)
    {
        self.selectBlock(index);
    }
    [UIView animateWithDuration:0.25 animations:^{
        _bottomView.transform = CGAffineTransformMakeTranslation(self.bounds.size.width * tempSegmented.selectedSegmentIndex / _itemCount, 0);
        [_scrollView setContentOffset:CGPointMake(self.bounds.size.width * index, 0)];
    }];
}
@end
