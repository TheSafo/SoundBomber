//
//  AudioHelper.h
//  SoundBomber
//
//  Created by Jake Saferstein on 4/7/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "Singleton.h"

@interface AudioHelper : NSObject

SINGLETON_INTR(AudioHelper);

-(double)playRandomApprovedSound;
+(NSString *)randomSoundName;
-(void)playBombingSound;

@property (nonatomic) double dontPlayUntil;


#warning TODO
/*
 Explosion animation
 
 Ads and removal of ads
 
 Possibly more sounds:
     Toilet Flush
     Sup
     Yee
     Nice La
     animal
     WAOW
 
 */

@end
