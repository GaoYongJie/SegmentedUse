//
//  ViewController.m
//  SegmentedUse
//
//  Created by 高永杰 on 2017/7/12.
//  Copyright © 2017年 GYJ. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Masonry.h"
#import "YJSwitchView.h"
#import "AFNetworking.h"
#import "YJFileManage.h"
#import "AccessoryTableView.h"
#import "VideoTableView.h"
#import "VideoCellModel.h"
#import "SectionMode.h"
#import "PhotoCollectionView.h"
@interface ViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UISegmentedControl *segmented;
@property (nonatomic, strong) UIScrollView * scr;
@property (nonatomic, strong) UIButton * btn;

@property (nonatomic, strong) VideoTableView * videoTableView;
@property (nonatomic, strong) PhotoCollectionView * photoCollectionView;
@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //初始化滑动控件
    YJSwitchView * switchView = [YJSwitchView switchViewWithFrame:(CGRect){0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 49} titles:@[@"文档", @"视频", @"相册", @"音乐"]];
    
    //点击回调
    switchView.selectBlock = ^(NSInteger index) {
        NSLog(@"%ld",(long)index);
    };
    
    //文档列表
    AccessoryTableView *accessory = [[AccessoryTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    accessory.backgroundColor = [UIColor redColor];
    //添加到滑动控件上
    [switchView addView:accessory atIndex:0];
    
    //视频列表
    [self run];
    _videoTableView = [[VideoTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [switchView addView:_videoTableView atIndex:1];
    
    //相册列表
    UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init];
    CGSize size = [UIScreen mainScreen].bounds.size;
    //展示方式
    [flow setScrollDirection:UICollectionViewScrollDirectionVertical];
    //头部视图大小
    flow.headerReferenceSize = CGSizeMake(size.width, 50);
    //高度算法 每行默认44 * 取5条信息 + 头视图 + 灰色分割线
    //    flow.footerReferenceSize = CGSizeMake(SCREEN_WIDTH,TableRowHeight * 3 + 36 + 12);
    
    
    flow.minimumLineSpacing = 2;
    flow.minimumInteritemSpacing = 2;
    
    flow.itemSize = CGSizeMake(size.width/4.0 - 2 , size.width/4.0 - 2);
    
    _photoCollectionView = [[PhotoCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
    [switchView addView:_photoCollectionView atIndex:2];
    
    //将控件添加到控制器上
    UIViewController * vc = [[UIViewController alloc] init];
    [vc.view addSubview:switchView];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

-(void)run
{
    __weak ViewController *weakSelf = self;
    NSMutableArray * groupArrays = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
            if (group != nil)
            {
                [groupArrays addObject:group];
            }
            else
            {
                [groupArrays enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

                    NSMutableArray * videoModelArr = [NSMutableArray array];
                    NSMutableArray * photoModelArr = [NSMutableArray array];
                    [obj enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL  *stop) {
                        
                        if ([result thumbnail] != nil)
                        {
                            // 照片
                            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto])
                            {
                                
                                VideoCellModel * model = VideoCellModel.new;
                                ALAssetRepresentation  * representation = [result defaultRepresentation];
                                model.fileName = [representation filename];
                                model.dataSize = [NSString stringWithFormat:@"%lld", [representation size]];
                                model.isSign = NO;

                                model.url = [representation url];
                                model.thumbnail = [UIImage imageWithCGImage:[result thumbnail]];
                                
                                [photoModelArr addObject:model];
//                                NSDate *date= [result valueForProperty:ALAssetPropertyDate];
//                                int64_t fileSize = [[result defaultRepresentation] size];
//                                 UI的更新记得放在主线程,要不然等子线程排队过来都不知道什么年代了,会很慢的
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
                                
                                [videoModelArr addObject:model];
                            }
                        }
                    }];    
                    weakSelf.videoTableView.videoDataDic = [NSMutableDictionary dictionaryWithDictionary:@{@"本地视频":videoModelArr}];
                    weakSelf.photoCollectionView.photoDataDic = [NSMutableDictionary dictionaryWithDictionary:@{@"相机胶卷":photoModelArr}];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self load];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"qq"];
    cell.textLabel.text = @"afdafasfas";
    return cell;
}


//以后下载文件时使用（暂不使用）
- (void)load
{
    NSURL *URL = [NSURL URLWithString:@"http://www.baidu.com/img/bdlogo.png"];
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //AFN3.0+基于封住URLSession的句柄
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //下载Task操作
    NSURLSessionDownloadTask * _downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        // 给Progress添加监听 KVO
        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        // 回到主队列刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
//             设置进度条的百分比
//            self.progressView.progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //创建路径
        [YJFileManage createNewCatalog];
        return [NSURL fileURLWithPath:[YJFileManage returnNewPahtAndFileName:response.suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//        设置下载完成操作
//         filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
//        NSString *imgFilePath = [filePath path];// 将NSURL转成NSString
//        UIImage *img = [UIImage imageWithContentsOfFile:imgFilePath];
//        self.imageView.image = img;
    }];
    
    [_downloadTask resume];
}
@end
