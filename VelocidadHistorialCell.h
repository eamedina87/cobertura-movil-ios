//
//  VelocidadHistorialCell.h
//  CoberturaMovilIOS
//
//  Created by Supertel on 06/10/14.
//  Copyright (c) 2014 Superintendencia de Telecomunicaciones. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VelocidadHistorialCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *network_type;
@property (strong, nonatomic) IBOutlet UILabel *network_wifi;
@property (strong, nonatomic) IBOutlet UILabel *network;
@property (strong, nonatomic) IBOutlet UILabel *download_speed;
@property (strong, nonatomic) IBOutlet UILabel *upload_speed;
@end
