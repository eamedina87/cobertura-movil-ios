//
//  Helper.h
//  CoberturaMovilIOS
//
//  Created by Supertel on 08/10/14.
//  Copyright (c) 2014 Superintendencia de Telecomunicaciones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@interface Helper : NSObject
- (NSInteger) getNetworkInt: (NSString *) networkString;
- (NSString *) getNetworkString: (NSString *) networkString;
- (NSString *) getNetworkStringFromInteger: (NSInteger) networkType;
- (NSString *) getNetworkTypeString:(NSString *)networkString;
- (NSString *) getNetworkTypeStringFromInteger:(NSInteger)networkType;
- (NSString *) getCarrierName:(NSInteger)mnc;
- (NSString *) getCarrierImage:(NSString*)carrierName;
- (NSInteger) getConexionInt;
- (NSString *) getConexionString;
- (NSString *) getDateTimeString: (NSInteger) dateTime;
- (NSString *) getDateString: (NSInteger) dateTime;
- (NSString *) getTimeString: (NSInteger) dateTime;
- (NSMutableURLRequest *) getSoapRequest: (NSString*) mensaje : (NSString *) fileName;
- (NSMutableURLRequest *) getUploadRequest: (double) speed;
- (BOOL) isInternetAvailable;
@end
