//
//  SAFParseHelper.m
//  SoundBomber
//
//  Created by Jake Saferstein on 4/13/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "SAFParseHelper.h"

@interface SAFParseHelper ()

@end

@implementation SAFParseHelper

SINGLETON_IMPL(SAFParseHelper);


-(void) loginWithBlock:(void (^)(NSArray *friendArrs)) loginCompletion
{
    
    
//    [PFFacebookUtils logInWithPermissions:@[@"public_profile", @"user_friends"] block:^(PFUser *user, NSError *error) {
//        /* ... */
//        if (user) {
//            [JFParseFBFriends updateCurrentUserWithCompletion:^(BOOL success, NSError *error) {
//                /* ... */
//            }];
//        }
//    }];
    
        /* Get friends */
    
//        [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//            if(!error)
//            {
//                NSArray* friendObjects= [result objectForKey:@"data"];
//                NSMutableArray* tempFriendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
//                for (NSDictionary* friendObject in friendObjects) {
//                    [tempFriendIds addObject:[friendObject objectForKey:@"id"]];
//                }
//                
//                // Construct a PFUser query that will find friends whose facebook ids
//                // are contained in the current user's friend list.
//                PFQuery *friendQuery = [PFUser query];
//                [friendQuery whereKey:@"fbId" containedIn:tempFriendIds];
//                
//                [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//                    for (PFUser* temp in objects) {
//                        [self.friendIds addObject: temp.objectId];
//                    }
//                    NSLog(@"Done adding to friends list");
//                    
//                    [[PFUser currentUser] fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//                        self.revengeIds =  [[PFUser currentUser] objectForKey:@"revenge"]; //= @[@"9oPcwNoSjI"]; //= @[@"xFlcvadOFv"];
//                        self.recentIds = [PFUser currentUser][@"recent"];
//                        
//                        BombingViewController* nextCtrlr = [[BombingViewController alloc] initWithStyle:UITableViewStylePlain andRevengeList:self.revengeIds andRecentList:self.recentIds andFriendsList:self.friendIds];
//                        [self.navigationController pushViewController:nextCtrlr animated:YES];
//                        
//                    }];
//                }];
//            }
//        }];
    
    
    loginCompletion(@[]);
}




@end
