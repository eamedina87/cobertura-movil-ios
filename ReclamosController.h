//
//  ReclamosController.h
//  CoberturaMovilIOS
//
//  Created by Supertel on 13/10/14.
//  Copyright (c) 2014 Superintendencia de Telecomunicaciones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <MapKit/MapKit.h>
#import "GAITrackedViewController.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

@interface ReclamosController : GAITrackedViewController <CLLocationManagerDelegate, UIAlertViewDelegate, NSURLConnectionDataDelegate, NSXMLParserDelegate>
@property (strong, nonatomic) IBOutlet UISegmentedControl *tipoReclamo;
@property (strong, nonatomic) IBOutlet UISegmentedControl *tipoLocation;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btn_send;
@property (strong, nonatomic) IBOutlet UITextField *descripcion;
@property (strong, nonatomic) IBOutlet UITextField *provincia;
@property (strong, nonatomic) IBOutlet UITextField *ciudad;
@property (strong, nonatomic) IBOutlet UITextField *direccion;
@property (strong, nonatomic) IBOutlet UILabel *tipoReclamoDescripcion;
@property (strong, nonatomic) IBOutlet UILabel *mapaDescripcion;
@property (strong, nonatomic) IBOutlet MKMapView *mapa;
@property (strong, nonatomic) CLLocationManager *lm;
- (IBAction) cleanAll: (id)sender;
- (IBAction) send: (id)sender;
- (IBAction) changeType: (id)sender;
- (IBAction) changeLocation: (id)sender;
- (IBAction) removeKeyboard: (id)sender;

@end
