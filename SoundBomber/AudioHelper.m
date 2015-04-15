//
//  AudioHelper.m
//  SoundBomber
//
//  Created by Jake Saferstein on 4/7/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "AudioHelper.h"

@interface AudioHelper ()

@property (nonatomic,strong) AVAudioPlayer *curPlayer;


@end

@implementation AudioHelper

-(id)init
{
    if(self = [super init])
    {

        
    }
    return self;
}

-(int)playRandomApprovedSound
{
#warning Use User Defaults or Wormhole later
    NSDictionary* enabledSounds = @{ @"fart":@YES, @"scream":@NO, @"airhorn":@NO };
    
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
    
    int y; //Number of sounds to choose from
    if ([chosen isEqualToString:@"fart"]) {
       y = arc4random_uniform(7) + 1;
    }
    
    
    NSString* fileName = [NSString stringWithFormat:@"%@%i", chosen, y];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"caf"];
    NSURL* fileURL = [NSURL fileURLWithPath:filePath];
    _curPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    
    double z = CFAbsoluteTimeGetCurrent();
    z+= _curPlayer.duration;
    _dontPlayUntil = z;
    
    [_curPlayer play];
    
    
    for (float i = 0; i < _curPlayer.duration; i+= .4)
    {
        [self performSelector:@selector(vibe:) withObject:self afterDelay:i];
    }
    
    return _curPlayer.duration;
}

-(void)vibe:(id)sender
{
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

@end
