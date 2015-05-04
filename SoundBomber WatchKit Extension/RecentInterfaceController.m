//
//  RecentInterfaceController.m
//  SoundBomber
//
//  Created by Jake Saferstein on 5/4/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import <Parse/Parse.h>
#import "RecentInterfaceController.h"

@interface RecentInterfaceController ()

@end

@implementation RecentInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    [Parse setApplicationId:@"uMliPzHbld4jXu2ioup34R072sw1ZXICsH9dGfQf"
                  clientKey:@"egCJvN7YFduMUAijnG7icLW1hlEmwS7bDOwLlodk"];
    
    // Configure interface objects here.
    
//    NSArray* friendIds = [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.gmail.jakesafo.SoundBomber"] objectForKey:@"recent"];
    
    NSDictionary* message = @{@"operation":@"getRecent"};
    
    [WKInterfaceController openParentApplication:message reply:^(NSDictionary *replyInfo, NSError *error) {
        
        
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



