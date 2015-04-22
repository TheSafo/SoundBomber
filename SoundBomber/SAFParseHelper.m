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

@synthesize recentIds,revengeIds,friendIds;


-(id)init
{
    if (self = [super init]) {
        self.revengeIds = [NSMutableArray array];
        self.recentIds = [NSMutableArray array];
    }
    return self;
}


-(void) loginWithBlock:(void (^)(NSArray *friendArrs)) loginCompletion
{
    
    if([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) /* If logged in */
    {
        //If we're logged in just update the friends only
        [JFParseFBFriends findFriendsAndUpdate:YES completion:^(BOOL success, BOOL localStore, NSArray *pfusers, NSError *error) {
            
            NSMutableArray* revUsrs = [NSMutableArray array];
            
            for (NSString* usrId in revengeIds) {
                for (PFUser* usr in pfusers) {
                    if ([usr.objectId isEqualToString:usrId]) {
                        [revUsrs addObject:usr];
                    }
                }
            }
            
            NSMutableArray* recUsrs = [NSMutableArray array];
            
            for (NSString* usrId in recentIds) {
                for (PFUser* usr in pfusers) {
                    if ([usr.objectId isEqualToString:usrId]) {
                        [recUsrs addObject:usr];
                    }
                }
            }
            
            loginCompletion(@[revUsrs, recUsrs, pfusers]);
        }];
        return;
    }

    
    NSArray* permissions = @[ @"public_profile", @"user_friends", ];
    
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        
        //Create Revenge and Recent list if necessary
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            
            self.revengeIds = user[@"revenge"] = [NSMutableArray array];
            self.recentIds = user[@"recent"] = [NSMutableArray array];
            [user saveInBackground];
        } else {
            NSLog(@"User logged in through Facebook!");
            
            self.revengeIds = user[@"revenge"];
            self.recentIds = user[@"recent"];
        }
        
        //Use Fieldlord's Facebook update + friends update if necessary
        [JFParseFBFriends updateCurrentUserWithCompletion:^(BOOL success, NSError *error) {
            [JFParseFBFriends findFriendsAndUpdate:YES completion:^(BOOL success, BOOL localStore, NSArray *pfusers, NSError *error) {
                
                NSMutableArray* revUsrs = [NSMutableArray array];
                
                for (NSString* usrId in revengeIds) {
                    for (PFUser* usr in pfusers) {
                        if ([usr.objectId isEqualToString:usrId]) {
                            [revUsrs addObject:usr];
                        }
                    }
                }
                
                NSMutableArray* recUsrs = [NSMutableArray array];
                
                for (NSString* usrId in recentIds) {
                    for (PFUser* usr in pfusers) {
                        if ([usr.objectId isEqualToString:usrId]) {
                            [recUsrs addObject:usr];
                        }
                    }
                }
                
                loginCompletion(@[revUsrs, recUsrs, pfusers]);
            }];
        }];
    }];
}





@end
