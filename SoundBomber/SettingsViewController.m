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
        
        int w = self.view.bounds.size.width;
        int h = self.view.bounds.size.height;
        
        self.view.backgroundColor = [UIColor redColor];
        
        UIButton* back = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        back.frame = CGRectMake(0, 0, 100, 60);
        back.backgroundColor = [UIColor greenColor];
        [back addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:back];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, w, h-60) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [self.view addSubview:_tableView];
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
    NSMutableDictionary* enabledSounds = [[NSUserDefaults standardUserDefaults] objectForKey:@"enabledSounds"];
    
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
    
    NSMutableDictionary* enabledSounds = [[NSUserDefaults standardUserDefaults] objectForKey:@"enabledSounds"];
    NSString* soundName = enabledSounds.allKeys[indexPath.row];
    
    [cell setSoundName:soundName];
    [cell setIsEnabled:[enabledSounds[soundName] boolValue]];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SoundTableViewCell* cell = (SoundTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    
    [cell setIsEnabled: !cell.isEnabled]; //Toggle the cell
    
    NSDictionary* enabledSounds = [[NSUserDefaults standardUserDefaults] objectForKey:@"enabledSounds"];
    
    NSMutableDictionary* mutableSounds = [NSMutableDictionary dictionaryWithDictionary:enabledSounds];
    [mutableSounds setObject:@(cell.isEnabled) forKey:cell.soundName];
    
    [[NSUserDefaults standardUserDefaults] setObject:mutableSounds forKey:@"enabledSounds"];
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
