//
//  OnlineViewController.m
//  SoundBomber
//
//  Created by Jake Saferstein on 4/6/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "OnlineViewController.h"
#import "SAFParseHelper.h"
#import "FriendTableViewCell.h"
#import <JFParseFBFriends/JFParseFBFriends.h>

@interface OnlineViewController ()

@property (nonatomic) BOOL doneLoggingIn;

@property (nonatomic) NSArray* friendsLists;

@property(nonatomic) UITableView* tableView;

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
            
            [[SAFParseHelper sharedInstance] loginWithBlock:^(NSArray *friendArrs) {
                //Move on
                [self showTableViewWithArrs:friendArrs];
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

#warning Is this acceptable logic?
-(void)viewWillDisappear:(BOOL)animated
{
    _doneLoggingIn = NO;
}

-(void)loginPressed
{
    [[SAFParseHelper sharedInstance] loginWithBlock:^(NSArray *friendArrs) {
       //Move on
        [self showTableViewWithArrs:friendArrs];
    }];
}

-(void)showTableViewWithArrs: (NSArray *)arrs
{
#warning implement this
    NSLog(@"Logged in success");
    
    _doneLoggingIn = YES;
    
    _friendsLists = arrs;
    
    int w = self.view.frame.size.width;
    int h = self.view.frame.size.height;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, w, h) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_friendsLists[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Revenge";
            break;
        case 1:
            sectionName = @"Recent";
            break;
        case 2:
            sectionName = @"Friends";
            break;
    }
    return sectionName;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friend"];
    
    if(!cell)
    {
        cell = [[FriendTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"friend"];
    }
    
    return cell;
}



@end
