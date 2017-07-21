//
//  VideoTableView.m
//  SegmentedUse
//
//  Created by 高永杰 on 2017/7/18.
//  Copyright © 2017年 GYJ. All rights reserved.
//

#import "VideoTableView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "VideoCellModel.h"
#import "SectionMode.h"
#import "CellViewModel.h"
#import "AccessorySectionHeadView.h"

static NSString * const kCellIdentifier = @"asfqw4tednrbtsdfv";
static NSString * const kHeadIdentifier = @"abcdefg";

@interface VideoTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * sectionData;

@property (nonatomic, strong)NSMutableArray *groupArrays;

@end

@implementation VideoTableView

- (void)setVideoDataDic:(NSMutableDictionary *)videoDataDic
{
    if (_videoDataDic != videoDataDic)
    {
        _videoDataDic = nil;
        _videoDataDic = videoDataDic;
    }
    
    __weak VideoTableView * ws = self;
    
    [_videoDataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        SectionMode * model = SectionMode.new;
        model.isExpanded = NO;
        model.sectionTitle = key;
        model.cellModelArr = obj;
        [ws.sectionData addObject:model];
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadData];
    });
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style])
    {
//        [self run];
        self.delegate = self;
        self.dataSource = self;
        self.sectionHeaderHeight = 40;
        self.rowHeight = 80;
        self.backgroundColor = [UIColor clearColor];
        self.sectionData = [NSMutableArray array];
        // 初始化
        self.groupArrays = [NSMutableArray array];

        [self registerNib:[UINib nibWithNibName:@"CellViewModel" bundle:nil] forCellReuseIdentifier:kCellIdentifier];
        [self registerNib:[UINib nibWithNibName:@"AccessorySectionHeadView" bundle:nil] forHeaderFooterViewReuseIdentifier:kHeadIdentifier];
    }
    
    return self;
}

-(void)run
{
    __weak VideoTableView *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
            if (group != nil)
            {
                [weakSelf.groupArrays addObject:group];
            }
            else
            {
                [weakSelf.groupArrays enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSLog(@"%@",obj);
                    NSMutableArray * videoModelArr = [NSMutableArray array];
                    
                    [obj enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL  *stop) {
                        
                        if ([result thumbnail] != nil)
                        {
                            // 照片
                            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto])
                            {
                                
//                                VideoCellModel * model = VideoCellModel.new;
//                                ALAssetRepresentation  * representation = [result defaultRepresentation] ;
//                                model.fileName = [representation filename];
//                                model.dataSize = [NSString stringWithFormat:@"%lld", [representation size]];
//                                model.isSign = NO;
//                                
//                                model.url = [representation url];
//                                model.thumbnail = [UIImage imageWithCGImage:[result thumbnail]];
//
//                                
//                                NSDate *date= [result valueForProperty:ALAssetPropertyDate];
//                                UIImage *image = [UIImage imageWithCGImage:[result thumbnail]];
//                                NSString *fileName = [[result defaultRepresentation] filename];
//                                NSURL *url = [[result defaultRepresentation] url];
//                                int64_t fileSize = [[result defaultRepresentation] size];
//
//                                NSLog(@"date = %@",date);
//                                NSLog(@"fileName = %@",fileName);
//                                NSLog(@"url = %@",url);
//                                NSLog(@"fileSize = %lld",fileSize);
//
//                                // UI的更新记得放在主线程,要不然等子线程排队过来都不知道什么年代了,会很慢的
//                                NSLog(@"读取到照片了");
                            }
                            else if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo] )// 视频
                            {
                                VideoCellModel * model = VideoCellModel.new;
                                ALAssetRepresentation  * representation = [result defaultRepresentation] ;
                                model.fileName = [representation filename];
                                model.dataSize = [NSString stringWithFormat:@"%lld", [representation size]];
                                model.isSign = NO;
                                
                                model.url = [representation url];
                                model.thumbnail = [UIImage imageWithCGImage:[result thumbnail]];
                                
                                
//                                NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
//                                NSData *data = [NSData dataWithContentsOfURL:url];
//                                NSData *data = [NSData dataWithContentsOfFile:url];
                                [videoModelArr addObject:model];
//                                AVAssetExportSession *session = [AVAssetExportSession exportSessionWithAsset:avasset presetName:AVAssetExportPresetHighestQuality];
//                                session.outputFileType = AVFileTypeMPEG4;
//                                session.outputURL = ...; // 这个就是你可以导出的文件路径了。

                            }
                        }
                    }];
                        weakSelf.videoDataDic[@"本地视频"] = videoModelArr;
                        [_videoDataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                            SectionMode * model = SectionMode.new;
                            model.isExpanded = NO;
                            model.sectionTitle = key;
                            model.cellModelArr = obj;
                            [weakSelf.sectionData addObject:model];
                        }];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self reloadData];
                    });
                }];
            }
        };
        
        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error){
            
            NSString *errorMessage = nil;
            
            switch ([error code]) {
                case ALAssetsLibraryAccessUserDeniedError:
                case ALAssetsLibraryAccessGloballyDeniedError:
                    errorMessage = @"用户拒绝访问相册,请在<隐私>中开启";
                    break;
                    
                default:
                    errorMessage = @"Reason unknown.";
                    break;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误,无法访问!"
                                                                   message:errorMessage
                                                                  delegate:self
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil, nil];
                [alertView show];
            });
        };
        
        
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]  init];
        
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                     usingBlock:listGroupBlock
                                   failureBlock:failureBlock];
        
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SectionMode *mode = _sectionData[section];
    if (mode.isExpanded)
    {
        return mode.cellModelArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellViewModel *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    SectionMode * SectionModel = _sectionData[0];
    VideoCellModel *cellModel = SectionModel.cellModelArr[indexPath.row];
//    NSString * type = _allKeysArr[indexPath.section];
//    CellModel *model = _dataDic[type][indexPath.row];
    cell.model = cellModel;
//    [cell.iconBtn setImage:cellModel.thumbnail forState:UIControlStateNormal];
    [cell.iconBtn setBackgroundImage:cellModel.thumbnail forState:UIControlStateNormal];
    cell.fileType = SectionModel.sectionTitle;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    AccessorySectionHeadView * headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kHeadIdentifier];
    headView.mode = _sectionData[section];
    headView.clickBlock = ^{
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    headView.backgroundColor = [UIColor redColor];
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellViewModel *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    cell.model.isSign = !cell.model.isSign;
    
    if (cell.model.isSign)
    {
        cell.signImg.image = [UIImage imageNamed:@"round_sel"];
    }
    else
    {
        cell.signImg.image = [UIImage imageNamed:@"round"];
    }
}

@end
