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


@end

@implementation RecentInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    

    

}



-(void)showPlaceholder
{
    
}

-(void) loadTable
{
    if(_userList.count == 0) {
        
        [self showPlaceholder];
        return;
    }
    
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
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



