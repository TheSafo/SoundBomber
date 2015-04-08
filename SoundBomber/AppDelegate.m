//
//  AppDelegate.m
//  SoundBomber
//
//  Created by Jake Saferstein on 4/6/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "AppDelegate.h"
#import "SAFTabBarController.h"
#import <AVFoundation/AVFoundation.h>
#import <Parse/Parse.h>
#import "PFFacebookUtils.h"
#import <MMWormhole/MMWormhole.h>
#import "OfflineViewController.h"

@interface AppDelegate ()

@property (nonatomic) MMWormhole* wormHole;

@property (nonatomic) UITabBarController* rootCtrlr;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    /* Start Audio for the app */
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
#warning parse later
    //    [Parse setApplicationId:@"U3jYooMOP5sHRj6R9WYR6cwzE3vQQavKBPF1jJ80" clientKey:@"gVOe8Xxnn1RymITkY7ddbNiP396IvrdMyy8vf4k6"];
    //    [PFFacebookUtils initializeFacebook];
    //    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    _rootCtrlr = [[SAFTabBarController alloc] init];
    
    /* START THE WORMHOLE (for watch app) */
    _wormHole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.com.gmail.jakesafo.fartbomber"
                                                     optionalDirectory:@"wormhole"];
    
    UIImage* speakerImg = [_wormHole messageWithIdentifier:@"speakerImg"];
    if (speakerImg.size.width == 0) {
        speakerImg = [UIImage imageNamed:@"speaker1"];
        [_wormHole passMessageObject:speakerImg identifier:@"speakerImg"];
    }
    
    UIImage* otherImg = [_wormHole messageWithIdentifier:@"otherImg"];
    if(otherImg.size.width == 0) {
        otherImg = [UIImage imageNamed:@"otherImg1.jpg"];
        [_wormHole passMessageObject:otherImg identifier:@"otherImg"];
    }
    
    
    OfflineViewController* ctlr1 = [[OfflineViewController alloc] initWithSpeakerImage: speakerImg andOtherImg: otherImg];
    UIViewController* ctlr2 = [[UIViewController alloc] init];
    ctlr1.title = @"Foo";
    ctlr2.title = @"Bar";
    
    [_rootCtrlr setViewControllers:@[ctlr1, ctlr2]];
    [self.window setRootViewController:_rootCtrlr];
    

    
    // Register for Push Notitications
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
