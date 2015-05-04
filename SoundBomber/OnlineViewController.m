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

@interface OnlineViewController ()

@property (nonatomic) NSMutableArray* friendsLists;
@property(nonatomic) UITableView* tableView;
@property(nonatomic) RS3DSegmentedControl* soundPicker;
@property (nonatomic) NSString* curSound;

@property (nonatomic) UIRefreshControl* refreshControl;

@property (nonatomic) BOOL doneLoggingIn;

@end

@implementation OnlineViewController

-(id)init
{
    if(self = [super init])
    {
        self.view.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1];
        

        if([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) /* If logged in */ {
            
            UIImageView* fb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"facebookLoading.png"]];
            fb.frame = CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 - 150, 100, 100);
            [self.view addSubview:fb];
            
            UIActivityIndicatorView* test = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            test.frame = CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 - 50, 100, 100);
            test.color = [UIColor blackColor];
            [self.view addSubview:test];
            [test startAnimating];
            
            [[SAFParseHelper sharedInstance] loginWithBlock:^(NSMutableArray *friendArrs) {
                //Move on
                if(_doneLoggingIn)
                {
                    [self.tableView reloadData];
                    return;
                }
                
                [self showTableViewWithArrs:friendArrs];
                _doneLoggingIn = YES;
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
    [[SAFParseHelper sharedInstance] loginWithBlock:^(NSMutableArray *friendArrs) {
        if(_doneLoggingIn)
        {
            [self.tableView reloadData];
            return;
        }
        
        [self showTableViewWithArrs:friendArrs];
        _doneLoggingIn = YES;
    }];
}

-(void)showTableViewWithArrs: (NSMutableArray *)arrs
{
    NSLog(@"Logged in success");
    
    for (UIView* vw in self.view.subviews) {
        [vw removeFromSuperview];
    }
    
    
    self.view.backgroundColor =  [UIColor colorWithRed:1 green:1 blue:0 alpha:.3];
    
    
    _friendsLists = arrs;

    int w = self.view.bounds.size.width;
    int h = self.view.bounds.size.height;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, w, h-60) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.separatorColor = [UIColor yellowColor];
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor colorWithRed:1 green:1 blue:0 alpha:1];
    self.refreshControl.tintColor = [UIColor blackColor];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing Data"];
    [self.refreshControl addTarget:self
                            action:@selector(refreshData)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];

    
//    _tableView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:0 alpha:.3];
//    _tableView.layer.borderWidth = 2;
    
    _soundPicker = [[RS3DSegmentedControl alloc] initWithFrame:CGRectMake(0, 20, w, 40)];
    _soundPicker.delegate = self;

    [self didSelectSegmentAtIndex:0 segmentedControl:_soundPicker];
    
    [self.view addSubview:_tableView];
    [self.view addSubview:_soundPicker];
}

-(void)refreshData
{
    [[SAFParseHelper sharedInstance] updateDataWithBlock:^(NSMutableArray *friendArrs) {
        _friendsLists = friendArrs;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Sound Picker


- (NSUInteger)numberOfSegmentsIn3DSegmentedControl:(RS3DSegmentedControl *)segmentedControl
{
    return 3;
}

- (NSString *)titleForSegmentAtIndex:(NSUInteger)segmentIndex segmentedControl:(RS3DSegmentedControl *)segmentedControl
{
    NSMutableDictionary* enabledSounds = [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.gmail.jakesafo.SoundBomber"] objectForKey:@"enabledSounds"];

//
//    switch (segmentIndex) {
//        case 0:
//            return @"Fart";
//            break;
//        case 1:
//            return @"Scream";
//            break;
//        case 2:
//            return @"Horn";
//            break;
//            
//        default:
//            break;
//    }
    return enabledSounds.allKeys[segmentIndex];
}

- (void)didSelectSegmentAtIndex:(NSUInteger)segmentIndex segmentedControl:(RS3DSegmentedControl *)segmentedControl
{
    _curSound = [self titleForSegmentAtIndex:segmentIndex segmentedControl:_soundPicker];
}

#pragma mark - TableViewStuff

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
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friend"];
    
    if(!cell)
    {
        cell = [[FriendTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"friend"];
    }
    
    NSArray* curSection = _friendsLists[indexPath.section];
    [cell setUser:curSection[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* Needs to do:
        1. Deselect selected item
        2. Animate sending
        3. Send Push
        4. Update local/online info
     */
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self.tableView setUserInteractionEnabled:NO];
//#warning needs to be re-enabled
    
    PFUser* sender = [PFUser currentUser];
    PFUser* toSend = ((NSArray *)_friendsLists[indexPath.section])[indexPath.row];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[SAFParseHelper sharedInstance] sendPushFromUser:sender touser:toSend withSoundName:_curSound];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateAfterPushTo:toSend];
    });
    
}

-(void)updateAfterPushTo: (PFUser *)toSend
{
    NSMutableArray* revenge = _friendsLists[0];
    NSMutableArray* recent = _friendsLists[1];
//    NSMutableArray* friends = _friendsLists[2];
    
    if([revenge containsObject:toSend])
    {
        [revenge removeObject:toSend];
    }
    
    
    if([recent containsObject:toSend])
    {
        [recent removeObject:toSend];
    }
    if (recent.count == 5) {
        [recent removeLastObject];
    }
    [recent insertObject:toSend atIndex:0];
    
    //Save recent + revenge list
    
    NSMutableArray* recentIds = [NSMutableArray array];
    for (int x = 0; x < recent.count; x++) {
        recentIds[x] = ((PFUser *)recent[x]).objectId;
    }
    
    [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.gmail.jakesafo.SoundBomber"] setObject:recentIds forKey:@"recent"];
    [PFUser currentUser][@"revenge"] = revenge;
    [[PFUser currentUser] saveInBackground];
    
    //Update TableView
    _friendsLists[0] = revenge;
    _friendsLists[1] = recent;
    
    [self.tableView reloadData];
}



@end
