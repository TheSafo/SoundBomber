//
//  SAFParseHelper.h
//  SoundBomber
//
//  Created by Jake Saferstein on 4/13/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "Singleton.h"



@interface SAFParseHelper : NSObject

SINGLETON_INTR(SAFParseHelper);

@property (nonatomic) NSMutableArray* revengeIds;
@property (nonatomic) NSMutableArray* friendIds;
@property (nonatomic) NSMutableArray* recentIds;

-(void) loginWithBlock:(void (^)(NSMutableArray *friendArrs)) loginCompletion;

-(void)sendPushFromUser: (PFUser *)sender touser: (PFUser *)toSend withSoundName: (NSString *)soundType;

-(void)updateDataWithBlock:(void (^)(NSMutableArray *friendArrs)) updateCompletion;


//- (void)someMethodThatTakesABlock:(returnType (^)(parameterTypes))blockName;

/*
 1. Login with FB or be logged in
 2. Get friends + Revenge/Recent List every time
 3. Search through friends for the Revenge/Recent objects
 4. Use objects to make TableView
 5. Send Farts and stuff
 
 Watch:
 1. On activate always reload friends/revenge list
 2. Get user + their revenge/recent from phone
 3. Make tableviews
 4. Update user + their targets with cloud code
        Stuff must be done locally to ensure local lists are accurate as well
 */


@end
