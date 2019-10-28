//
//  AdvanceNav.m
//  iOSAnimation
//
//  Created by CYKJ on 2019/10/26.
//  Copyright © 2019年 D. All rights reserved.
//

#import "AdvanceNav.h"

@interface AdvanceNav ()

@end

@implementation AdvanceNav

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIViewController * vc = [[UIStoryboard storyboardWithName:Advance_StoryBoard bundle:nil] instantiateViewControllerWithIdentifier:@"AdvanceRootVC_SBID"];
    [self pushViewController:vc animated:NO];
}

@end
