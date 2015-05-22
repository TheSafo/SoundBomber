//
//  AdSingleton.h
//  FartWatch
//
//  Created by Jake Saferstein on 3/11/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import <iAd/iAd.h>


@interface AdSingleton : NSObject <ADBannerViewDelegate>

//SINGLETON_INTR(AdSingleton);

@property (nonatomic) BOOL bannerIsVisible;

@property (nonatomic) ADBannerView *adBanner;

@end
