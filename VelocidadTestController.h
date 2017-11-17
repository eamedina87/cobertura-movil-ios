//
//  VelocidadTestController.h
//  CoberturaMovilIOS
//
//  Created by Supertel on 06/10/14.
//  Copyright (c) 2014 Superintendencia de Telecomunicaciones. All rights reserved.
//
/*
#ifndef CoberturaMovilIOS_VelocidadTestController_h
#define CoberturaMovilIOS_VelocidadTestController_h


#endif
*/
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "SimplePing.h"
#import "GAITrackedViewController.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"


@interface VelocidadTestController : GAITrackedViewController <CLLocationManagerDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate, UIAlertViewDelegate, NSXMLParserDelegate, SimplePingDelegate>

@property (nonatomic, strong) IBOutlet UILabel *download_speed;
@property (nonatomic, strong) IBOutlet UILabel *upload_speed;
@property (nonatomic, strong) IBOutlet UILabel *address;
@property (nonatomic, strong) IBOutlet UILabel *city;
@property (nonatomic, strong) IBOutlet UILabel *date_time;
@property (nonatomic, strong) IBOutlet UILabel *network;
@property (nonatomic, strong) IBOutlet UILabel *txt_dummy;
@property (nonatomic, strong) IBOutlet UILabel *txt_init;
@property (nonatomic, strong) IBOutlet UITextField *txt_speed;
@property (nonatomic, strong) IBOutlet UIButton *btn_set;
@property (nonatomic, strong) IBOutlet UIImageView *img_operadora;
@property (nonatomic, strong) IBOutlet UIImageView *img_wifi;
@property (nonatomic, strong) IBOutlet UIImageView *img_upload;
@property (nonatomic, strong) IBOutlet UIImageView *img_download;
@property (nonatomic, strong) IBOutlet UIImageView *img_needle;
@property (nonatomic, strong) IBOutlet UIImageView *img_dummy;
@property (nonatomic, strong) IBOutlet UIImageView *btn_start;
@property (nonatomic, strong) IBOutlet UIImageView *speedo;
@property (nonatomic, strong) IBOutlet UIProgressView *progress_bar;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *indicator;

@property (strong, nonatomic) CLLocationManager *lm;
@property (nonatomic, retain) NSURLConnection *testConnection;
@property (nonatomic, retain) NSURLConnection *sendConnection;
@property (nonatomic, retain) NSURLConnection *previousConnection;
@property (nonatomic, retain) NSURLConnection *uploadConnection;
@property (strong, nonatomic) NSTimer *timer;
- (IBAction)setSpeed:(id)sender;
@end