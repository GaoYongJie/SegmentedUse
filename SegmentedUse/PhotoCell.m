//
//  PhotoCell.m
//  SegmentedUse
//
//  Created by 高永杰 on 2017/7/20.
//  Copyright © 2017年 GYJ. All rights reserved.
//

#import "PhotoCell.h"
#import "VideoCellModel.h"

@interface PhotoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *previewImage;

@end

@implementation PhotoCell

- (void)setModel:(VideoCellModel *)model
{
    if (_model != model)
    {
        _model = nil;
        _model = model;
    }
    _previewImage.image = _model.thumbnail;
    
    if (model.isSign)
    {
        _signImage.image = [UIImage imageNamed:@"round_sel"];
    }
    else
    {
        _signImage.image = [UIImage imageNamed:@"round"];
    }
}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    self.model.isSign = !self.model.isSign;
//    
//    if (self.model.isSign)
//    {
//        self.signImage.image = [UIImage imageNamed:@"round_sel"];
//    }
//    else
//    {
//        self.signImage.image = [UIImage imageNamed:@"round"];
//    }
//}
@end
