//
//  VelocidadHistorialController.m
//  CoberturaMovilIOS
//
//  Created by Supertel on 06/10/14.
//  Copyright (c) 2014 Superintendencia de Telecomunicaciones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VelocidadHistorialController.h"
#import "Tab_VelocidadController.h"
#import "Helper.h"
#import "DBHelper.h"

@interface VelocidadHistorialController ()
@property (strong, nonatomic) NSArray *items;
@end

@implementation VelocidadHistorialController

-(void) viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fromBackground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self loadSpeedtests];
     self.screenName = @"Speedtest Historial";
}

- (void) fromBackground
{
    [self loadSpeedtests];
}
- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void) loadSpeedtests{
    [self items];
    [self.tableView reloadData];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [self.tableView registerNib:[UINib nibWithNibName:@"VelocidadHistorialIpadCell" bundle:nil] forCellReuseIdentifier:@"customCell"];
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [self.tableView registerNib:[UINib nibWithNibName:@"VelocidadHistorialCell" bundle:nil] forCellReuseIdentifier:@"customCell"];
    }
}

- (NSArray *) items {
    if (!_items){
        _items = [[DBHelper alloc] getAllTests];
        
    }
    return _items;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VelocidadHistorialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell"];
    VelocidadTest *tmp = [self.items objectAtIndex:indexPath.row];
    cell.download_speed.text = [NSString stringWithFormat:@"%.2f",tmp.downloadSpeed];
    cell.upload_speed.text = [NSString stringWithFormat:@"%.2f",tmp.uploadSpeed];
    cell.date.text = [[Helper alloc] getTimeString:tmp.date_time];
    cell.time.text = [[Helper alloc] getDateString:tmp.date_time];
    if (tmp.conexion == 1)
    {
        [cell.network_type setText:@"Wi-Fi"];
        cell.network.text = @"";
        //WIFI
/*        [cell.network setHidden:YES];
        [cell.network_type setHidden:YES];
        [cell.network_wifi setHidden:NO];*/

    }
    else if (tmp.conexion == 2)
    {
        //RED MOVIL
        cell.network.text = [[Helper alloc] getNetworkStringFromInteger:tmp.network_type];
        cell.network_type.text = [[Helper alloc] getNetworkTypeStringFromInteger:tmp.network_type];
        //[cell.network_wifi setHidden:YES];
    }
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

@end

