//
//  OfflineViewController.h
//  SoundBomber
//
//  Created by Jake Saferstein on 4/6/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//




@interface OfflineViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

-(id) initWithSpeakerImage: (UIImage*)speakerImg andOtherImg: (UIImage *)otherImg;
-(void)speakerPressed;

@end


