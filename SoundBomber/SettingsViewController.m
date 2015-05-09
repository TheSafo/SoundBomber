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
        
        UIView* fakeNavBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 100)];
        fakeNavBar.backgroundColor =[UIColor colorWithRed:149.0/255.0 green:205.0/255.0 blue:222.0/255.0 alpha:1];
        
        UIView* fakeTabBar = [[UIView alloc] initWithFrame:CGRectMake(0, h-100, w, 100)];
        fakeTabBar.backgroundColor =[UIColor colorWithRed:149.0/255.0 green:205.0/255.0 blue:222.0/255.0 alpha:1];// [UIColor colorWithRed:1 green:1 blue:0 alpha:.3];
        
        UIButton* back = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        back.frame = CGRectMake(w/4, h - 45, w/2, 40);
        back.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1]; //FB blue
        back.layer.borderWidth = 2;
        back.layer.cornerRadius = 4;
        [back setTitle:@"Confirm" forState:UIControlStateNormal];
        [back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [back addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton* purchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        purchButton.frame = CGRectMake(w/8 - 5, h - 50 - 45, w*3/8, 40);
        [purchButton addTarget:self action:@selector(purchasePressed) forControlEvents:UIControlEventTouchUpInside];
        [purchButton setTitle:@"Remove Ads" forState:UIControlStateNormal];
        [purchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        purchButton.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1]; //FB blue
        purchButton.layer.cornerRadius = 5;
        purchButton.layer.borderWidth = 2;
        
        
        UIButton* restorePurchase = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        if(ADS_ON) {
            restorePurchase.frame = CGRectMake(w/2 + 5, h - 50 - 45, w*3/8, 40);
        }
        else {
            restorePurchase.frame = CGRectMake(w/4, h - 45 - 50, w/2, 40);
        }
        [restorePurchase addTarget:self action:@selector(restorePressed) forControlEvents:UIControlEventTouchUpInside];
        [restorePurchase setTitle:@"Restore Purchase" forState:UIControlStateNormal];
        [restorePurchase setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        restorePurchase.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1]; //FB blue
        restorePurchase.layer.cornerRadius = 5;
        restorePurchase.layer.borderWidth = 2;


        
        
        UILabel* lbl = [[UILabel alloc] init];
        lbl.frame = CGRectMake(0, 70, w, 30);
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = @"Enabled Sounds";
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, w, h-100-100) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [self.view addSubview:_tableView];
        [self.view addSubview:fakeNavBar];
        [self.view addSubview:fakeTabBar];
        if(ADS_ON) {
            [self.view addSubview:[AdSingleton sharedInstance].adBanner];
        }
        [self.view addSubview:lbl];
        [self.view addSubview:back];
        
        if(ADS_ON) {
            [self.view addSubview:purchButton];
        }
        [self.view addSubview:restorePurchase];
    }
    return self;
}

-(void) purchasePressed
{
    [[StoreManager sharedInstance] purchaseAds];
}

-(void) restorePressed
{
    [[StoreManager sharedInstance] restorePurchase];
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
