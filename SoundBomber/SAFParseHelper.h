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

-(void) loginWithBlock:(void (^)(NSArray *friendArrs)) loginCompletion;

//- (void)someMethodThatTakesABlock:(returnType (^)(parameterTypes))blockName;


@end
