//
//  Helper.m
//  CoberturaMovilIOS
//
//  Created by Supertel on 08/10/14.
//  Copyright (c) 2014 Superintendencia de Telecomunicaciones. All rights reserved.
//

#import "Helper.h"
#import "Reachability.h"

@implementation Helper

- (NSInteger) getNetworkInt:(NSString *)networkString
{
    if ([networkString isEqualToString:@"CTRadioAccessTechnologyGPRS"])
    {
        return 1;
    }
    else if ([networkString isEqualToString:@"CTRadioAccessTechnologyEdge"])
    {
        return 2;
    }
    else if ([networkString isEqualToString:@"CTRadioAccessTechnologyWCDMA"])
    {
        return 3;
    }
    else if ([networkString isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"])
    {
        return 5;
    }
    else if ([networkString isEqualToString:@"CTRadioAccessTechnologyCDMARevA"])
    {
        return 6;
    }
    else if ([networkString isEqualToString:@"CTRadioAccessTechnologyCDMA1x"])
    {
        return 7;
    }
    else if ([networkString isEqualToString:@"CTRadioAccessTechnologyHSDPA"])
    {
        return 8;
    }
    else if ([networkString isEqualToString:@"CTRadioAccessTechnologyHSUPA"])
    {
        return 9;
    }
    else if ([networkString isEqualToString:@"CTRadioAccessTechnologyCDMARevB"])
    {
        return 12;
    }
    else if ([networkString isEqualToString:@"CTRadioAccessTechnologyLTE"])
    {
        return 13;
    }
    return -1;
}

- (NSString *) getNetworkString:(NSString *)networkString
{
    if ([networkString isEqualToString:@"CTRadioAccessTechnologyGPRS"])
    {
        return @"GPRS";
    }
    else if ([networkString isEqualToString:@"CTRadioAccessTechnologyEdge"])
    {
        return @"EDGE";
    }
    else if ([networkString isEqualToString:@"CTRadioAccessTechnologyWCDMA"])
    {
        return @"WCDMA";
    }
    else if ([networkString isEqualToString:@"CTRadioAccessTechnologyHSDPA"])
    {
        return @"HSDPA";
    }
    else if ([networkString isEqualToString:@"CTRadioAccessTechnologyHSUPA"])
    {
        return @"HSUPA";
    }
    else if ([networkString isEqualToString:@"CTRadioAccessTechnologyLTE"])
    {
        return @"LTE";
    }
    return @"default";
}

- (NSString *) getNetworkStringFromInteger:(NSInteger)networkType
{
    if (networkType == 1)
    {
        return @"GPRS";
    }
    else if (networkType == 2)
    {
        return @"EDGE";
    }
    else if (networkType == 3)
    {
        return @"WCDMA";
    }
    else if (networkType == 8)
    {
        return @"HSDPA";
    }
    else if (networkType == 9)
    {
        return @"HSUPA";
    }
    else if (networkType == 13)
    {
        return @"LTE";
    }
    return @"default";
}


- (NSString *) getNetworkTypeString:(NSString *)networkString
{
    if ([networkString isEqualToString:@"CTRadioAccessTechnologyEdge"] || [networkString isEqualToString:@"CTRadioAccessTechnologyGPRS"])
    {
        return @"2G";
    }
    else if ([networkString isEqualToString:@"CTRadioAccessTechnologyHSDPA"] || [networkString isEqualToString:@"CTRadioAccessTechnologyHSUPA"] || [networkString isEqualToString:@"CTRadioAccessTechnologyWCDMA"])
    {
        return @"3G";
    }
    else if ([networkString isEqualToString:@"CTRadioAccessTechnologyLTE"])
    {
        return @"4G";
    }
    return @"default";
}

- (NSString *) getNetworkTypeStringFromInteger:(NSInteger)networkType
{
    if (networkType == 2)
    {
        return @"2G";
    }
    else if (networkType == 8)
    {
        return @"3G";
    }
    else if (networkType == 13)
    {
        return @"4G";
    }
    return @"default";
}

- (NSString *) getCarrierName:(NSInteger)mnc
{
    if (mnc==0)
    {
        return @"Movistar";
    }
    else if (mnc==1)
    {
        return @"Claro";
    }
    else if (mnc==2)
    {
        return @"CNT";
    }
    return @"default";
    
}

- (NSString *) getCarrierImage:(NSString*)carrierName
{
    if ([carrierName isEqualToString:@"Claro"])
    {
        return @"icon_claro.png";
    }
    else if ([carrierName isEqualToString:@"Movistar"])
    {
        return @"icon_movistar.png";
    }
    else if ([carrierName isEqualToString:@"CNT"])
    {
        return @"icon_cnt.png";
    }
    return @"";
    
}

- (NSInteger) getConexionInt
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status == NotReachable)
    {
        return -1;
    }
    else if (status == ReachableViaWiFi)
    {
        return 1;
    }
    else if (status == ReachableViaWWAN)
    {
        return 2;
    }
    return 0;
}

