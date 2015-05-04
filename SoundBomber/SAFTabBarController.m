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
    
    self.tabBar.translucent = YES;
    self.tabBar.barTintColor = [UIColor colorWithRed:149.0/255.0 green:205.0/255.0 blue:222.0/255.0 alpha:1];
//    self.tabBar.layer.backgroundColor = [UIColor colorWithRed:149.0/255.0 green:205.0/255.0 blue:222.0/255.0 alpha:1].CGColor;
//    self.tabBar.backgroundColor = [UIColor colorWithRed:149.0/255.0 green:205.0/255.0 blue:222.0/255.0 alpha:1];//[UIColor yellowColor].CGColor;
    self.tabBar.tintColor = [UIColor blackColor];
    

}

@end
