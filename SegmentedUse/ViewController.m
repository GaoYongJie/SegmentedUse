//
//  ViewController.m
//  SegmentedUse
//
//  Created by 高永杰 on 2017/7/12.
//  Copyright © 2017年 GYJ. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "YJSwitchView.h"
#import "AFNetworking.h"
#import "YJFileManage.h"
#import "AccessoryTableView.h"
@interface ViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UISegmentedControl *segmented;
@property (nonatomic, strong) UIScrollView * scr;
@property (nonatomic, strong) UIButton * btn;
@end

@implementation ViewController
- (void)sendFuJian:(id)sender
{
    //初始化滑动控件
    YJSwitchView * switchView = [YJSwitchView switchViewWithFrame:(CGRect){0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 49} titles:@[@"文档", @"视频", @"相册", @"音乐"]];
    
    //点击回调
    switchView.selectBlock = ^(NSInteger index) {
        NSLog(@"%ld",(long)index);
    };
    
    //文档列表
    AccessoryTableView *accessory = [[AccessoryTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    //添加到滑动控件上
    [switchView addView:accessory atIndex:0];
    
    //视频列表
    UITableView * table = [[UITableView alloc] init];
    table.delegate = self;
    table.dataSource = self;
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"qq"];
    [switchView addView:table atIndex:1];
    
    //相册列表
    UIView * view2 = [[UIView alloc] init];
    view2.backgroundColor = [UIColor orangeColor];
    [switchView addView:view2 atIndex:2];
    
    //将控件添加到控制器上
    UIViewController * vc = [[UIViewController alloc] init];
    [vc.view addSubview:switchView];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self load];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _btn = [[UIButton alloc] initWithFrame:(CGRect){100, 100 ,200 ,200}];
    _btn.backgroundColor = [UIColor grayColor];
    [_btn setTitle:@"发送附件" forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(sendFuJian:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn];
    
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
