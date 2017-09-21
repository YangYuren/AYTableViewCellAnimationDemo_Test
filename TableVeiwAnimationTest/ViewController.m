//
//  ViewController.m
//  TableVeiwAnimationTest
//
//  Created by Yang on 2017/9/21.
//  Copyright © 2017年 Tucodec. All rights reserved.
//

#import "ViewController.h"
#import "ay_TestViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)NSMutableArray * arr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
}
#pragma mark --- delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"_cell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"_cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"动画:%@",self.arr[indexPath.row]];
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ay_TestViewController * vc = [[ay_TestViewController alloc] init];
    vc.type = indexPath.row + 1;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark --- lazy
-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
-(NSMutableArray *)arr{
    if(!_arr){
        _arr = [NSMutableArray array];
        [_arr addObject:@"左滑到右"];
        [_arr addObject:@"右滑到左"];
        [_arr addObject:@"渐变"];
        [_arr addObject:@"从上往下落"];
        [_arr addObject:@"从下往上升"];
        [_arr addObject:@"左右层次滑动"];
        [_arr addObject:@"书面左右翻转"];
        [_arr addObject:@"书面上下翻转"];
        [_arr addObject:@"从上往下小变大"];
        [_arr addObject:@"从下往上小变大"];
    }
    return _arr;
}
@end
