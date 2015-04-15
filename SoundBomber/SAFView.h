//
//  SAFView.h
//  SoundBomber
//
//  Created by Jake Saferstein on 4/7/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//


@interface SAFView : UIView

-(id) initWithSpeakerImage: (UIImage*)speakerImg andOtherImg: (UIImage *)otherImg andFrame: (CGRect) frame;

-(void) wubTheSpeakerWithDuration: (int) dur;

-(void) changeImage: (UIImage *)img;

@end
