//
//  SAFView.m
//  SoundBomber
//
//  Created by Jake Saferstein on 4/7/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "SAFView.h"

@interface SAFView ()

@property (nonatomic) UIImageView* mainView;
@property (nonatomic) UIImageView* blendView;

@property (nonatomic) UIImage* speakerImg;
@property (nonatomic) UIImage* otherImg;

@end

@implementation SAFView

-(id) initWithSpeakerImage: (UIImage*)speakerImg andOtherImg: (UIImage *)otherImg andFrame: (CGRect) frame
{
    if(self = [super init])
    {
        _otherImg = otherImg;
        _speakerImg = speakerImg;
        
        self.frame = frame;
        
        _blendView = [[UIImageView alloc] init];

        _mainView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"bigSpeaker.jpg"]];
        
        _mainView.frame = self.bounds;
        
        int w = _mainView.frame.size.width;
        int h = _mainView.frame.size.height;
        
        _blendView.frame = CGRectMake(w/16, h*.34, w*7/8, w*7/8);
        
        UIImage* blendImg = [self mergeTwoImages:otherImg and: speakerImg];
        _blendView.image = blendImg;

        
        [self addSubview:_mainView];
        [_mainView addSubview:_blendView];
    }
    return self;
}

-(void) changeImage: (UIImage *)img
{
    _otherImg = img;
    
    UIImage* newBlend = [self mergeTwoImages:_otherImg and:_speakerImg];
    _blendView.image = newBlend;
}

- (UIImage*) mergeTwoImages : (UIImage*) topImage and: (UIImage*) bottomImage
{
    int width = _blendView.frame.size.width;
    int height = _blendView.frame.size.height;
    
    CGSize newSize = CGSizeMake(width, height);
    //    NSLog(@"%i, %i", width, height);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    
    [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    
    CGRect topFrame = CGRectMake(newSize.width/8, newSize.height/8, newSize.width*3/4, newSize.width*3/4);
    
    topImage = [self circularScaleAndCropImage:topImage frame:topFrame];
    
    [topImage drawInRect:topFrame blendMode:kCGBlendModeNormal alpha:.65];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage*)circularScaleAndCropImage:(UIImage*)image frame:(CGRect)frame {
    // This function returns a newImage, based on image, that has been:
    // - scaled to fit in (CGRect) rect
    // - and cropped within a circle of radius: rectWidth/2
    
    //Create the bitmap graphics context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(frame.size.width, frame.size.height), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Get the width and heights
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat rectWidth = frame.size.width;
    CGFloat rectHeight = frame.size.height;
    
    //Calculate the scale factor
    CGFloat scaleFactorX = rectWidth/imageWidth;
    CGFloat scaleFactorY = rectHeight/imageHeight;
    
    //Calculate the centre of the circle
    CGFloat imageCentreX = rectWidth/2;
    CGFloat imageCentreY = rectHeight/2;
    
    // Create and CLIP to a CIRCULAR Path
    // (This could be replaced with any closed path if you want a different shaped clip)
    CGFloat radius = rectWidth/2;
    CGContextBeginPath (context);
    CGContextAddArc (context, imageCentreX, imageCentreY, radius, 0, 2*M_PI, 0);
    CGContextClosePath (context);
    CGContextClip (context);
    
    //Set the SCALE factor for the graphics context
    //All future draw calls will be scaled by this factor
    CGContextScaleCTM (context, scaleFactorX, scaleFactorY);
    
    // Draw the IMAGE
    CGRect myRect = CGRectMake(0, 0, imageWidth, imageHeight);
    [image drawInRect:myRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void) wubTheSpeakerWithDuration: (int) dur{
    [self applyEarthquakeToView:_blendView duration:dur delay:0 offset:200];
}

#warning Change this animation later to real wubs
- (void) applyEarthquakeToView:(UIView*)v duration:(float)duration delay:(float)delay offset:(int)offset {
    
    CAKeyframeAnimation *transanimation;
    transanimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    transanimation.duration = duration;
    transanimation.cumulative = YES;
    int offhalf = offset / 2;
    
    int numFrames = 15;
    NSMutableArray *positions = [NSMutableArray array];
    NSMutableArray *keytimes  = [NSMutableArray array];
    NSMutableArray *timingfun = [NSMutableArray array];
    [positions addObject:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    [keytimes addObject:@(0)];
    
    for (int i = 0; i < numFrames; i++) {
        CATransform3D beforeScale = CATransform3DMakeTranslation(rand()%offset-offhalf, rand()%offset-offhalf,0);
        
        beforeScale = CATransform3DRotate(beforeScale, M_PI_4/2 * pow(-1, i), 0, 0, 1);
        
        CATransform3D final = CATransform3DScale(beforeScale, i/2, i/2, 0);
        
        [positions addObject:[NSValue valueWithCATransform3D:final]];
        
        [keytimes addObject:@( ((float)(i+1))/(numFrames+2) )];
        [timingfun addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    }
    
    [positions addObject:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    [keytimes addObject:@(1)];
    [timingfun addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    transanimation.values = positions;
    transanimation.keyTimes = keytimes;
    transanimation.calculationMode = kCAAnimationCubic;
    transanimation.timingFunctions = timingfun;
    transanimation.beginTime = CACurrentMediaTime() + delay;
    
    [v.layer addAnimation:transanimation forKey:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
