//
//  YJFileManage.m
//  SegmentedUse
//
//  Created by 高永杰 on 2017/7/13.
//  Copyright © 2017年 GYJ. All rights reserved.
//

#import "YJFileManage.h"
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

+ (NSDictionary *)returnAllAccessory
{
    NSFileManager *manager=[NSFileManager defaultManager];
    
    NSDirectoryEnumerator *enumerator = [manager enumeratorAtPath:[self returnNewPaht]];

    NSString *filename;
    
    NSMutableArray * word;
    NSMutableArray * excel;
    NSMutableArray * pdf;
    while (filename = [enumerator nextObject]) {
        
        if ([[filename pathExtension] isEqualToString:@"doc"] || [[filename pathExtension] isEqualToString:@"docx"])
        {
//            NSData * data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[self returnNewPaht], filename]];
            long l = [self fileSizeAtPath:[NSString stringWithFormat:@"%@/%@",[self returnNewPaht], filename]];
            if (!word)
            {
                word = [NSMutableArray array];
            }
            [word addObject:filename];
            NSLog(@"%ld",l);
        }
        else if ([[filename pathExtension] isEqualToString:@"xls"])
        {
//            NSData * data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[self returnNewPaht], filename]];
            long l = [self fileSizeAtPath:[NSString stringWithFormat:@"%@/%@",[self returnNewPaht], filename]];
            if (!excel)
            {
                excel = [NSMutableArray array];
            }
            [excel addObject:filename];
            NSLog(@"%ld",l);
        }
        else if ([[filename pathExtension] isEqualToString:@"pdf"])
        {
            if (!pdf)
            {
                pdf = [NSMutableArray array];
            }
            [pdf addObject:filename];
//            NSData * data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[self returnNewPaht], filename]];
            long l = [self fileSizeAtPath:[NSString stringWithFormat:@"%@/%@",[self returnNewPaht], filename]];
            NSLog(@"%ld",l);
            
        }
    }
    
  return  @{@"WORD":word, @"EXCEL":excel, @"PDF":pdf};
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
