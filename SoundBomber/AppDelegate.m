//
//  AppDelegate.m
//  SoundBomber
//
//  Created by Jake Saferstein on 4/6/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "AppDelegate.h"
#import "SAFTabBarController.h"
#import "OfflineViewController.h"
#import "OnlineViewController.h"
#import "AudioHelper.h"
#import "SAFParseHelper.h"

@interface AppDelegate ()

@property (nonatomic) BOOL  isActive;


@property (nonatomic) MMWormhole* wormHole;

@property (nonatomic) UITabBarController* rootCtrlr;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[StoreManager sharedInstance] updatePurchaseInfo];
    
    [AdSingleton sharedInstance].adBanner = [[ADBannerView alloc] initWithFrame:CGRectMake(0, -50, self.window.frame.size.width, 50)];
    [AdSingleton sharedInstance].adBanner.delegate = [AdSingleton sharedInstance];
    
    /* Start Audio for the app */
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    /* START THE WORMHOLE (for watch app) */
    _wormHole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.com.gmail.jakesafo.SoundBomber"
                                                     optionalDirectory:@"wormhole"];
    
    UIMutableUserNotificationAction *revenge = [[UIMutableUserNotificationAction alloc] init];
    
    // Define an ID string to be passed back to your app when you handle the action
    revenge.identifier = @"revenge";
    
    // Localized string displayed in the action button
    revenge.title = @"Get Revenge!";
    
    // If you need to show UI, choose foreground
    revenge.activationMode = UIUserNotificationActivationModeForeground;
    
    // Destructive actions display in red
    revenge.destructive = NO;
    
    // Set whether the action requires the user to authenticate
    revenge.authenticationRequired = NO;
    
    // First create the category
    UIMutableUserNotificationCategory *soundCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    // Identifier to include in your push payload and local notification
    soundCategory.identifier = @"revenge";
    
    // Add the actions to the category and set the action context
    [soundCategory setActions:@[revenge] forContext:UIUserNotificationActionContextDefault];
    
    // Set the actions to present in a minimal context
    [soundCategory setActions:@[revenge] forContext:UIUserNotificationActionContextMinimal];
    
    
    NSSet *categories = [NSSet setWithObject:soundCategory];
    
    
    // Register for Push Notitications
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:categories];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    
    
    
    [Parse enableLocalDatastore];
//    [Parse enableDataSharingWithApplicationGroupIdentifier:@"group.com.gmail.jakesafo.SoundBomber"];
    [Parse setApplicationId:@"uMliPzHbld4jXu2ioup34R072sw1ZXICsH9dGfQf"
                  clientKey:@"egCJvN7YFduMUAijnG7icLW1hlEmwS7bDOwLlodk"];
    [PFFacebookUtils initializeFacebook];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    _rootCtrlr = [[SAFTabBarController alloc] init];
    

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
    OnlineViewController* ctlr2 = [[OnlineViewController alloc] init];
    ctlr1.title = @"Speaker";
    ctlr2.title = @"Friends";
    
    UIImage* img1 = [UIImage imageNamed:@"speakerIcon"];
    ctlr1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Speaker" image:img1 tag:0];
    
    UIImage* img2 = [UIImage imageNamed:@"bombIcon"];
    ctlr2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Friends" image:img2 tag:1];
    

    
    [_rootCtrlr setViewControllers:@[ctlr1, ctlr2]];
    [self.window setRootViewController:_rootCtrlr];
    
    
    if(![[[NSUserDefaults alloc] initWithSuiteName:@"group.com.gmail.jakesafo.SoundBomber"] valueForKey:@"enabledSounds"]) {
        NSMutableDictionary* enabledSounds = [NSMutableDictionary dictionaryWithDictionary:@{ @"Fart":@YES, @"Scream":@YES, @"Horn":@YES }];
        [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.gmail.jakesafo.SoundBomber"] setValue:enabledSounds forKey:@"enabledSounds"];
        [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.gmail.jakesafo.SoundBomber"] setValue:@(1) forKey:@"soundVersion"];
    }
    



    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    _isActive = NO;
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    _isActive = NO;

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    _isActive = YES;
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
    _isActive = NO;

    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - WatchKit Handling

-(void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply
{
//    __block UIBackgroundTaskIdentifier identifier = UIBackgroundTaskInvalid;
//    dispatch_block_t endBlock = ^{
//        if (identifier != UIBackgroundTaskInvalid) {
//            [application endBackgroundTask:identifier];
//        }
//        identifier = UIBackgroundTaskInvalid;
//    };
    
//    identifier = [application beginBackgroundTaskWithExpirationHandler:endBlock];
    
    // Wacky but the block will capture the outer reply inside but then later we can still simply call reply - Thanks Dave D!
//    reply = ^(NSDictionary* replyInfo) {
//        reply(replyInfo);
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
//            endBlock();
//        });
//    };
    
    
    if([userInfo[@"operation"] isEqualToString:@"localFart"]) {
        [self localFart];
        reply(@{@"response":@"Farted Locally"});
        return;
    }
    else if([userInfo[@"operation"] isEqualToString:@"getRecent"]) {
        
        reply(@{@"response":[PFUser currentUser].objectId});
        return;
    }
    else if ([userInfo[@"operation"] isEqualToString:@"getUserId"]) {
        
        reply(@{@"response":[PFUser currentUser].objectId});
        return;
    }
}


-(void)localFart
{
    UIViewController* ctrlr =  ((UITabBarController*)self.window.rootViewController).selectedViewController;
    
    if(_isActive && [ctrlr respondsToSelector:@selector(speakerPressed)]) {
        
        NSLog(@"Pressing speaker manually");
        [(OfflineViewController *)ctrlr speakerPressed];
    }
    else if(_isActive) {
        
        NSLog(@"Playing fart sound");
        [[AudioHelper sharedInstance] playRandomApprovedSound];
    }
    else {
        
        NSLog(@"Sending local notification");
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date];
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.alertBody = @"from iWatch";
        notification.soundName = [AudioHelper randomSoundName];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}









@end
