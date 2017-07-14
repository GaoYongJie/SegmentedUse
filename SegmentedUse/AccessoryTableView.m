//
//  AccessoryTableView.m
//  SegmentedUse
//
//  Created by 高永杰 on 2017/7/13.
//  Copyright © 2017年 GYJ. All rights reserved.
//

#import "AccessoryTableView.h"
#import "YJFileManage.h"

static NSString * const identifier = @"asdfasfwe";
@interface AccessoryTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSDictionary  * dataDic;
@property (nonatomic, copy) NSArray  * allKeysArr;

@end

@implementation AccessoryTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style])
    {
        self.delegate = self;
        self.dataSource = self;
        _dataDic = [[YJFileManage returnAllAccessory] copy];
        _allKeysArr = [_dataDic allKeys];
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
//        [self registerNib:<#(nullable UINib *)#> forHeaderFooterViewReuseIdentifier:<#(nonnull NSString *)#>]
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataDic.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *tempStr = _allKeysArr[section];
    return [_dataDic[tempStr] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    NSString * tempStr = _allKeysArr[indexPath.section];
    cell.textLabel.text = _dataDic[tempStr][indexPath.row];
    return cell;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _allKeysArr[section];
}
@end
