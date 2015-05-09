//
//  AdSingleton.m
//  FartWatch
//
//  Created by Jake Saferstein on 3/11/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "AdSingleton.h"

@implementation AdSingleton

SINGLETON_IMPL(AdSingleton);

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"Retrieved an ad");
    
    
    if (![AdSingleton sharedInstance].bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        
        banner.frame = CGRectOffset(banner.frame, 0, 70);
        
        [UIView commitAnimations];
        
        [AdSingleton sharedInstance].bannerIsVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"Failed to retrieve ad");
    
    if ([AdSingleton sharedInstance].bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        
        // Assumes the banner view is placed at the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, -70);
        [UIView commitAnimations];
        
        [AdSingleton sharedInstance].bannerIsVisible = NO;
    }
}

@end
