//
//  CellViewModel.h
//  SegmentedUse
//
//  Created by 高永杰 on 2017/7/14.
//  Copyright © 2017年 GYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CellModel;

@interface CellViewModel : UITableViewCell

@property (nonatomic, strong) CellModel * model;

@property (weak, nonatomic) IBOutlet UIImageView *signImg;

@property (weak, nonatomic) NSString *fileType;

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@end
