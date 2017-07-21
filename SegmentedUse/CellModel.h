//
//  CellModel.h
//  SegmentedUse
//
//  Created by 高永杰 on 2017/7/14.
//  Copyright © 2017年 GYJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CellModel : NSObject

@property (nonatomic, copy) NSString * fileName;

@property (nonatomic, copy) NSString * dataSize;

@property (nonatomic, assign) BOOL isSign;  //是否选中

@property (nonatomic, copy) NSData * data;

@end
