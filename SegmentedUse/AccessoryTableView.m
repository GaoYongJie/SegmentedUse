//
//  AccessoryTableView.m
//  SegmentedUse
//
//  Created by 高永杰 on 2017/7/13.
//  Copyright © 2017年 GYJ. All rights reserved.
//

#import "AccessoryTableView.h"
#import "YJFileManage.h"
#import "AccessorySectionHeadView.h"
#import "SectionMode.h"
static NSString * const kCellIdentifier = @"asdfasfwe";
static NSString * const kHeadIdentifier = @"asdfewfadc";
@interface AccessoryTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSDictionary  * dataDic;
@property (nonatomic, copy) NSArray  * allKeysArr;
@property (nonatomic, copy) NSMutableArray * sectionData;

@end

@implementation AccessoryTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style])
    {
        self.delegate = self;
        self.dataSource = self;
        self.sectionHeaderHeight = 40;
        self.rowHeight = 60;
        _dataDic = [[YJFileManage returnAllAccessory] copy];
        _allKeysArr = [_dataDic allKeys];
        _sectionData = [NSMutableArray array];
        
        for (NSString *title in _allKeysArr)
        {
            SectionMode * model = [SectionMode new];
            model.isExpanded = NO;
            model.sectionTitle = title;
            model.rowNum = [_dataDic[title] count];
            [_sectionData addObject:model];
        }
        self.backgroundColor = [UIColor whiteColor];
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        [self registerNib:[UINib nibWithNibName:@"AccessorySectionHeadView" bundle:nil] forHeaderFooterViewReuseIdentifier:kHeadIdentifier];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataDic.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    SectionMode *mode = _sectionData[section];
    if (mode.isExpanded)
    {
        return mode.rowNum;
    }
    else
    {
        return 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    NSString * tempStr = _allKeysArr[indexPath.section];
    cell.textLabel.text = _dataDic[tempStr][indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    AccessorySectionHeadView * headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kHeadIdentifier];
    headView.mode = _sectionData[section];
    headView.clickBlock = ^{
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    };
    headView.backgroundColor = [UIColor redColor];
    return headView;
}
@end
