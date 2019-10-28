//
//  BasicNav.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/10/26.
//  Copyright © 2019年 D. All rights reserved.
//

#import "BasicNav.h"

@interface BasicNav ()

@end


@implementation BasicNav

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    UIViewController * vc = [[UIStoryboard storyboardWithName:Basic_StoryBoard bundle:nil] instantiateViewControllerWithIdentifier:@"BasicRootVC_SBID"];
    [self pushViewController:vc animated:NO];
}

@end
