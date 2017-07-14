//
//  SectionMode.h
//  SegmentedUse
//
//  Created by 高永杰 on 2017/7/14.
//  Copyright © 2017年 GYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SectionMode : NSObject

@property(nonatomic, assign) BOOL isExpanded;

@property (nonatomic, strong)NSString *sectionTitle;

@property (nonatomic, assign)NSInteger rowNum;

@end
