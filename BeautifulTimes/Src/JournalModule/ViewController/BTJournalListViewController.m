//
//  BTJournalListViewController.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/21.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "BTJournalListViewController.h"
#import "BTJournalListItem.h"
#import "Journal.h"
#import "BTJournalManager.h"
#import "BTEditJournalViewController.h"

static NSString *kJournalCellIdentifier = @"kJournalCellIdentifier";

@interface BTJournalListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *keys;
@property (nonatomic, strong) NSMutableDictionary *dataSource;

@end

@implementation BTJournalListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"日记集";
    [self initDataSource];
    [self.bodyView addSubview:self.tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadJournalList)
                                                 name:kUpdateJournalInfo
                                               object:self];
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadJournalList {
    [self initDataSource];
    [self.tableView reloadData];
}

- (void)initDataSource {
    [self.dataSource removeAllObjects];
    [self.keys removeAllObjects];
    
    [[[BTJournalManager shareInstance] getAllJournalData] enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Journal *journal = obj;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM"];
        NSString *key = [formatter stringFromDate:journal.journalDate];
        
        NSArray *arr = [self.dataSource objectForKey:key];
        NSMutableArray *journals;
        //如果没有值
        if(!arr){
            journals = [NSMutableArray arrayWithObject:journal];
        }else{
            journals = [NSMutableArray arrayWithArray:arr];
            [journals addObject:journal];
        }
        [self.dataSource setObject:journals forKey:key];
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
    BTJournalListItem *cell = [tableView dequeueReusableCellWithIdentifier:kJournalCellIdentifier];
    if (!cell) {
        cell = [[BTJournalListItem alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kJournalCellIdentifier];
    }
    NSString *key = self.keys[indexPath.section];
    NSArray *arr = [self.dataSource objectForKey:key];
    [cell bindDate:arr[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTEditJournalViewController *vc = [[BTEditJournalViewController alloc] init];
    NSString *key = self.keys[indexPath.section];
    NSArray *arr = [self.dataSource objectForKey:key];
    vc.journal = arr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
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
