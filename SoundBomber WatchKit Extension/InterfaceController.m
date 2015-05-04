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

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    
    [Parse enableDataSharingWithApplicationGroupIdentifier:@"group.com.gmail.jakesafo.SoundBomber"
                                     containingApplication:@"com.gmail.jakesafo.SoundBomber"];
    
    [Parse setApplicationId:@"uMliPzHbld4jXu2ioup34R072sw1ZXICsH9dGfQf"
                  clientKey:@"egCJvN7YFduMUAijnG7icLW1hlEmwS7bDOwLlodk"];
    
    
    
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

@end



