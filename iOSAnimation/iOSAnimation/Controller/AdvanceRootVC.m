//
//  AdvanceRootVC.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/10/26.
//  Copyright © 2019年 D. All rights reserved.


#import "AdvanceRootVC.h"

@interface AdvanceRootVC ()

@property (nonatomic, copy) NSArray * dataArray;

@end


@implementation AdvanceRootVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
}


#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataArray[indexPath.row][@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:self.dataArray[indexPath.row][@"vcSBID"]];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - GET

- (NSArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = @[ @{ @"title" : @"1. 画企鹅", @"vcSBID" : @"DrawQQVC_SBID" },
                        @{ @"title" : @"2. 进度条", @"vcSBID" : @"ProgressVC_SBID" },
                        @{ @"title" : @"3. 转场动画", @"vcSBID" : @"TransitioningVC_A_SBID" },
                        @{ @"title" : @"4. 弹幕", @"vcSBID" : @"BarrageVC_SBID" },
                        @{ @"title" : @"5. 波浪进度", @"vcSBID" : @"WaveProgressVC_SBID" } ];
    }
    return _dataArray;
}

@end
