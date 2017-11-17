//
//  EstadisticasController.h
//  CoberturaMovilIOS
//
//  Created by Supertel on 07/10/14.
//  Copyright (c) 2014 Superintendencia de Telecomunicaciones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

@interface EstadisticasController : GAITrackedViewController
@property (weak) IBOutlet UIWebView *e_webView;
@property (strong, nonatomic) IBOutlet UIImageView *e_background;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *e_activityIndicator;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *e_btn_change;
-(IBAction)changeView:(id)sender;
-(IBAction)retry:(id)sender;
extern NSString *const e_urlAddressIpad;
extern NSString *const e_urlAddressIpad_local;
extern NSString *const e_urlAddressComplete;
extern NSString *const e_urlAddressComplete_local;
@end





