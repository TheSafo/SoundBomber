//
//  SAFTabBarController.m
//  SoundBomber
//
//  Created by Jake Saferstein on 4/6/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "SAFTabBarController.h"

@interface SAFTabBarController ()

@end

@implementation SAFTabBarController


- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
        
        self.delegate = self;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBar.layer.backgroundColor = [UIColor redColor].CGColor;
}

@end
