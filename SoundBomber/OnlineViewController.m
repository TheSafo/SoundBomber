//
//  OnlineViewController.m
//  SoundBomber
//
//  Created by Jake Saferstein on 4/6/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "OnlineViewController.h"
#import "SAFParseHelper.h"
#import <JFParseFBFriends/JFParseFBFriends.h>

@interface OnlineViewController ()

@end

@implementation OnlineViewController

-(id)init
{
    if(self = [super init])
    {
        self.view.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1];
        
        
        if([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) /* If logged in */
        {
            UIImageView* fb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"facebookLoading.png"]];
            fb.frame = CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 - 150, 100, 100);
            [self.view addSubview:fb];
            
            UIActivityIndicatorView* test = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            test.frame = CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 - 50, 100, 100);
            test.color = [UIColor blackColor];
            [self.view addSubview:test];
            [test startAnimating];
            
            [JFParseFBFriends updateCurrentUserWithCompletion:^(BOOL success, NSError *error) {
                if(success)
                {
                    //Move on
#warning implement this
                }
                if(error)
                {
                    NSLog(@"Error with Fielddog's fb shit: %@", error);
                }
            }];

        }
        else /* Set up the login screen */
        {
            UIImageView* fb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"facebookLoading.png"]];
            fb.frame = CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 - 150, 100, 100);
            [self.view addSubview:fb];
            
            
            UIButton* login = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            login.frame = CGRectMake(self.view.frame.size.width/4, fb.frame.origin.y + fb.frame.size.height + 20, self.view.frame.size.width/2, 50);
            login.backgroundColor = [UIColor whiteColor];
            login.layer.cornerRadius = 10;
            [login setTitle:@"Connect to Facebook" forState:UIControlStateNormal];
            
            [self.view addSubview:login];
            [login addTarget:self action:@selector(loginPressed) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}

-(void)loginPressed
{
    [[SAFParseHelper sharedInstance] loginWithBlock:^(NSArray *friendArrs) {
       //Move on
#warning implement this
    }];
}


@end
