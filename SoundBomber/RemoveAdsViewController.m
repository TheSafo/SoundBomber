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
@property (nonatomic) UIButton* restorePurchase;

@end

@implementation RemoveAdsViewController

-(instancetype) init
{
    if(self = [super init]) {
        
        int w = self.view.frame.size.width;
        int h = self.view.frame.size.height;
        
        _purchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _purchButton.frame = CGRectMake(w/2 - 75, h/2 - 100, 150, 60);
        [_purchButton addTarget:self action:@selector(purchasePressed) forControlEvents:UIControlEventTouchUpInside];
        [_purchButton setTitle:@"Remove Ads" forState:UIControlStateNormal];
        [_purchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _purchButton.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1]; //FB blue
        _purchButton.layer.cornerRadius = 5;
        _purchButton.layer.borderWidth = 2;
        

        _restorePurchase = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _restorePurchase.frame = CGRectMake(w/2 - 75, h/2 - 30, 150, 60);
        [_restorePurchase addTarget:self action:@selector(restorePressed) forControlEvents:UIControlEventTouchUpInside];
        [_restorePurchase setTitle:@"Restore Purchases" forState:UIControlStateNormal];
        [_restorePurchase setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _restorePurchase.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1]; //FB blue
        _restorePurchase.layer.cornerRadius = 5;
        _restorePurchase.layer.borderWidth = 2;
        
        if(ADS_ON) {
            [self.view addSubview:_purchButton];
        }
        [self.view addSubview:_restorePurchase];

        
        
        self.view.backgroundColor = [UIColor colorWithRed:149.0/255.0 green:205.0/255.0 blue:222.0/255.0 alpha:1];
    }
    return self;
}

-(void) purchasePressed
{
    [[StoreManager sharedInstance] purchaseAds];
}

-(void) restorePressed
{
    [[StoreManager sharedInstance] restorePurchase];
}



@end
