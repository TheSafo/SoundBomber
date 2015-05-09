//
//  RemoveAdsViewController.m
//  SoundBomber
//
//  Created by Jake Saferstein on 5/8/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "RemoveAdsViewController.h"
#import "AdSingleton.h"

@interface RemoveAdsViewController ()

@property (nonatomic) UIButton* purchButton;

@end

@implementation RemoveAdsViewController

-(instancetype) init
{
    if(self = [super init]) {
        
        int w = self.view.frame.size.width;
        int h = self.view.frame.size.height;
        
        _purchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _purchButton.frame = CGRectMake(w/2 - 75, h/2 - 30, 150, 60);
        [_purchButton addTarget:self action:@selector(purchasePressed) forControlEvents:UIControlEventTouchUpInside];
        [_purchButton setTitle:@"Remove Ads" forState:UIControlStateNormal];
        [_purchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _purchButton.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1]; //FB blue//[UIColor colorWithRed:149.0/255.0 green:205.0/255.0 blue:222.0/255.0 alpha:1];
        _purchButton.layer.cornerRadius = 5;
        _purchButton.layer.borderWidth = 2;
        
        
        self.view.backgroundColor = [UIColor colorWithRed:149.0/255.0 green:205.0/255.0 blue:222.0/255.0 alpha:1];
    }
    return self;
}

//    self.tabBar.barTintColor = [UIColor colorWithRed:149.0/255.0 green:205.0/255.0 blue:222.0/255.0 alpha:1];


-(void) purchasePressed
{
    [[StoreManager sharedInstance] purchaseAds];
}

-(void)viewWillAppear:(BOOL)animated
{
    if(!ADS_ON)
    {
        int w = self.view.frame.size.width;
        int h = self.view.frame.size.height;
        
        UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(w/2 - 75, h/2-30, 150, 60)];
        lbl.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1]; //FB blue
        lbl.text = @"To remove this view restart the app.";
        lbl.numberOfLines = 2;
        lbl.minimumScaleFactor = .5;
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.layer.borderWidth = 2;
        lbl.layer.cornerRadius = 5;
        [self.view addSubview:lbl];
    }
    else {
        
        [self.view addSubview:_purchButton];
    }
}

@end
