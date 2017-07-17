//
//  YJFileManage.m
//  SegmentedUse
//
//  Created by 高永杰 on 2017/7/13.
//  Copyright © 2017年 GYJ. All rights reserved.
//

#import "YJFileManage.h"
#import "CellModel.h"
static NSString * const accessoryName = @"Accessory";

@implementation YJFileManage
+ (NSString *)returnDefinePaht
{
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSString *)returnNewPaht
{
    return [NSString stringWithFormat:@"%@/%@", [self returnDefinePaht], accessoryName];
}

+ (void)createNewCatalog
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    //默认创建一个名为附件的目录，存放附件
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self returnNewPaht]])
    {
        [fileManager createDirectoryAtPath:[self returnNewPaht] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    else
    {
        NSLog(@"有这个文件夹了");
    }
}

+ (NSString *)returnNewPahtAndFileName:(NSString *)fileName
{
    return [[self returnNewPaht] stringByAppendingPathComponent:fileName];
}

+ (NSMutableDictionary *)returnAllAccessory
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSDirectoryEnumerator *enumerator = [manager enumeratorAtPath:[self returnNewPaht]];

    NSString *fileName;
    
    NSMutableArray * word, * excel, * pdf;

    NSMutableDictionary * dic = [NSMutableDictionary dictionary];

    while (fileName = [enumerator nextObject]) {
        
        CellModel * model = CellModel.new;
        
//        NSData * data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[self returnNewPaht], fileName]];
        
        long sizeLong = [self fileSizeAtPath:[NSString stringWithFormat:@"%@/%@",[self returnNewPaht], fileName]];
        
        model.fileName = fileName;
        
        model.dataSize = [NSString stringWithFormat:@"%ld",sizeLong];
        
        model.isSign = NO;
        
        if ([[fileName pathExtension] isEqualToString:@"doc"] || [[fileName pathExtension] isEqualToString:@"docx"])
        {
            if (!word)
            {
                word = [NSMutableArray array];
                dic[@"WORD"] = word;
            }
            [word addObject:model];
        }
        else if ([[fileName pathExtension] isEqualToString:@"xls"])
        {
            if (!excel)
            {
                excel = [NSMutableArray array];
                dic[@"EXCEL"] = excel;
            }
            
            [excel addObject:model];
        }
        else if ([[fileName pathExtension] isEqualToString:@"pdf"])
        {
            if (!pdf)
            {
                pdf = [NSMutableArray array];
                dic[@"PDF"] = pdf;
            }
            [pdf addObject:model];
        }
    }

    return dic;
}

+ (long)fileSizeAtPath:(NSString *)filePath
{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath])
    {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
@end
