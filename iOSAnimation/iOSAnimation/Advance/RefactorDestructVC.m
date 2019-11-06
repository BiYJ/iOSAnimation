//
//  RefactorDestructVC.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/11/5.
//  Copyright © 2019年 D. All rights reserved.


#import "RefactorDestructVC.h"

@interface RefactorDestructVC ()
@property (nonatomic, strong) UIImageView * imageView;
@end


@implementation RefactorDestructVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 580/428)];
    self.imageView.image = [UIImage imageNamed:@"HY"];
    [self.view addSubview:self.imageView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

    });
}

@end
