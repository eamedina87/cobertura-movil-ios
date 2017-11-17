//
//  CoberturaMapController.h
//  CoberturaMovilIOS
//
//  Created by Supertel on 06/10/14.
//  Copyright (c) 2014 Superintendencia de Telecomunicaciones. All rights reserved.
//

/*#ifndef CoberturaMovilIOS_CoberturaMapController_h
#define CoberturaMovilIOS_CoberturaMapController_h


#endif
 */
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GAITrackedViewController.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

@interface CoberturaMapController : GAITrackedViewController<UIAlertViewDelegate, UIWebViewDelegate>
//@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (weak) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIImageView *background;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btn_change;
-(IBAction)changeView:(id)sender;
-(IBAction)retry:(id)sender;
extern NSString *const urlAddressIpad;
extern NSString *const urlAddressIpad_local;
extern NSString *const urlAddressComplete;
extern NSString *const urlAddressComplete_local;
@end


