//
//  VideoCellModel.h
//  SegmentedUse
//
//  Created by 高永杰 on 2017/7/20.
//  Copyright © 2017年 GYJ. All rights reserved.
//

#import "CellModel.h"

@interface VideoCellModel : CellModel

@property (nonatomic, copy) NSURL *url;

@property (nonatomic, retain) UIImage * thumbnail;

@end
