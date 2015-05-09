//
//  InterfaceController.m
//  SoundBomber WatchKit Extension
//
//  Created by Jake Saferstein on 5/4/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "InterfaceController.h"
#import <Parse/Parse.h>
#import <MMWormhole/MMWormhole.h>


@interface InterfaceController()

@property (strong, nonatomic) IBOutlet WKInterfaceButton *mainButton;
@property (nonatomic) MMWormhole* wormHole;

@end


@implementation InterfaceController

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
        
        [InterfaceController openParentApplication:@{@"operation":@"getUserId"} reply:^(NSDictionary *replyInfo, NSError *error) {
            NSString* senderId = replyInfo[@"response"];
            
            if(senderId.length == 0) {
                NSLog(@"Error retrieving cur user");
                return;
            }
            
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


- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    
//    [Parse enableDataSharingWithApplicationGroupIdentifier:@"group.com.gmail.jakesafo.SoundBomber"
//                                     containingApplication:@"com.gmail.jakesafo.SoundBomber"];
    
    [Parse setApplicationId:@"uMliPzHbld4jXu2ioup34R072sw1ZXICsH9dGfQf"
                  clientKey:@"egCJvN7YFduMUAijnG7icLW1hlEmwS7bDOwLlodk"];
    
    _wormHole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.com.gmail.jakesafo.SoundBomber"
                                                     optionalDirectory:@"wormhole"];
    
    
    
    UIImage* img = [_wormHole messageWithIdentifier:@"blendedImg"];
    
    if(img)
    {
        [self.mainButton setBackgroundImage: img];
    }
    
    [_wormHole listenForMessageWithIdentifier:@"blendedImg" listener:^(id messageObject) {
        [self.mainButton setBackgroundImage:(UIImage *)messageObject];
    }];
}
- (IBAction)speakerPressed {
    
    NSDictionary* message = @{ @"operation":@"localFart",
                               };
    
    [WKInterfaceController openParentApplication:message reply:^(NSDictionary *replyInfo, NSError *error) {
        NSLog(@"%@", replyInfo[@"response"]);
    }];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

-(void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    NSLog(@"poop");
}

@end



