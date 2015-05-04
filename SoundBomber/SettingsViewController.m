//
//  SettingsViewController.m
//  SoundBomber
//
//  Created by Jake Saferstein on 4/29/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "SettingsViewController.h"
#import "SoundTableViewCell.h"

@interface SettingsViewController ()

@property (nonatomic) UITableView* tableView;

@end

@implementation SettingsViewController

-(id)init {
    if(self = [super init]) {
        
        self.title = @"Setttings";
        
        int w = self.view.bounds.size.width;
        int h = self.view.bounds.size.height;
        
        UIView* fakeTabBar = [[UIView alloc] initWithFrame:CGRectMake(0, h-49, w, 49)];
        fakeTabBar.backgroundColor = [UIColor colorWithRed:1 green:1 blue:0 alpha:.3];
        
//        self.view.backgroundColor = [UIColor redColor];
        
        UIButton* back = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        back.frame = CGRectMake(w/4, (h - 49) + 4.5, w/2, 40);
        back.backgroundColor = [UIColor yellowColor];
        back.layer.borderWidth = 2;
        back.layer.cornerRadius = 4;
        [back setTitle:@"Confirm" forState:UIControlStateNormal];
        [back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [back addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, w, h-49) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;

        [self.view addSubview:_tableView];
        [self.view addSubview:fakeTabBar];
        [self.view addSubview:back];
    }
    return self;
}

-(void)backPressed
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Dismissed settings");
    }];
}


#pragma mark - TableViewStuff


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableDictionary* enabledSounds = [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.gmail.jakesafo.SoundBomber"] objectForKey:@"enabledSounds"];
    
//    NSMutableArray* toChooseFrom = [NSMutableArray array];
//    for (NSString* str in enabledSounds.allKeys) {
//        id isEnabled = enabledSounds[str];
//        
//        if([isEnabled boolValue])
//        {
//            [toChooseFrom addObject:str];
//        }
//    }
    
    return enabledSounds.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SoundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sound"];
    if(!cell)
    {
        cell = [[SoundTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"sound"];
    }
    
    NSMutableDictionary* enabledSounds = [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.gmail.jakesafo.SoundBomber"] objectForKey:@"enabledSounds"];
    NSString* soundName = enabledSounds.allKeys[indexPath.row];
    
    [cell setSoundName:soundName];
    [cell setIsEnabled:[enabledSounds[soundName] boolValue]];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SoundTableViewCell* cell = (SoundTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    
    [cell setIsEnabled: !cell.isEnabled]; //Toggle the cell
    
    NSDictionary* enabledSounds = [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.gmail.jakesafo.SoundBomber"] objectForKey:@"enabledSounds"];
    
    
    NSMutableDictionary* mutableSounds = [NSMutableDictionary dictionaryWithDictionary:enabledSounds];
    [mutableSounds setObject:@(cell.isEnabled) forKey:cell.soundName];
    
    
    //Check and make sure that at least 1 sound is enabled
    int numEnabled = 0;
    for (id x in mutableSounds.allValues) {
        if([x boolValue]) {
            numEnabled++;
        }
    }
    
    //Undo changes if 0 are
    if(numEnabled < 1) {
        [UIAlertView bk_showAlertViewWithTitle:@"Cannot disable sound" message:@"You must leave one sound type enabled" cancelButtonTitle:@"Okay" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                //Block code
        }];
        
        [cell setIsEnabled:!cell.isEnabled];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.gmail.jakesafo.SoundBomber"] setObject:mutableSounds forKey:@"enabledSounds"];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
