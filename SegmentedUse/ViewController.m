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
    YJSwitchView * yj = [YJSwitchView switchViewWithFrame:(CGRect){0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 49} titles:@[@"文档", @"视频", @"相册", @"音乐"]];
    
    yj.selectedSliderColor = [UIColor greenColor];
    
    yj.selectBlock = ^(NSInteger index) {
        NSLog(@"%ld",(long)index);
    };
    UIViewController * vc = [[UIViewController alloc] init];

    [vc.view addSubview:yj];
    
    AccessoryTableView *accessory = [[AccessoryTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];

    [yj addView:accessory atIndex:0];
    
    
    UITableView * table = [[UITableView alloc] init];
    table.delegate = self;
    table.dataSource = self;
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"qq"];
    [yj addView:table atIndex:1];
    
    UIView * view2 = [[UIView alloc] init];
    view2.backgroundColor = [UIColor orangeColor];
    [yj addView:view2 atIndex:2];
    
    
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
    
}
- (void)load
{
    //远程地址
    NSURL *URL = [NSURL URLWithString:@"http://www.baidu.com/img/bdlogo.png"];
//    NSURL *URL = [NSURL URLWithString:@"https://pan.baidu.com/s/1jHCZ1uY"];
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //AFN3.0+基于封住URLSession的句柄
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //下载Task操作
    NSURLSessionDownloadTask * _downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        // @property int64_t totalUnitCount;     需要下载文件的总大小
        // @property int64_t completedUnitCount; 当前已经下载的大小
        
        // 给Progress添加监听 KVO
        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        // 回到主队列刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            // 设置进度条的百分比
            
//            self.progressView.progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        [YJFileManage createNewCatalog];
        return [NSURL fileURLWithPath:[YJFileManage returnNewPahtAndFileName:response.suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //设置下载完成操作
        // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
        
//        NSString *imgFilePath = [filePath path];// 将NSURL转成NSString
//        UIImage *img = [UIImage imageWithContentsOfFile:imgFilePath];
//        self.imageView.image = img;
        
    }];
    [_downloadTask resume];
    
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
    
    NSFileManager * fileManager = [[NSFileManager alloc] init];
    NSString * path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString * createNewPath = [NSString stringWithFormat:@"%@/accessory", path];
    if (![[NSFileManager defaultManager] fileExistsAtPath:createNewPath])
    {
//        [fileManager createDirectoryAtPath:createNewPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    else
    {
        NSLog(@"有这个文件夹了");
    }
    
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *home = [@"~" stringByExpandingTildeInPath];//根目录文件夹
    NSDirectoryEnumerator *direnum = [manager enumeratorAtPath:home];
    NSMutableArray *files = [NSMutableArray array];
    //遍历目录迭代器，获取各个文件路径
    NSString *filename;
    while (filename = [direnum nextObject]) {
        
        if ([[filename pathExtension] isEqualToString:@"png"]) {//筛选出文件后缀名是jpg的文件
            [files addObject:filename];
        }
    }
    NSLog(@"%lu",[files count]);
    //遍历数组，输出列表
    NSEnumerator *enume = [files objectEnumerator];
    while (filename = [enume nextObject]) {
        
        
        
        NSData* data1 = [[NSData alloc] init];
        data1 = [manager contentsAtPath:@"/var/mobile/Containers/Data/Application/09A755AB-6BD9-4F82-9BBC-10524B2332A6/Library/Cachescollect_deals/bdlogo.png"];
        
        NSFileHandle* fh = [NSFileHandle fileHandleForReadingAtPath:@""];
        data1 = [fh readDataToEndOfFile];
        NSLog(@"%@", filename);
    }
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"bdlogo" ofType:@"png"];
    NSData * data = [NSData dataWithContentsOfFile:plistPath];
    NSLog(@"%@", filename);
//    [self aaa];
    [YJFileManage returnAllAccessory];
}
- (void)aaa
{
//    NSString *path=@"System/Library/"; // 要列出来的目录
    NSString * path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString * createNewPath = [NSString stringWithFormat:@"%@/Accessory", path];
    
    NSFileManager *myFileManager=[NSFileManager defaultManager];
    
    NSDirectoryEnumerator *myDirectoryEnumerator = [myFileManager enumeratorAtPath:createNewPath];
    
    
    
    //列举目录内容，可以遍历子目录
    
    NSLog(@"用enumeratorAtPath:显示目录%@的内容：",createNewPath);
    NSString *a;
    NSString *filename;
    NSMutableArray *files = [NSMutableArray array];
    while (filename = [myDirectoryEnumerator nextObject]) {
        
        if ([[filename pathExtension] isEqualToString:@"png"]) {//筛选出文件后缀名是jpg的文件
            [files addObject:filename];
        }
    }
    
    NSEnumerator *enume = [files objectEnumerator];
    while (filename = [enume nextObject]) {
        
        
        
        NSData* data1 = [[NSData alloc] init];

        
        NSFileHandle* fh = [NSFileHandle fileHandleForReadingAtPath:@""];
        data1 = [fh readDataToEndOfFile];
        NSLog(@"%@", filename);
    }

    while((a=[myDirectoryEnumerator nextObject])!=nil)
    {
        NSData* data = [[NSData alloc] init];
        data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",createNewPath,a]];
        UIImage *img = [UIImage imageWithData:data];
        [_btn setBackgroundImage:img forState:UIControlStateNormal];
        NSLog(@"%@",a);
    }
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
-(void)test
{
    _segmented = [[UISegmentedControl alloc] initWithItems:@[@"标签1", @"标签2",@"标签3"]];
    [_segmented setSelectedSegmentIndex:0];
    [_segmented setTintColor:[UIColor clearColor]];
    [_segmented setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateNormal];
    [_segmented setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName: [UIColor redColor]} forState:UIControlStateSelected];
    [_segmented addTarget:self action:@selector(clickSemented:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmented];
    
    
    _bottomView = [UIView new];
    _bottomView.backgroundColor = [UIColor redColor];
    [_segmented addSubview:_bottomView];
    
    [_segmented mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(30);
        make.top.offset(64);
    }];
    
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(self.view.bounds.size.width/3.0);
        make.height.offset(2);
        make.bottom.offset(0);
    }];
    
    
    _scr = [[UIScrollView alloc] init];
    _scr.pagingEnabled = YES;
    _scr.delegate = self;
    _scr.contentSize = (CGSize){self.view.bounds.size.width * 3.0, self.view.bounds.size.height - 64 - 30 - 49};
    _scr.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_scr];
    
    [_scr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(-49);
        make.top.equalTo(_segmented.mas_bottom).offset(0);
    }];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint point = scrollView.contentOffset;
    
    NSLog(@"%f,%f",point.x, point.y);
    _bottomView.transform = CGAffineTransformMakeTranslation(point.x / 3.0, 0);

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
//    point.x / self.view.bounds.size.width;
    [_segmented setSelectedSegmentIndex:point.x / self.view.bounds.size.width];
}
- (void)clickSemented:(UISegmentedControl *)tempSegmented
{
    [UIView animateWithDuration:0.25 animations:^{
        _bottomView.transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width * tempSegmented.selectedSegmentIndex / 3.0, 0);
        [_scr setContentOffset:CGPointMake(self.view.bounds.size.width * tempSegmented.selectedSegmentIndex, 0)];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
