//
//  RecentInterfaceController.m
//  SoundBomber
//
//  Created by Jake Saferstein on 5/4/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import <Parse/Parse.h>
#import "SAFRowController.h"
#import "RecentInterfaceController.h"
#import <MMWormhole/MMWormhole.h>

@interface RecentInterfaceController ()

@property (nonatomic) NSMutableArray* userList;
@property (strong, nonatomic) IBOutlet WKInterfaceTable *table;
@property (nonatomic) MMWormhole* wormHole;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *placeholderLabel;


@end

@implementation RecentInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    NSArray* recentIds = [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.gmail.jakesafo.SoundBomber"] valueForKey:@"recent"];
    
    if(recentIds.count == 0) {
        [self showPlaceholder];
        return;
    }
    
    PFQuery* usrQry = [PFUser query];
    [usrQry whereKey:@"objectId" containedIn:recentIds];
    
    [usrQry findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        _userList = [NSMutableArray arrayWithArray:objects];
//        [self loadTable];
    }];

}


-(void)showPlaceholder
{
    [self.placeholderLabel setHidden:NO];
    [self.table setHidden:YES];
}


-(void) loadTable
{
    if(_userList.count == 0) {
        
        [self showPlaceholder];
        return;
    }
    
    [self.placeholderLabel setHidden:YES];
    [self.table setHidden:NO];
    
    [self.table setNumberOfRows:_userList.count withRowType:@"SAFRowController"];
    
    [_userList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SAFRowController* row = [self.table rowControllerAtIndex:idx];
        
        PFUser* usr = (PFUser *)obj;
        
        NSString* name = usr[@"fullname"];
        NSData* imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", usr[@"fbId"]]]];
        UIImage* img = [UIImage imageWithData:imgData];
        
        [row.profPicView setImage:img];
        [row.nameLabel setText:name];
    }];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    if (_userList.count == 0) {
        [self showPlaceholder];
    }
    else {
        [self loadTable];
    }
}

+(NSString *)randomSoundName
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

-(void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex
{
#warning change pushes to online only
    PFUser* sender = [PFUser currentUser];
    PFUser* toSend = (PFUser *) _userList[rowIndex];
    
    PFQuery *qry = [PFInstallation query];
    [qry whereKey:@"user" equalTo:toSend];
    
    NSString* realMsg = [NSString stringWithFormat:@"from %@", sender[@"fullname"]];
    
    int x = arc4random_uniform(7) + 1;
    NSString* sound = [NSString stringWithFormat:@"%@%i.caf", [RecentInterfaceController randomSoundName], x]; ///Randomizes sound!!!
    NSDictionary *data = @{ @"alert" : realMsg,
                            @"sound" : sound,
                            @"senderID" : sender.objectId,
                            };
    
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:qry];
    [push setData:data];
    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error)
        {
            NSLog(@"Push Error: %@", error);
        }
    }];
    
    NSMutableArray* sendArr = [toSend objectForKey:@"revenge"];
    NSString* userStr = sender.objectId;
    
    if([sendArr containsObject:userStr])
    {
        [sendArr removeObject:userStr];
    }
    if (sendArr.count == 5) {
        [sendArr removeLastObject];
    }
    [sendArr insertObject:userStr atIndex:0];
    
    [PFCloud callFunctionInBackground:@"updateRevenge" withParameters:@{@"userId": toSend.objectId, @"newRev":sendArr} block:^(id object, NSError *error) {
        if(error) { NSLog(@"Cloud error: %@", error); }
    }];
}


- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



