//
//  Tab_VelocidadController.h
//  CoberturaMovilIOS
//
//  Created by Supertel on 06/10/14.
//  Copyright (c) 2014 Superintendencia de Telecomunicaciones. All rights reserved.
//
/*
#ifndef CoberturaMovilIOS_Tab_VelocidadController_h
#define CoberturaMovilIOS_Tab_VelocidadController_h


#endif
*/

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "VelocidadHistorialController.h"
#import "VelocidadTestController.h"

@interface Tab_VelocidadController : UIViewController <UIPageViewControllerDataSource>
@property (nonatomic, retain) IBOutlet UIButton *btn_changeView;
@property (nonatomic, retain) IBOutlet UIButton *btn_share;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) UIViewController *currentController;
@property (strong, nonatomic) UIPageViewController *pageViewController;

- (IBAction)changeView:(id)sender;
- (IBAction)share:(id)sender;

//- (void) changeOrientation;
@end