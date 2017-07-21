//
//  SectionHeadView.m
//  SegmentedUse
//
//  Created by 高永杰 on 2017/7/20.
//  Copyright © 2017年 GYJ. All rights reserved.
//

#import "SectionHeadView.h"
#import "SectionMode.h"

@interface SectionHeadView()

@property (weak, nonatomic) IBOutlet UIImageView *expandImg;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation SectionHeadView
- (instancetype)init
{
    if (self = [super init])
    {
    }
    return self;
}
//- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
//{
//    if (self = [super initWithReuseIdentifier:reuseIdentifier])
//    {
//        self.userInteractionEnabled = YES;
//        
//    }
//    return self;
//}
- (void)click
{
    self.mode.isExpanded = !self.mode.isExpanded;
    [UIView animateWithDuration:0.25 animations:^{
        if (_mode.isExpanded)
        {
            self.expandImg.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
        }
        else
        {
            self.expandImg.transform = CGAffineTransformIdentity;
        }
        
    }];
    if (self.clickBlock)
    {
        self.clickBlock();
    }
}
- (void)setMode:(SectionMode *)mode
{
    if (_mode != mode)
    {
        _mode = mode;
    }
    
    if (mode.isExpanded)
    {
        self.expandImg.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    }
    else
    {
        self.expandImg.transform = CGAffineTransformIdentity;
    }
    
    UITapGestureRecognizer * re = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    NSLog(@"%@",NSHomeDirectory());;
    [self addGestureRecognizer:re];
    self.backgroundColor = [UIColor whiteColor];
    _titleLab.text = mode.sectionTitle;
}


@end
