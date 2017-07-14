//
//  YJFileManage.h
//  SegmentedUse
//
//  Created by 高永杰 on 2017/7/13.
//  Copyright © 2017年 GYJ. All rights reserved.
//
//自定义一个文件目录，存放在
#import <Foundation/Foundation.h>

@interface YJFileManage : NSObject

+ (void)createNewCatalog;

+ (NSString *)returnNewPahtAndFileName:(NSString *)fileName;

+ (NSMutableDictionary *)returnAllAccessory;
@end
