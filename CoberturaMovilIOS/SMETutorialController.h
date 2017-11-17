//
//  SMETutorialController.h
//  CoberturaMovilIOS
//
//  Created by Supertel on 27/10/14.
//  Copyright (c) 2014 Superintendencia de Telecomunicaciones. All rights reserved.
//

#import <UIKit/UIkit.h>

@interface SMETutorialController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) UIViewController *currentController;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btn_salir;
- (IBAction)closeView:(id)sender;
@end