- (NSString *) getConexionString
{
    NSInteger conexion = [self getConexionInt];
    if (conexion == -1)
    {
        return @"Sin Conexión";
    }
    else if (conexion == 1)
    {
        return @"Wi-Fi";
    }
    else if (conexion == 2)
    {
        return @"Red Móvil";
    }
    else
    {
        return @"Error";
    }
}

- (NSString *) getDateTimeString: (NSString *) dateTime
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd MMM, yyyy - HH.mm"];
        double time = [dateTime doubleValue];
    return [format stringFromDate:[NSDate dateWithTimeIntervalSince1970:(time/1000)]];
}

- (NSString *) getDateString: (NSString*) dateTime
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd MMM, yyyy"];
    double time = [dateTime doubleValue];
    return [format stringFromDate:[NSDate dateWithTimeIntervalSince1970:(time/1000)]];
}

- (NSString *) getTimeString: (NSString *) dateTime
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH.mm"];
    double time = [dateTime doubleValue];
    return [format stringFromDate:[NSDate dateWithTimeIntervalSince1970:(time/1000)]];
}


- (BOOL) isInternetAvailable
{
    NSInteger conexion = [self getConexionInt];
    return (conexion == 1 || conexion ==2 );
}

- (NSMutableURLRequest *) getSoapRequest: (NSString*) mensaje : (NSString *)fileName
{
    NSString *base64Text = [[mensaje dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    NSString *textOut = [NSString stringWithFormat:@"%@@%@",fileName,base64Text];
    NSString *messageOut = [self getSoapMessage:textOut];
    NSURL *serverUrl = [NSURL URLWithString:@"http://smovilecuador.supertel.gob.ec/CoberturaCelular/SMAWS"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:serverUrl];// cachePolicy:nil timeoutInterval:30000];
    [request addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"http://coberturacelular.supertel.gob.ec/SMAWS/" forHTTPHeaderField:@"SOAPAction"];
    [request addValue:[NSString stringWithFormat:@"%ld", (long)messageOut.length] forHTTPHeaderField:@"Content-Length"];
    //request.HTTPMethod = @"POST";
    [request setHTTPMethod:@"POST"];
//    request.HTTPBody = [messageOut dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    [request setHTTPBody:[messageOut dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO]];
    return request;
}

- (NSString *) getSoapMessage: (NSString *) data
{

    return [NSString stringWithFormat:@"<?xml version='1.0' encoding='UTF-8'?><soap:Envelope xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema'><soap:Body><getData xmlns='http://coberturacelular.supertel.gob.ec/'><data xmlns=''>%@</data></getData></soap:Body></soap:Envelope>", data];
}

- (NSMutableURLRequest *) getUploadRequest: (double) speed
{
    NSURL *serverUrl = [NSURL URLWithString:@"http://192.168.0.99/UploadToServer/UploadToServer.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:serverUrl];
    [request addValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n---------\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    /*
    [request addValue:[NSString stringWithFormat:@"%ld", (long)messageOut.length] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    request.HTTPBody = [messageOut dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
     */
    return request;
}

@end
