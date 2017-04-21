//
//  TotalViewController.m
//  IQI
//
//  Created by 王玉 on 2017/4/20.
//  Copyright © 2017年 orbyun. All rights reserved.
//

#import "TotalViewController.h"
#import "TotalViewCell.h"
//跳转的页面
#import "ViewController.h"

@interface TotalViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * table;

@property (nonatomic,strong) NSMutableArray * controllerArr;
@end

@implementation TotalViewController

-(UITableView *)table{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _table;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage getImageWithColor:[UIColor colorWithRed:61/255.f green:192/255.f blue:196/255.f alpha:1.f]] forBarMetrics:UIBarMetricsDefault];
    _controllerArr = @[@[@"ViewController",@"CollectionView"],@[@"ButtonViewController",@"分散按钮"],@[@"",@"POP"],@[@"",@"YYKit"]].mutableCopy;
    self.table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TotalViewCell *cell = [_table dequeueReusableCellWithIdentifier:@"TotalCell"];
    if (!cell) {
        cell = [[TotalViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TotalCell"];
    }
    if (indexPath.row < _controllerArr.count) {
        [cell setAttributedForLabelWithStr:_controllerArr[indexPath.row] imageName:nil];
    }else{
        [cell setAttributedForLabelWithStr:nil imageName:nil];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < _controllerArr.count) {
        UIViewController *collection = [[NSClassFromString(_controllerArr[indexPath.row][0]) alloc]init];
        [self.navigationController pushViewController:collection animated:YES];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"这里没有跳转" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Action的样式是UIAlertActionStyleDefault");
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
@end
