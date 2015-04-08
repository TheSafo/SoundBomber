//
//  OfflineViewController.m
//  SoundBomber
//
//  Created by Jake Saferstein on 4/6/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "OfflineViewController.h"
#import "SAFView.h"
#import "AudioHelper.h"

@interface OfflineViewController ()

@property (nonatomic) UIButton* settingsButton;
@property (nonatomic) UIButton* cameraButton;
@property (nonatomic) SAFView* mainView;
@property (nonatomic, strong) AudioHelper* audioHelper;

//@property (nonatomic) UIActionSheet* actnSht;


@end

@implementation OfflineViewController

-(id) initWithSpeakerImage: (UIImage*)speakerImg andOtherImg: (UIImage *)otherImg;
{
    if(self = [super init])
    {
        _settingsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_settingsButton setImage:[UIImage imageNamed:@"settingsBtn"] forState:UIControlStateNormal];
        _settingsButton.tintColor = [UIColor blackColor];
        
        _cameraButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_cameraButton setImage:[UIImage imageNamed:@"cameraBtn"] forState:UIControlStateNormal];
        _cameraButton.tintColor = [UIColor blackColor];
        [_cameraButton addTarget:self action:@selector(camPressed) forControlEvents:UIControlEventTouchUpInside];

        
        int w, h;
        w = self.view.frame.size.width;
        //Top 50 of the app will be ad
        if(ADS_ON)
        {
            h = self.view.frame.size.height - 50;
        }
        else
        {
            h = self.view.frame.size.height;
        }
        
        _settingsButton.frame = CGRectMake(w/16, h/32, w/16, w/16);
        _cameraButton.frame = CGRectMake(w*14/16, h/32, w/16, w/16);
        
        _mainView = [[SAFView alloc] initWithSpeakerImage:speakerImg andOtherImg:otherImg andFrame:CGRectMake(w/16, h/32 + w/16 + 20, w*7/8, h - (h/32 + w/16 + 20 + 20))];
        
        _mainView.backgroundColor = [UIColor yellowColor];
        _settingsButton.backgroundColor = [UIColor greenColor];
        _cameraButton.backgroundColor = [UIColor blueColor];
        
        [self.view addSubview:_settingsButton];
        [self.view addSubview:_cameraButton];
        [self.view addSubview:_mainView];
        
        
        _audioHelper = [[AudioHelper alloc] init];
    }
    
    return self;
}

#pragma mark - Camera Button Stuffs

-(void)camPressed
{
    UIActionSheet* actnSht = [[UIActionSheet alloc] initWithTitle:@"Change Picture in the Speaker" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose a photo", @"Take a photo", nil];
    
    [actnSht showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    if(buttonIndex == 0)
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if(buttonIndex == 1)
    {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        [actionSheet dismissWithClickedButtonIndex:2 animated:YES];
        return;
    }
    
    [self presentViewController:picker animated:YES completion:^{
        NSLog(@"Presenting imagePicker");
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* temp = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [_mainView changeImage: temp];
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Dismissing Image Picker");
    }];
}

#pragma mark - Playing the Sound and Animating

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    
    CGPoint loc = [touch locationInView:_mainView];
    
    if(CFAbsoluteTimeGetCurrent() < _audioHelper.dontPlayUntil)
    {
        //        NSLog(@"TOO SOON");
    }
    else if (loc.x < 0 || loc.y <0 || loc.y > _mainView.frame.size.height || loc.x > _mainView.frame.size.width)
    {
        //        NSLog(@"Didn't touch the cushion");
    }
    else
    {
        [self speakerPressed];
    }
}

-(void)speakerPressed
{
    int duration = [_audioHelper playRandomApprovedSound];
    [_mainView wubTheSpeakerWithDuration: duration];
}

@end