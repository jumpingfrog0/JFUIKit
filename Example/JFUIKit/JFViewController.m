//
//  JFViewController.m
//  JFUIKit
//
//  Created by jumpingfrog0 on 09/10/2018.
//  Copyright (c) 2018 jumpingfrog0. All rights reserved.
//

#import "JFViewController.h"
#import <JFUIKit/JFUIKit.h>

@interface JFViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation JFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.imageView.image = [UIImage jf_imageNamedInJFUIKitBundle:@"nav-bar-dark-back-btn"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [UINavigationBar appearance];
}

@end
