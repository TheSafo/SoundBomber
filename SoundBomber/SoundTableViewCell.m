//
//  SoundTableViewCell.m
//  SoundBomber
//
//  Created by Jake Saferstein on 4/29/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "SoundTableViewCell.h"

@implementation SoundTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setIsEnabled:(BOOL)isEnabled
{
    _isEnabled = isEnabled;
    
    if(isEnabled) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

-(void)setSoundName:(NSString *)soundName
{
    _soundName = soundName;
    self.textLabel.text = soundName;
}

@end
