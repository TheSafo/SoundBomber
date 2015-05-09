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
More sounds:
 4. Toilet Flush
 5. Sup
 6. Yee
 7. Nice La
 animal
 WAOW
  
 remote push notifcations
 */

@end
