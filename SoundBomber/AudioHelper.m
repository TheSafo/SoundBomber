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

@property (nonatomic,strong) AVAudioPlayer *bombPlyr;
@property (nonatomic,strong) AVAudioPlayer *planePlyr;



@end

@implementation AudioHelper

SINGLETON_IMPL(AudioHelper);

-(id)init
{
    if(self = [super init])
    {
        NSString* fileName = @"airstrike";
        NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"mp3"];
        NSURL* fileURL = [NSURL fileURLWithPath:filePath];
        _planePlyr = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        _planePlyr.volume = .2;
        
        NSString* fileName2 = @"explosion";
        NSString* filePath2 = [[NSBundle mainBundle] pathForResource:fileName2 ofType:@"wav"];
        NSURL* fileURL2 = [NSURL fileURLWithPath:filePath2];
        _bombPlyr = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL2 error:nil];
        
        _bombPlyr.volume = 1;
    }
    return self;
}

-(void)playBombingSound
{
    [_planePlyr play];
    
    [_bombPlyr performSelector:@selector(play) withObject:nil afterDelay:1.4];
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

-(double)playRandomApprovedSound
{
    NSString* fileName = [AudioHelper randomSoundName];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"caf"];
    NSURL* fileURL = [NSURL fileURLWithPath:filePath];
    _curPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    
    double z = CFAbsoluteTimeGetCurrent();
    z+= _curPlayer.duration;
    _dontPlayUntil = z;
    
    [_curPlayer play];
    
    
    for (double i = 0; i < _curPlayer.duration; i+= .4)
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
