//
//  BasicRootVC.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/10/26.
//  Copyright © 2019年 D. All rights reserved.


#import "BasicRootVC.h"

@interface BasicRootVC ()  <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView * tableView;
@property (nonatomic, copy) NSArray * dataArray;

@end


@implementation BasicRootVC

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
        _dataArray = @[ @{ @"title" : @"1. 系统隐式动画", @"vcSBID" : @"CALayerVC_SBID" },
                        @{ @"title" : @"2. 代理方法绘图", @"vcSBID" : @"DrawLayerInContextVC_SBID" },
                        @{ @"title" : @"3. 自定义图层绘图", @"vcSBID" : @"DrawInContextVC_SBID" },
                        @{ @"title" : @"4. 基础动画", @"vcSBID" : @"BasicAnimationVC_SBID" },
                        @{ @"title" : @"5. 关键帧动画", @"vcSBID" : @"KeyFrameAnimationVC_SBID" },
                        @{ @"title" : @"6. 动画组", @"vcSBID" : @"AnimationGroupVC_SBID" },
                        @{ @"title" : @"7. 转场动画", @"vcSBID" : @"TransitionAnimationVC_SBID" },
                        @{ @"title" : @"8. 逐帧动画", @"vcSBID" : @"DisplayLinkVC_SBID" },
                        @{ @"title" : @"9. 弹簧动画", @"vcSBID" : @"SpringAnimationVC_SBID" },
                        @{ @"title" : @"10. 关键帧动画（UIView）", @"vcSBID" : @"KeyframeInViewVC_SBID" },
                        @{ @"title" : @"11. 转场动画（UIView）", @"vcSBID" : @"TransitionInViewVC_SBID" },
                        @{ @"title" : @"12. 仿射变换", @"vcSBID" : @"AffineTransformVC_SBID" } ];
    }
    return _dataArray;
}

@end
