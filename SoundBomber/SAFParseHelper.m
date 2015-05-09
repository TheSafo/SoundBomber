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

-(void)sendPushFromUser: (PFUser *)sender touser: (PFUser *)toSend withSoundName: (NSString *)soundType
{
    int x = arc4random_uniform(7) + 1;
    NSString* sound = [NSString stringWithFormat:@"%@%i.caf", soundType, x]; ///Randomizes sound!!!
    
    NSDictionary* params = @{ @"senderId": sender.objectId, @"toSendId": toSend.objectId, @"soundName": sound   };
    
    [PFCloud callFunctionInBackground:@"sendPush" withParameters:params block:^(id object, NSError *error) {
        if(error) { NSLog(@"Cloud error: %@", error); }
    }];
}
//    var senderId = request.params.userId;
//    var toSendId = request.params.toSendId;
//    var soundName = request.params.soundName;
    
    
//    PFQuery *qry = [PFInstallation query];
//    [qry whereKey:@"user" equalTo:toSend];
//    
//    NSString* realMsg = [NSString stringWithFormat:@"from %@", sender[@"fullname"]];
//    
//    int x = arc4random_uniform(7) + 1;
//    NSString* sound = [NSString stringWithFormat:@"%@%i.caf", soundName, x]; ///Randomizes sound!!!
//    
//    NSDictionary *data = @{ @"alert" : realMsg,
//                            @"sound" : sound,
//                            @"senderID" : sender.objectId,
//                            };
//    
//    PFPush *push = [[PFPush alloc] init];
//    [push setQuery:qry];
//    [push setData:data];
//    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if(error)
//        {
//            NSLog(@"Push Error: %@", error);
//        }
//    }];
//    
//    NSMutableArray* sendArr = [toSend objectForKey:@"revenge"];
//    NSString* userStr = sender.objectId;
//    
//    if([sendArr containsObject:userStr])
//    {
//        [sendArr removeObject:userStr];
//    }
//    if (sendArr.count == 5) {
//        [sendArr removeLastObject];
//    }
//    [sendArr insertObject:userStr atIndex:0];
//    


-(void)updateDataWithBlock:(void (^)(NSMutableArray *friendArrs)) updateCompletion
{
//    [[PFUser currentUser] fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//        self.revengeIds =  [[PFUser currentUser] objectForKey:@"revenge"]; //= @[@"9oPcwNoSjI"]; //= @[@"xFlcvadOFv"];
//        self.recentIds = [PFUser currentUser][@"recent"];
//        
//        BombingViewController* nextCtrlr = [[BombingViewController alloc] initWithStyle:UITableViewStylePlain andRevengeList:self.revengeIds andRecentList:self.recentIds andFriendsList:self.friendIds];
//        [self.navigationController pushViewController:nextCtrlr animated:YES];
//        
//    }];
//    
    [[PFUser currentUser] fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        self.revengeIds = [[PFUser currentUser] objectForKey:@"revenge"];
        self.recentIds = [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.gmail.jakesafo.SoundBomber"] objectForKey:@"recent"];
        
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
            
            NSArray *sortedArray;
            sortedArray = [pfusers sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSString *first = [(PFUser*)a objectForKey:@"lastname"];
                NSString *second = [(PFUser*)b objectForKey:@"lastname"];
                return [first compare:second];
            }];
            
            NSMutableArray* arr = [NSMutableArray arrayWithObjects:revUsrs, recUsrs, sortedArray, nil];
            
            updateCompletion(arr);
        }];
    }];
    
}


-(void) loginWithBlock:(void (^)(NSMutableArray *friendArrs)) loginCompletion
{
    
    if([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) /* If logged in */
    {
        [PFInstallation currentInstallation][@"user"] = [PFUser currentUser];
        [[PFInstallation currentInstallation] saveInBackground];
        
        self.revengeIds = [PFUser currentUser][@"revenge"];
        self.recentIds = [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.gmail.jakesafo.SoundBomber"] objectForKey:@"recent"];
        
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
            
//            pfusers = [pfusers sortedArrayUsingSelector:@selector(compare:)];
            
            NSArray *sortedArray;
            sortedArray = [pfusers sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSString *first = [(PFUser*)a objectForKey:@"lastname"];
                NSString *second = [(PFUser*)b objectForKey:@"lastname"];
                return [first compare:second];
            }];

            NSMutableArray* arr = [NSMutableArray arrayWithObjects:revUsrs, recUsrs, sortedArray, nil];
            
            
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
            
            [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.gmail.jakesafo.SoundBomber"] setObject:self.recentIds forKey:@"recent"];
            [user saveInBackground];
        } else {
            NSLog(@"User logged in through Facebook!");
            
            self.revengeIds = user[@"revenge"];
            self.recentIds = [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.gmail.jakesafo.SoundBomber"] valueForKey:@"recent"];
        }
        
        MMWormhole* wormHole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.com.gmail.jakesafo.SoundBomber" optionalDirectory:@"wormhole"];
        
        [wormHole passMessageObject:[PFUser currentUser].sessionToken identifier:@"sessionToken"];
        

        
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
                
//                pfusers = [pfusers sortedArrayUsingSelector:@selector(compare:)];//Sort alphabetically
                
                NSArray *sortedArray;
                sortedArray = [pfusers sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                    NSString *first = [(PFUser*)a objectForKey:@"lastname"];
                    NSString *second = [(PFUser*)b objectForKey:@"lastname"];
                    return [first compare:second];
                }];
                
                
                NSMutableArray* arr = [NSMutableArray arrayWithObjects:revUsrs, recUsrs, sortedArray, nil];
                
                loginCompletion(arr);
            }];
        }];
    }];
}

@end
