//
//  NotificationController.m
//  SoundBomber WatchKit Extension
//
//  Created by Jake Saferstein on 5/4/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "NotificationController.h"
#import <Parse/Parse.h>


@interface NotificationController()

@end


@implementation NotificationController

- (instancetype)init {
    self = [super init];
    if (self){
        
//        [Parse enableDataSharingWithApplicationGroupIdentifier:@"group.com.gmail.jakesafo.SoundBomber"
//                                         containingApplication:@"com.gmail.jakesafo.SoundBomber"];
        
        [Parse setApplicationId:@"uMliPzHbld4jXu2ioup34R072sw1ZXICsH9dGfQf"
                      clientKey:@"egCJvN7YFduMUAijnG7icLW1hlEmwS7bDOwLlodk"];
        // Initialize variables here.
        // Configure interface objects here.
        
//        self.
        
    }
    return self;
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

/*
- (void)didReceiveLocalNotification:(UILocalNotification *)localNotification withCompletion:(void (^)(WKUserNotificationInterfaceType))completionHandler {
    // This method is called when a local notification needs to be presented.
    // Implement it if you use a dynamic notification interface.
    // Populate your dynamic notification interface as quickly as possible.
    //
    // After populating your dynamic notification interface call the completion block.
    completionHandler(WKUserNotificationInterfaceTypeCustom);
}
*/

//-(void)sendPushFromUser: (PFUser *)sender touser: (PFUser *)toSend withSoundName: (NSString *)soundType
//{
//    int x = arc4random_uniform(7) + 1;
//    NSString* sound = [NSString stringWithFormat:@"%@%i.caf", soundType, x]; ///Randomizes sound!!!
//    
//    NSDictionary* params = @{ @"senderId": sender.objectId, @"toSendId": toSend.objectId, @"soundName": sound   };
//    
//    [PFCloud callFunctionInBackground:@"sendPush" withParameters:params block:^(id object, NSError *error) {
//        if(error) { NSLog(@"Cloud error: %@", error); }
//    }];
//}

-(NSString *)randomSoundName
{
    NSMutableDictionary* enabledSounds = [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.gmail.jakesafo.SoundBomber"] objectForKey:@"enabledSounds"];
    
    NSMutableArray* toChooseFrom = [NSMutableArray array];
    for (NSString* str in enabledSounds.allKeys) {
        id isEnabled = enabledSounds[str];
        
        if([isEnabled boolValue])
        {
            [toChooseFrom addObject:str];
        }
    }
    
    int x = arc4random_uniform((int) toChooseFrom.count);
    NSString* chosen = toChooseFrom[x];
    
    int y = arc4random_uniform(7) + 1; //7 random sounds per sound
    
    NSString* fileName = [NSString stringWithFormat:@"%@%i", chosen, y];
    
    return fileName;
}

-(void)handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)remoteNotification
{
    if([identifier isEqualToString:@"revenge"]) {
        
        NSString* toSendId = remoteNotification[@"senderId"];
        
        [NotificationController openParentApplication:@{@"operation":@"getUserId"} reply:^(NSDictionary *replyInfo, NSError *error) {
            NSString* senderId = replyInfo[@"response"];
            NSString* soundName = [self randomSoundName];
            
            NSDictionary* params = @{ @"senderId": senderId, @"toSendId": toSendId, @"soundName": soundName };

            [PFCloud callFunctionInBackground:@"sendPush" withParameters:params block:^(id object, NSError *error) {
                if(error) { NSLog(@"Cloud error: %@", error); }
            }];
            
        }];
    }
    else {
        NSLog(@"cant handle action");
    }
}

//- (void)didReceiveRemoteNotification:(NSDictionary *)remoteNotification withCompletion:(void (^)(WKUserNotificationInterfaceType))completionHandler {
//    // This method is called when a remote notification needs to be presented.
//    // Implement it if you use a dynamic notification interface.
//    // Populate your dynamic notification interface as quickly as possible.
//    //
//    // After populating your dynamic notification interface call the completion block.
//    
//    
//    
//    completionHandler(WKUserNotificationInterfaceTypeCustom);
//}


@end



