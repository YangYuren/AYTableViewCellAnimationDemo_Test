//
//  ay_TestViewController.m
//  TableVeiwAnimationTest
//
//  Created by Yang on 2017/9/21.
//  Copyright © 2017年 Tucodec. All rights reserved.
//

#import "ay_TestViewController.h"
#import "AYTableViewAnimation.h"
#import <Masonry.h>
@interface ay_TestViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end
@implementation ay_TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self commonInitialization];
}

- (void)commonInitialization {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.delaysContentTouches = NO;
        _tableView.rowHeight = 90;
        //设置加载动画
        _tableView.ay_reloadAnimationType = self.type;
        
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    self.view = _tableView;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(ay_reload)];
}

- (void)ay_reload {
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"_cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"_cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = [UIColor darkGrayColor];
        button.layer.cornerRadius = 5;
        [cell.contentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width - 20);
            make.height.mas_equalTo(tableView.rowHeight - 20);
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(10);
        }];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell AY_presentAnimateSlideFromLeft];
}

@end
