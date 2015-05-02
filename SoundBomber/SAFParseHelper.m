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

-(void)sendPushFromUser: (PFUser *)sender touser: (PFUser *)toSend withSoundName: (NSString *)soundName
{
#warning update their revenge list with cloud code and change pushes to online only
    
    PFQuery *qry = [PFInstallation query];
    [qry whereKey:@"user" equalTo:toSend];
    
    NSString* realMsg = [NSString stringWithFormat:@"from %@", sender[@"fullname"]];
    
    int x = arc4random_uniform(7) + 1;
    NSString* sound = [NSString stringWithFormat:@"%@%i.caf", soundName, x]; ///Randomizes sound!!!
    
    NSDictionary *data = @{ @"alert" : realMsg,
                            @"sound" : sound,
                            @"senderID" : sender.objectId,
//                            @"WatchKit Simulator Actions": @[
//                                    @{
//                                        @"title": @"Revenge",
//                                        @"identifier": @"takeRevenge"
//                                        }
//                                    ],
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
}

-(void) loginWithBlock:(void (^)(NSMutableArray *friendArrs)) loginCompletion
{
    
    if([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) /* If logged in */
    {
        self.revengeIds = [PFUser currentUser][@"revenge"];
        self.recentIds = [[NSUserDefaults standardUserDefaults] objectForKey:@"recent"];
        
        [PFInstallation currentInstallation][@"user"] = [PFUser currentUser];
        [[PFInstallation currentInstallation] saveInBackground];
        
        //If we're logged in just update the friends only
        [JFParseFBFriends findFriendsAndUpdate:YES completion:^(BOOL success, BOOL localStore, NSArray *pfusers, NSError *error) {
            
            NSMutableArray* revUsrs = [NSMutableArray array];
            
            for (NSString* usrId in self.revengeIds) {
                for (PFUser* usr in pfusers) {
                    if ([usr.objectId isEqualToString:usrId]) {
                        [revUsrs addObject:usr];
                    }
                }
            }
            
            NSMutableArray* recUsrs = [NSMutableArray array];
            
            for (NSString* usrId in self.recentIds) {
                for (PFUser* usr in pfusers) {
                    if ([usr.objectId isEqualToString:usrId]) {
                        [recUsrs addObject:usr];
                    }
                }
            }
            
            NSMutableArray* arr = [NSMutableArray arrayWithObjects:revUsrs, recUsrs, pfusers, nil];
            
            loginCompletion(arr);
        }];
        return;
    }

    
    NSArray* permissions = @[@"public_profile", @"user_friends", ];
    
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        
        //Create Revenge and Recent list if necessary
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            return;
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            
            self.revengeIds = user[@"revenge"] = [NSMutableArray array];
            self.recentIds = [NSMutableArray array];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.recentIds forKey:@"recent"];
            [user saveInBackground];
        } else {
            NSLog(@"User logged in through Facebook!");
            
            self.revengeIds = user[@"revenge"];
            self.recentIds = [[NSUserDefaults standardUserDefaults] valueForKey:@"recent"];
        }
        
        [PFInstallation currentInstallation][@"user"] = [PFUser currentUser];
        [[PFInstallation currentInstallation] saveInBackground];
        
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
                
                NSMutableArray* arr = [NSMutableArray arrayWithObjects:revUsrs, recUsrs, pfusers, nil];
                
                loginCompletion(arr);
            }];
        }];
    }];
}





@end
