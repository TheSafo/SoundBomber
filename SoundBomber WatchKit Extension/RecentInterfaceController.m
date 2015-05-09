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
@property (nonatomic) MMWormhole* wormHole;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *placeholderLabel;
@property (nonatomic) NSString* userId;
@property (strong, nonatomic) IBOutlet WKInterfaceTimer *timer;
@property (nonatomic) BOOL timerOn;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *sentLabel;



@end

@implementation RecentInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    _timerOn = NO;
    
    [self.sentLabel setHidden:YES];
//    self.table.is
//    
//    [Parse setApplicationId:@"uMliPzHbld4jXu2ioup34R072sw1ZXICsH9dGfQf"
//                  clientKey:@"egCJvN7YFduMUAijnG7icLW1hlEmwS7bDOwLlodk"];
    
    NSArray* recentIds = [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.gmail.jakesafo.SoundBomber"] valueForKey:@"recent"];
    
    if(recentIds.count == 0) {
        [self showPlaceholder];
        return;
    }
    
    [RecentInterfaceController openParentApplication:@{@"operation":@"getUserId"} reply:^(NSDictionary *replyInfo, NSError *error) {
        _userId = replyInfo[@"response"];
    }];
    
    
    PFQuery* usrQry = [PFUser query];
    [usrQry whereKey:@"objectId" containedIn:recentIds];
    
    [usrQry findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        _userList = [NSMutableArray arrayWithArray:objects];
    }];

}


-(void)showPlaceholder
{
    [self.placeholderLabel setHidden:NO];
    [self.table setHidden:YES];
    [self.timer setHidden:YES];
}

-(void)timerDone
{
    [self.timer setHidden:YES];
    [self.sentLabel setHidden:NO];
    
    [self performSelector:@selector(reshowTable) withObject:nil afterDelay:3];
}

-(void)reshowTable
{
    [self.sentLabel setHidden:YES];
    [self.table setHidden:NO];
    [self loadTable];
    _timerOn = NO;
}


-(void) loadTable
{
    if(_userList.count == 0) {
        
        [self showPlaceholder];
        return;
    }
    
    [self.placeholderLabel setHidden:YES];
    [self.timer setHidden:YES];
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
    if(_timerOn)
    {
        return;
    }
    if (_userList.count == 0) {
        [self showPlaceholder];
    }
    else {
        [self loadTable];
    }
}

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

-(void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex
{
    [self updateAfterPushTo: _userList[rowIndex]];
    
    NSString* toSendId = ((PFUser *)_userList[rowIndex]).objectId;
    NSString* senderId = _userId;
    NSString* soundName = [self randomSoundName];
    
    NSDictionary* params = @{ @"senderId": senderId, @"toSendId": toSendId, @"soundName": soundName };
    
    [PFCloud callFunctionInBackground:@"sendPush" withParameters:params block:^(id object, NSError *error) {
        if(error) { NSLog(@"Cloud error: %@", error); }
    }];
        
}


-(void)updateAfterPushTo: (PFUser *)toSend
{
    [self.table setHidden:YES];
    [self.placeholderLabel setHidden:YES];
    [self.timer setHidden:NO];
    
    
    int x = arc4random_uniform(4) + 3;
    
    [NSTimer scheduledTimerWithTimeInterval:x target:self selector:@selector(timerDone) userInfo:nil repeats:NO];
    [self.timer setDate:[NSDate dateWithTimeIntervalSinceNow:x]];
    [self.timer start];
    _timerOn = YES;
    
    
//    NSMutableArray* revenge = [PFUser currentUser];
    NSMutableArray* recent = _userList;
    //    NSMutableArray* friends = _friendsLists[2];
//    
//    if([revenge containsObject:toSend])
//    {
//        [revenge removeObject:toSend];
//    }
//    
    
    if([recent containsObject:toSend])
    {
        [recent removeObject:toSend];
    }
    if (recent.count == 5) {
        [recent removeLastObject];
    }
    [recent insertObject:toSend atIndex:0];
    
    //Save recent + revenge list
    
    NSMutableArray* recentIds = [NSMutableArray array];
    for (int x = 0; x < recent.count; x++) {
        recentIds[x] = ((PFUser *)recent[x]).objectId;
    }
    
    [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.gmail.jakesafo.SoundBomber"] setObject:recentIds forKey:@"recent"];
    _userList = recent;
    
//    [PFUser currentUser][@"revenge"] = revenge;
//    [[PFUser currentUser] saveInBackground];
//    
    
//    [self loadTable];
}


- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



