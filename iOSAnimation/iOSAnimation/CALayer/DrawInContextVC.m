//
//  DrawInContextVC.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/10/24.
//  Copyright © 2019年 D. All rights reserved.


#import "DrawInContextVC.h"
#import "CustomView.h"

/**     自定义图层绘图    **/
@interface DrawInContextVC ()

@end


@implementation DrawInContextVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CustomView * view = [[CustomView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    [self.view addSubview:view];
}

@end
