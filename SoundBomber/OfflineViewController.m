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
#import "SettingsViewController.h"


@interface OfflineViewController ()

@property (nonatomic) UIButton* settingsButton;
@property (nonatomic) UIButton* cameraButton;
@property (nonatomic) SAFView* mainView;
//@property (nonatomic, strong) AudioHelper* audioHelper;

@property (nonatomic) MMWormhole* wormHole;

@end

@implementation OfflineViewController

-(id) initWithSpeakerImage: (UIImage*)speakerImg andOtherImg: (UIImage *)otherImg;
{
    if(self = [super init])
    {
        _settingsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_settingsButton setImage:[UIImage imageNamed:@"settingsBtn"] forState:UIControlStateNormal];
        _settingsButton.tintColor = [UIColor blackColor];
        [_settingsButton addTarget:self action:@selector(settingsPressed) forControlEvents:UIControlEventTouchUpInside];
        
        _cameraButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_cameraButton setImage:[UIImage imageNamed:@"cameraBtn"] forState:UIControlStateNormal];
        _cameraButton.tintColor = [UIColor blackColor];
        [_cameraButton addTarget:self action:@selector(camPressed) forControlEvents:UIControlEventTouchUpInside];

        
        _wormHole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.com.gmail.jakesafo.SoundBomber"
                                                         optionalDirectory:@"wormhole"];
         
        int w = self.view.frame.size.width;
        int h;
        int adOffset;
        
//        if(ADS_ON) {
//            h = self.view.frame.size.height - 49 - 50;
//            adOffset = 50;
//        }
//        else {
            h = self.view.frame.size.height - 49;
            adOffset = 0;
//        }
        
        _mainView = [[SAFView alloc] initWithSpeakerImage:speakerImg andOtherImg:otherImg andFrame:CGRectMake(w/16, 20 + adOffset , w*7/8, h - (20)) andCamBut:_cameraButton andSetBut:_settingsButton];

        [self.view addSubview:_mainView];
    }
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if(ADS_ON) {
//        [self.view addSubview:[AdSingleton sharedInstance].adBanner];
//    }
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

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Cancelling image picker");
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* temp = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [_wormHole passMessageObject:temp identifier:@"otherImg"];
    
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
    
    if(CFAbsoluteTimeGetCurrent() < [AudioHelper sharedInstance].dontPlayUntil)
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
    double duration = [[AudioHelper sharedInstance ]playRandomApprovedSound];
    [_mainView wubTheSpeakerWithDuration: duration];
}

#pragma mark - Settings Section

-(void)settingsPressed
{
//    UINavigationController* navCtrlr = [[UINavigationController alloc] initWithRootViewController:[[SettingsViewController alloc] init]];
//    navCtrlr.navigationBar.backgroundColor = [UIColor colorWithRed:149.0/255.0 green:205.0/255.0 blue:222.0/255.0 alpha:1];//[UIColor yellowColor];
//    navCtrlr.navigationBar.translucent = YES;
//    navCtrlr.navigationBar.barTintColor = [UIColor colorWithRed:149.0/255.0 green:205.0/255.0 blue:222.0/255.0 alpha:1];
    
    [self presentViewController: [[SettingsViewController alloc] init]  animated:YES completion:^{
        NSLog(@"Presented Settings");
    }];
}

@end
