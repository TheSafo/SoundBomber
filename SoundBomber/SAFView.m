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

@property (nonatomic) MMWormhole* wormHole;

@end

@implementation SAFView

-(id) initWithSpeakerImage: (UIImage*)speakerImg andOtherImg: (UIImage *)otherImg andFrame: (CGRect) frame andCamBut: (UIButton *)but1 andSetBut: (UIButton *)but2
{
    if(self = [super init])
    {
        _wormHole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.com.gmail.jakesafo.SoundBomber"
                                                                    optionalDirectory:@"wormhole"];
        _otherImg = otherImg;
        _speakerImg = speakerImg;
        
        self.frame = frame;
        
        _blendView = [[UIImageView alloc] init];

        _mainView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"bigSpeaker2"]];
        
        _mainView.frame = self.bounds;
        
        int w = _mainView.frame.size.width;
        int h = _mainView.frame.size.height;
        
        _blendView.frame = CGRectMake(w/16, h*.375, w*7/8, w*7/8);
        
        
        
        but1.frame = CGRectMake(w/16, w/16, w/8 + 20, w/8 + 20);
        but2.frame = CGRectMake(w*13/16 - 20, w/16, w/8 + 20, w/8 + 20);
        
        but1.backgroundColor = [UIColor colorWithRed:149.0/255.0 green:205.0/255.0 blue:222.0/255.0 alpha:.7];//[UIColor colorWithRed:1 green:1 blue:0 alpha:.3];
        but2.backgroundColor = [UIColor colorWithRed:149.0/255.0 green:205.0/255.0 blue:222.0/255.0 alpha:.7];//[UIColor colorWithRed:1 green:1 blue:0 alpha:.3];
        
        but1.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);//UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
        but2.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);//UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
        
        but1.layer.cornerRadius = 5;
        but2.layer.cornerRadius =5;
        
        but1.layer.borderWidth = 2;
        but2.layer.borderWidth = 2;
        
        

        
        
        
        UIImage* blendImg = [self mergeTwoImages:otherImg and: speakerImg];
        _blendView.image = blendImg;

        
        [self addSubview:_mainView];
        [self addSubview:but1];
        [self addSubview:but2];
        
        [self addSubview:_blendView];
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
    

    //Save this for the watch
    [_wormHole passMessageObject:newImage identifier:@"blendedImg"];
    
    
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

-(void) wubTheSpeakerWithDuration: (double) dur{
    [self applyEarthquakeToView:_blendView duration:dur delay:0 offset:50];
}

- (void) applyEarthquakeToView:(UIView*)v duration:(double)duration delay:(float)delay offset:(int)offset {
    
    CAKeyframeAnimation *transanimation;
    transanimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    transanimation.duration = duration;
    transanimation.cumulative = YES;
//    int offhalf = offset / 2;
    
//    NSLog(@"%f", duration);
    
    int numFrames = duration*10; //Frames per second is multiplied number
    
    if(numFrames < 2) {
        numFrames = 4;
    }
    
    NSMutableArray *positions = [NSMutableArray array];
    NSMutableArray *keytimes  = [NSMutableArray array];
    NSMutableArray *timingfun = [NSMutableArray array];
    [positions addObject:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    [keytimes addObject:@(0)];
    
    
    double firstRotate = M_PI_4/2;

    int x = arc4random_uniform(2);
    
    if(x == 1)
    {
        firstRotate *= -1;
    }
    
    for (int i = 2; i < numFrames; i++) {
        
#define ARC4RANDOM_MAX 0x100000000

//        float randomNumber = ((float)arc4random() / ARC4RANDOM_MAX * (maxRange - minRange)) + minRange;
        float randomNumber = ((float)arc4random() / ARC4RANDOM_MAX * (1 - -1)) + -1;


        CATransform3D beforeScale = CATransform3DMakeTranslation(randomNumber* offset, randomNumber *offset,0);
        
        beforeScale = CATransform3DRotate(beforeScale, firstRotate* pow(-1, i), 0, 0, 1);
        
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
