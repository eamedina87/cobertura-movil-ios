//
//  VelocidadHistoralController.h
//  CoberturaMovilIOS
//
//  Created by Supertel on 06/10/14.
//  Copyright (c) 2014 Superintendencia de Telecomunicaciones. All rights reserved.
//
/*
#ifndef CoberturaMovilIOS_VelocidadHistoralController_h
#define CoberturaMovilIOS_VelocidadHistoralController_h


#endif
*/

#import <UIKit/UIKit.h>
#import "VelocidadHistorialCell.h"
#import "VelocidadTest.h"
#import "GAITrackedViewController.h"

@interface VelocidadHistorialController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end