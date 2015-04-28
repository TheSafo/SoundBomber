//
//  FriendTableViewCell.h
//  SoundBomber
//
//  Created by Jake Saferstein on 4/21/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FriendTableViewCell : UITableViewCell


@property (nonatomic, strong) PFUser* user;

@end
