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


@end

@implementation RecentInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
//    self.table.is
//    
//    [Parse setApplicationId:@"uMliPzHbld4jXu2ioup34R072sw1ZXICsH9dGfQf"
//                  clientKey:@"egCJvN7YFduMUAijnG7icLW1hlEmwS7bDOwLlodk"];
    
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
#warning send push online pls
        
}


- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



