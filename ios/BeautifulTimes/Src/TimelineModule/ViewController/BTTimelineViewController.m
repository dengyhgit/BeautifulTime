//
//  BTTimelineViewController.m
//  BeautifulTimes
//
//  Created by deng on 15/12/6.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTTimelineViewController.h"
#import "BTTimelineDBManager.h"
#import "BTTimelineListItem.h"
#import "BTTimelineModel.h"
#import "BTTimelineDetailViewController.h"

#define kTimelineListCell @"kTimelineListCell"

@interface BTTimelineViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *keys;
@property (nonatomic, strong) NSMutableDictionary *dataSource;

@end

@implementation BTTimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"时光轴";
    [self initDataSource];
    [self.bodyView addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    WS(weakSelf);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.bodyView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)reloadTimelineList {
    [self initDataSource];
    [self.tableView reloadData];
}

- (void)initDataSource {
    [self.dataSource removeAllObjects];
    [self.keys removeAllObjects];
    
    [[[BTTimelineDBManager sharedInstance] getAllTimelineMessage] enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BTTimelineModel *timeline = obj;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM"];
        NSString *key = [formatter stringFromDate:timeline.timelineDate];
        
        NSArray *arr = [self.dataSource objectForKey:key];
        NSMutableArray *timelines;
        //如果没有值
        if(!arr){
            timelines = [NSMutableArray arrayWithObject:timeline];
        }else{
            timelines = [NSMutableArray arrayWithArray:arr];
            [timelines addObject:timeline];
        }
        [self.dataSource setObject:timelines forKey:key];
    }];
    
    NSArray *key = [self.dataSource allKeys];
    
    NSArray *k = [key sortedArrayUsingSelector:@selector(compare:)];
    [self.keys addObjectsFromArray:k];
}

#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = self.keys[section];
    NSArray *arr = [self.dataSource objectForKey:key];
    return arr.count;
}

#pragma mark 设置每个区的标题
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = self.keys[section];
    return title;
}

#pragma mark 返回分区头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 25;
    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTTimelineListItem *cell = [tableView dequeueReusableCellWithIdentifier:kTimelineListCell];
    if (!cell) {
        cell = [[BTTimelineListItem alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTimelineListCell];
    }
    NSString *key = self.keys[indexPath.section];
    NSArray *arr = [self.dataSource objectForKey:key];
    [cell bindDate:arr[indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTTimelineDetailViewController *vc = [[BTTimelineDetailViewController alloc] init];
    NSString *key = self.keys[indexPath.section];
    NSArray *arr = [self.dataSource objectForKey:key];
    BTTimelineModel *timeline = arr[indexPath.row];
    vc.timeline = timeline;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableDictionary *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableDictionary alloc] init];
    }
    
    return _dataSource;
}

- (NSMutableArray *)keys
{
    if(!_keys) {
        _keys = [[NSMutableArray alloc] init];
    }
    return _keys;
}

@end
