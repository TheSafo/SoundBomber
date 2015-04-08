//
//  AudioHelper.h
//  SoundBomber
//
//  Created by Jake Saferstein on 4/7/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioHelper : NSObject

-(int)playRandomApprovedSound;

@property (nonatomic) int dontPlayUntil;


@end