//
//  FriendTableViewCell.m
//  SoundBomber
//
//  Created by Jake Saferstein on 4/21/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "FriendTableViewCell.h"

@implementation FriendTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated { 
    [super setSelected:selected animated:animated];

}

-(void)setUser: (PFUser *)user
{
//    NSLog(@"Setting user");
    
    _user = user;
    
    self.textLabel.text = user[@"fullname"];
    
    NSData* imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", user[@"fbId"]]]];
    self.imageView.image = [UIImage imageWithData:imgData];
}



@end
