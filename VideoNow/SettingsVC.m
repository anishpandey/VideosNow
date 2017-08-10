//
//  SettingsVC.m
//  VideoNow
//
//  Created by Anish Kumar on 7/21/17.
//  Copyright © 2017 Anish Kumar. All rights reserved.
//

#import "SettingsVC.h"
#import "SettingsCell.h"
#import "AppDelegate.h"
#import <VocSdk/VocSdk.h>
#import "Videos+CoreDataClass.h"
#import "Settings+CoreDataClass.h"

@interface SettingsVC ()

@property (nonatomic, strong) NSArray *settingsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _settingsArray = @[@"DOWNLOAD ON WIFI",
                       @"DOWNLOAD OVER CELLULAR",
                       @"DISK SPACE ALLOCATED",
                       @"DISK SPACE USED",
                       @"PURGE CACHE",
                       @"REFILL CACHE"];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_settingsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingsCell *cell = (SettingsCell *)[tableView dequeueReusableCellWithIdentifier:@"SettingsCellId"];
    
    cell.settingsTitle.text = [_settingsArray objectAtIndex:indexPath.row];
    
    //Cache used
    NSByteCountFormatter *format = [[NSByteCountFormatter alloc] init];
    format.allowedUnits = NSByteCountFormatterUseGB;
    format.countStyle = NSByteCountFormatterCountStyleMemory;
    cell.settingsLabel.text = [format stringFromByteCount:appDelegate().vocService.cacheUsed];
    
    [cell.segmentedControl addTarget:self action:@selector(segmentControlAction:) forControlEvents: UIControlEventValueChanged];
    
    [cell.settingsStepper addTarget:self action:@selector(stepperAction:)forControlEvents:UIControlEventValueChanged];
    
    //CoreData Set
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    NSError *error ;
    NSFetchRequest<Settings *> *fetchRequest = [Settings fetchRequest];
    NSArray *resultArray= [context executeFetchRequest:fetchRequest error:&error];
    Settings *data = [resultArray objectAtIndex:0];
    
    switch (indexPath.row)
    {
        case 0:
        {
            if (data.wiFIState == YES)
            {
                cell.segmentedControl.selectedSegmentIndex = 0;
            }
            else
            {
                cell.segmentedControl.selectedSegmentIndex = 1;
            }
            cell.segmentedControl.hidden = NO;
            cell.settingsLabel.hidden = YES;
            cell.settingsStepper.hidden = YES;
        }
            break;
        case 1:
        {
            if (data.cellularState == YES)
            {
                cell.segmentedControl.selectedSegmentIndex = 0;
            }
            else
            {
                cell.segmentedControl.selectedSegmentIndex = 1;
            }
            
            cell.segmentedControl.hidden = NO;
            cell.settingsLabel.hidden = YES;
            cell.settingsStepper.hidden = YES;
        }
            break;
        case 2:
        {
            CGFloat spaceAllocated = data.diskSpaceAllocated;
            cell.settingsStepper.value = spaceAllocated;
            
            cell.settingsStepper.hidden = NO;
            cell.segmentedControl.hidden = YES;
            cell.settingsLabel.hidden = YES;
        }
            break;
        case 3:
        {
            cell.settingsLabel.hidden = NO;
            cell.segmentedControl.hidden = YES;
            cell.settingsStepper.hidden = YES;
        }
            break;
        case 4:
        case 5:
        {
            cell.settingsLabel.hidden = YES;
            cell.segmentedControl.hidden = YES;
            cell.settingsStepper.hidden = YES;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 4:
        {
            NSLog(@"Purge Cache");
            //[appDelegate().vocService purgeProviders:@[@"sony"]];
            
//            [appDelegate().vocService clearCache:^(NSError * __nullable error) {
//                
//            }];
            
            [appDelegate().vocService getItemsWithFilter:[VocItemFilter allWithSort:nil] completion:^(NSError * _Nullable error, id<VocItemSet>  _Nullable set) {
                
                if (error) {
                    NSLog(@"Error getting items from VOC SDK %@", error);
                    return ;
                }
                NSLog(@"allWithSort Count = %ld", (long) set.items.count);
    
                
                for (id<VocItemVideo> item in [set items])
                {
                    if (item.state == VOCItemDownloading || item.state == VOCItemCached || item.state == VOCItemPaused || item.state == VOCItemQueued)
                    {
                        [item deleteFiles:NO];
                    }
                }
            }];

        }
            break;
        case 5:
        {
            NSLog(@"Refill Cache");
            [appDelegate().vocService startDownloadUserInitiatedWithCompletion:^(NSError *error) {
                
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)segmentControlAction:(UISegmentedControl *)segment
{
    CGPoint buttonPosition = [segment convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    //Save to CoreData
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    NSError *error ;
    NSFetchRequest<Settings *> *fetchRequest = [Settings fetchRequest];
    NSArray *resultArray= [context executeFetchRequest:fetchRequest error:&error];
    NSManagedObject* settingsData = [resultArray objectAtIndex:0];
    
    switch (indexPath.row)
    {
        case 0:
        {
            if(segment.selectedSegmentIndex == 0)
            {
                NSLog(@"Download Over WIFI ON");
                
                [settingsData setValue:@YES forKey:@"wiFIState"];
                [settingsData setValue:@NO forKey:@"cellularState"];
                [[appDelegate().vocService config]setNetworkSelectionOverride:VOCNetworkSelectionWifiOnly];
            }
            else
            {
                NSLog(@"Download Over WIFI OFF");
                [settingsData setValue:@NO forKey:@"wiFIState"];
               // [[appDelegate().vocService config]setNetworkSelectionOverride:VOCNetworkSelectionNone];
            }
        }
            break;
        case 1:
        {
            if(segment.selectedSegmentIndex == 0)
            {
                NSLog(@"Download Over Cellular ON");
                [settingsData setValue:@YES forKey:@"cellularState"];
                [[appDelegate().vocService config]setNetworkSelectionOverride:VOCNetworkSelectionWifiAndCellular];
            }
            else
            {
                NSLog(@"Download Over Cellular OFF");
                [settingsData setValue:@NO forKey:@"cellularState"];
               // [[appDelegate().vocService config]setNetworkSelectionOverride:VOCNetworkSelectionWifiOnly];
            }
        }
            break;
            
        default:
            break;
    }
    NSMergePolicy *mergePolicy = [[NSMergePolicy alloc] initWithMergeType:NSMergeByPropertyStoreTrumpMergePolicyType];
    [context setMergePolicy:mergePolicy];
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) saveContext];
    
    //Fetch
    BOOL wifiState =  [[settingsData valueForKey:@"wiFIState"] boolValue];
    BOOL cellularState =  [[settingsData valueForKey:@"cellularState"] boolValue];
    
    if (wifiState == NO && cellularState == NO)
    {
        [[appDelegate().vocService config]setNetworkSelectionOverride:VOCNetworkSelectionNone];
        //appDelegate().vocService.config.networkSelection = VOCNetworkSelectionNone;
    }
    
    [self.tableView reloadData];
}

- (IBAction)stepperAction:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    SettingsCell *cell = (SettingsCell *)[_tableView cellForRowAtIndexPath:indexPath];
    CGFloat stepperVal = (float)cell.settingsStepper.value;
    
    switch (indexPath.row) {
        case 2:
        {
            NSLog(@"Stepper = %@", [sender currentTitle]);
            NSLog(@"In MB = %f", stepperVal * 1024);
            NSLog(@"In KB = %f", stepperVal * 1024 * 1024);
            NSLog(@"In Bytes = %f", stepperVal * 1024 * 1024 * 1024);
            
            appDelegate().vocService.cacheSize = stepperVal * 1024 * 1024 * 1024;
            
            NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
            
            NSError *error ;
            NSFetchRequest<Settings *> *fetchRequest = [Settings fetchRequest];
            NSArray *resultArray= [context executeFetchRequest:fetchRequest error:&error];
            
            //Update
            NSManagedObject* settingsData = [resultArray objectAtIndex:0];
            [settingsData setValue:[NSNumber numberWithFloat:stepperVal] forKey:@"diskSpaceAllocated"];
    
            //Save context
            NSMergePolicy *mergePolicy = [[NSMergePolicy alloc] initWithMergeType:NSMergeByPropertyStoreTrumpMergePolicyType];
            [context setMergePolicy:mergePolicy];
            [((AppDelegate*)[[UIApplication sharedApplication] delegate]) saveContext];
            
        }
            break;
            
        default:
            break;
    }
}

@end
