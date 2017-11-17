//
//  ReclamosController.m
//  CoberturaMovilIOS
//
//  Created by Supertel on 13/10/14.
//  Copyright (c) 2014 Superintendencia de Telecomunicaciones. All rights reserved.
//

#import "ReclamosController.h"
#import "Helper.h"


@interface ReclamosController ()

@end

@implementation ReclamosController
{
    double currentLatitude;
    double currentLongitude;
    NSString *currentAddress;
    NSString *currentCity;
    NSString *currentProvince;
    NSString *operadora;
    NSString *identifier;
    NSInteger networkType;
    NSInteger mcc;
    NSInteger mnc;
    NSInteger reportType;
    NSMutableData *wsResponse;
    NSString *response;
    double datetime;
    int responseCode;
    UIColor *currentTextBackgroundColor;
    UITapGestureRecognizer *tapRecognizer;
    int withGps;
    bool requested;
    NSTimeInterval initialTimeReclamo;
}

@synthesize tipoReclamo;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do view setup here.
    self.view.userInteractionEnabled = YES;
    currentTextBackgroundColor = self.ciudad.backgroundColor;
    self.mapaDescripcion.hidden = YES;
    self.activityIndicator.hidden = YES;
    self.tipoReclamo.selectedSegmentIndex = -1;
    reportType = -1;
    self.tipoReclamoDescripcion.hidden = YES;
    requested = NO;
    

    [self initializeLocManager];
    withGps=0;
    currentLatitude=-900;
    currentLongitude=-900;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fromBackground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    if (self.lm.location == nil)
    {
        [self initializeLocManager];
    }
    self.screenName = @"Reclamos";
}

- (void) fromBackground
{
    if (self.lm.location == nil)
    {
        [self initializeLocManager];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{

}

- (void) getNetworkInfo
{
    /*Datos de la Red*/
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    networkType = [[Helper alloc] getNetworkInt:[networkInfo currentRadioAccessTechnology]];
    if (networkType!=-1)
    {
        CTCarrier *carrierInfo = [networkInfo subscriberCellularProvider];
        mcc = [[carrierInfo mobileCountryCode] integerValue];
        mnc = [[carrierInfo mobileNetworkCode] integerValue];
        
        if (mcc==740)
        {
            operadora = [[Helper alloc] getCarrierName:mnc];
        }
    }
}

- (void) initializeLocManager
{
    
    [self getNetworkInfo];
    if (!self.lm)
    {
        self.lm = [[CLLocationManager alloc] init];
        self.lm.delegate = self;
    }
        if ([CLLocationManager locationServicesEnabled])
        {
            if ([self.lm respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)
                {
                    self.lm.desiredAccuracy = kCLLocationAccuracyBest;
                    [self.lm startUpdatingLocation];
                    self.mapa.showsUserLocation = YES;
                }
                else
                {
                    [self.lm requestAlwaysAuthorization];
                }

            }
            else
            {
//                if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)
          //      if (self.lm.location == nil)
            //    {
                    self.lm.desiredAccuracy = kCLLocationAccuracyBest;
                    [self.lm startUpdatingLocation];
                    self.mapa.showsUserLocation = YES;
              //  }
               // else
               // {
                    
               //     self.mapa.showsUserLocation = YES;
               // }
              
            }
        }
        else
        {
            [self showAlert:@"Uso Localización" :@"Debe activar el uso de Localización en su dispositivo para usar esta aplicación"];
        }
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.ciudad resignFirstResponder];
}

- (void) didReceiveMemoryWarning
{

}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
}

- (IBAction)removeKeyboard:(id)sender
{
    [[self view] endEditing:YES];
}

- (IBAction)send:(id)sender
{
    [self getNetworkInfo];
    
   if ([[Helper alloc] isInternetAvailable])
    {
        if (currentLatitude!=-900 && currentLongitude!=-900 && reportType!=-1 && mcc!=0)
        {
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"eventos"     // Event category (required)
                                                                  action:@"boton_presionado"  // Event action (required)
                                                                   label:@"reclamo_enviar"          // Event label
                                                                   value:nil] build]];    // Event value
            initialTimeReclamo = [[NSDate date] timeIntervalSince1970];
            
            //Crear cadena de texto y enviar al web service
            NSMutableURLRequest *request = [[Helper alloc] getSoapRequest:[self getTextString] : [self getNewFileName]];
            NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
            [connection start];
            if (connection)
            {
                wsResponse = [NSMutableData alloc];
                self.btn_send.enabled = NO;
                [self.view setAlpha:0.5];
                [self.activityIndicator startAnimating];
                self.activityIndicator.hidden = NO;
                self.mapa.showsUserLocation = NO;
            }
        }
        else if (mcc == 0)
        {
            [self showAlert:@"Conexión de Red" :@"El dispositivo debe estar conectado a una operadora móvil"];
        }
        else if (reportType == -1)
        {
            [self showAlert:@"Reclamo" :@"Debe escoger un tipo de reclamo"];
        }
        else
        {
            //No ha obtenido localización
            [self showAlert:@"Localización" :@"Deben obtenerse datos de su localización para enviar el reclamo"];
        }
    }
    else
    {
        //No tiene conexion a internet disponible
        [self showAlert:@"Conexión a Internet" :@"Conéctese a una Red Móvil o Wi-Fi para enviar el reclamo"];
    }
    response = nil;
    
}

- (IBAction)cleanAll:(id)sender
{
    /*if (self.lm)
    {
        [self.lm stopUpdatingLocation];
        self.lm = nil;
    }
    self.tipoReclamoDescripcion.hidden = YES;
    currentLongitude = -900;
    currentLatitude = -900;*/
    self.descripcion.text = @"";
    /*
    [self restartTextViews];
    self.tipoLocation.selectedSegmentIndex = -1;
    */
    self.tipoReclamo.selectedSegmentIndex = -1;
    reportType = -1;
    //self.mapa.showsUserLocation = NO;
    //[self.mapa removeAnnotations:[self.mapa annotations]];
    //[self.mapa removeGestureRecognizer:tapRecognizer];
    MKCoordinateRegion region = [self.mapa regionThatFits:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(-1.505124, -78.903637), 500000, 500000)];
    [self.mapa setRegion:region animated:YES];

}

- (IBAction)changeLocation:(id)sender
{
    if (self.tipoLocation.selectedSegmentIndex == 0)
    {
        //Localizacion Actual
        [self restartTextViews];
        self.mapa.showsUserLocation = YES;
        [self initializeLocManager];
        self.mapaDescripcion.hidden = YES;
        [self.mapa removeAnnotations:[self.mapa annotations]];
        [self.mapa removeGestureRecognizer:tapRecognizer];
        withGps = 1;
        currentLatitude = -900;
        currentLongitude = -900;
    }
    else if (self.tipoLocation.selectedSegmentIndex == 1)
    {
        //Escoger Localización

        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.mapaDescripcion.hidden = NO;
            [self restartTextViews];
            self.mapa.showsUserLocation = NO;
        } completion:nil];

        if (self.lm)
        {
            [self.lm stopUpdatingLocation];
            self.lm = nil;
        }

        withGps = 0;
        currentLatitude = -900;
        currentLongitude = -900;
        
        /*tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getTapLocation:)];
        tapRecognizer.numberOfTapsRequired = 1;
        tapRecognizer.numberOfTouchesRequired = 1;
        [self.mapa addGestureRecognizer:tapRecognizer];
        */
    }
}

- (IBAction)changeType:(id)sender
{
    self.tipoReclamoDescripcion.hidden = NO;
    if (self.tipoReclamo.selectedSegmentIndex == 0)
    {
        //Llamada Fallida
        [self showDetail:0];
        reportType = 0;
    }
    else if (self.tipoReclamo.selectedSegmentIndex == 1)
    {
        //Llamada Caída
        [self showDetail:1];
        reportType = 1;
    }
    else if (self.tipoReclamo.selectedSegmentIndex == 2)
    {
        //Sin Internet
        [self showDetail:2];
        reportType = 2;
    }
    else if (self.tipoReclamo.selectedSegmentIndex == 3)
    {
        //Sin Cobertura
        [self showDetail:3];
        reportType = 3;
    }
}

- (void) showDetail : (int) tipo
{
    NSString *message_ = @"";
    if (tipo == 0)
    {
        message_ = @"Llamada Fallida";
        self.tipoReclamoDescripcion.text = @"Llamada no establecida con el destinatario";
    }
    else if (tipo == 1)
    {
        message_ = @"Llamada Caída";
        self.tipoReclamoDescripcion.text = @"Llamada interrumpida por la operadora móvil";
    }
    else if (tipo == 2)
    {
        message_ = @"Sin Internet";
        
        self.tipoReclamoDescripcion.text = @"Sin Internet: pérdida de conexión de datos";
    }
    else if (tipo == 3)
    {
        message_ = @"Sin Cobertura";
        
        self.tipoReclamoDescripcion.text = @"Sin Cobertura: sin servicio de voz y datos";
    }
    
    self.descripcion.text = message_;
    
}

/* Metodos de Location*/

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations objectAtIndex:0];
    if (currentLatitude != currentLocation.coordinate.latitude || currentLongitude != currentLocation.coordinate.longitude)
    {
        MKCoordinateRegion region = [self.mapa regionThatFits:MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000, 1000)];
        [self.mapa setRegion:region animated:YES];
        
        currentLatitude = currentLocation.coordinate.latitude;
        currentLongitude = currentLocation.coordinate.longitude;
        [self doReverseGeocoding:currentLocation];
    }
    
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@",[NSString stringWithFormat:@"Error %@", error.localizedDescription]);
}

- (void) doReverseGeocoding: (CLLocation *) currentLocation
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation   completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error)
         {
             return;
         }
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         if (placemark)
         {
             if (placemark.thoroughfare){
                 currentAddress = [NSString stringWithString:placemark.thoroughfare];
                 self.direccion.text = currentAddress;
                 [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                     self.direccion.enabled = NO;
                     [self.direccion setBackgroundColor:[UIColor grayColor]];
                 } completion:nil];

             }
             if (placemark.locality)
             {
                 currentCity = [NSString stringWithString:placemark.locality];
                 self.ciudad.text = [NSString stringWithFormat:@"%@", currentCity];
                 [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                     self.ciudad.enabled = NO;
                     [self.ciudad setBackgroundColor:[UIColor grayColor]];
                 } completion:nil];
                 
             }
             if (placemark.administrativeArea)
             {
                 currentProvince = [NSString stringWithString:placemark.administrativeArea];
                 self.provincia.text = [NSString stringWithFormat:@"%@", currentProvince];
                 [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                     self.provincia.enabled = NO;
                     [self.provincia setBackgroundColor:[UIColor grayColor]];
                 } completion:nil];
             }
         }
     }];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
//    if (status == kCLAuthorizationStatusAuthorizedWhenInUse)
    if (requested)
    {
        if ([self.lm respondsToSelector:@selector(requestAlwaysAuthorization)] && status == kCLAuthorizationStatusAuthorizedAlways)
        {
            [self initializeLocManager];
        }
        else if (status == kCLAuthorizationStatusAuthorized)
        {
            [self initializeLocManager];
        }
        else
        {
            [self showAlert:@"Permiso de Localización" :@"Debe otorgar permisos de localización a la aplicación en Ajustes>Privacidad>Localización"];
            //[self initializeLocManager];
        }
    }
    else
    {
        requested = YES;
    }
    
}

- (IBAction) getTapLocation: (UITapGestureRecognizer *) recognizer
{
    
    self.mapaDescripcion.hidden = YES;
    if (recognizer.state != UIGestureRecognizerStateEnded)
        return;
    
    [self restartTextViews];
    
    [self.mapa removeAnnotations:self.mapa.annotations];
    CGPoint point = [recognizer locationInView:self.mapa];
    CLLocationCoordinate2D tapPoint = [self.mapa convertPoint:point toCoordinateFromView:self.mapa];
    currentLatitude = tapPoint.latitude;
    currentLongitude = tapPoint.longitude;
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:currentLatitude longitude:currentLongitude];
    [self doReverseGeocoding:currentLocation];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.title = @"Annotation";
    annotation.coordinate = tapPoint;
    [self.mapa addAnnotation:annotation];
    MKCoordinateRegion region = [self.mapa regionThatFits:MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000, 1000)];
    [self.mapa setRegion:region animated:YES];

}

/* METODOS DE LA ALERTA */

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            break;
        default:
            break;
            
    }
}

- (void) showAlert: (NSString *)title_ : (NSString *)message_
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title_ message:message_ delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    
}

/* METODOS PARA ENVIO DE RECLAMOS */

- (NSString *) getTextString
{
    int os = 0;
    UIDevice *device = [UIDevice currentDevice];
    NSString *osversion = [device systemVersion];
    NSString *model = [device model];
    identifier = [[device identifierForVendor] UUIDString];
    NSString *deviceName = [device name];
    datetime = [[NSDate date] timeIntervalSince1970] * 1000;
    
    NSString *textOut = [NSString stringWithFormat:@"%d;%@;Apple;%@;%@;%@!%.0f;%ld;%ld;0;%ld;%ld;%f;%f;%d;%@;%@;%@;%@;%@", os, osversion,  model, deviceName, identifier, datetime, (long)networkType, (long)reportType, (long)mcc, (long)mnc, currentLatitude, currentLongitude, withGps, operadora, self.provincia.text, self.ciudad.text, self.direccion.text, self.descripcion.text];
    self.descripcion.text = textOut;
    
    return textOut;
}

- (NSString *) getNewFileName{

    NSString *fileName = [NSString stringWithFormat:@"cc_2_%@_%.0f.txt",[identifier substringFromIndex:[identifier length]-5],datetime];
    return fileName;
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    responseCode = [(NSHTTPURLResponse *)response statusCode];
    if (responseCode == 200)//RESPUESTA OK
    {
        wsResponse.length = 0;
    }
    else if (responseCode == 404)//RESPUESTA NO ENCONTRADO
    {
        [self showAlert:@"Respuesta del Servidor" :@"El recurso al que intenta acceder no fue encontrado. Por favor envíe un correo a msupertel@supertel.gob.ec para solucionar el inconveniente (Código:404)"];
    }
    else if (responseCode == 408)//RESPUESTA TIMEOUT
    {
        [self showAlert:@"Respuesta del Servidor" :@"El servidor se encuentra ocupado. Por favor intente más tarde. (Código:408)"];
    }
    else
    {
        [self showAlert:@"Respuesta del Servidor" :[NSString stringWithFormat: @"El servidor envió una respuesta inválida. Por favor intente más tarde. Si el problema persiste por favor repórtelo a msupertel@supertel.gob.ec (Código:%d)", responseCode]];
    }
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (responseCode == 200)
    {
        [wsResponse appendData:data];
    }

}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSInteger code = error.code;
    if (code == -1001)//Timeout
    {
        [self showAlert:@"Error" : [NSString stringWithFormat:@"Ocurrió un error en la conexión. El servidor no envió una respuesta. Intente más tarde. (Código:%ld)", (long)[error code]]];
    }
    else
    {
        [self showAlert:@"Error" : [NSString stringWithFormat:@"Ocurrió un error en la conexión. Por favor intente mas tarde. (Código:%ld)", (long)[error code]]];
    }
    self.btn_send.enabled = YES;
    [self.view setAlpha:1.0];
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    self.mapa.showsUserLocation = YES;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseCode == 200)
    {
        NSString *xmlResponse = [[NSString alloc] initWithData:wsResponse encoding:NSUTF8StringEncoding];
        if (xmlResponse && xmlResponse.length>0)
        {
            //_descripcion.text = xmlResponse;
            NSXMLParser *parser = [[NSXMLParser alloc] initWithData:wsResponse];
            parser.delegate = self;
            [parser parse];
            //_descripcion.text = @"";
        }
    }
    self.btn_send.enabled = YES;
    [self.view setAlpha:1.0];
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    self.mapa.showsUserLocation = YES;
}

/* Metodos del Parser*/

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    response = [NSString alloc];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    response = string;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"return"])
    {
        if ([response isEqualToString:@"false"])
        {
            [self showAlert:@"Envío de Reclamos" :@"El servidor no pudo guardar su reporte. Intente de nuevo más tarde."];

            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"eventos"     // Event category (required)
                                                                  action:@"webservice"  // Event action (required)
                                                                   label:@"reclamo_no_recibido"          // Event label
                                                                   value:nil] build]];    // Event value
        }
        else if ([response isEqualToString:@"true"])
        {
            [self showAlert:@"Envío de Reclamos" :@"Su reporte ha sido enviado satisfactoriamente"];
            [self cleanAll:nil];
            
            
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"eventos"     // Event category (required)
                                                                  action:@"webservice"  // Event action (required)
                                                                   label:@"reclamo_recibido"          // Event label
                                                                   value:nil] build]];    // Event value
        }
        
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
        NSNumber *loadTime = [NSNumber numberWithInt:((int)(currentTime-initialTimeReclamo)*1000)];
        id tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createTimingWithCategory:@"tiempo_carga"    // Timing category (required)
                                                             interval:loadTime        // Timing interval (required)
                                                                 name:@"reclamo_envio"  // Timing name
                                                                label:nil] build]];
    }
}

- (void) restartTextViews
{
    self.provincia.text = @"";
    [self.provincia setBackgroundColor:currentTextBackgroundColor];
    self.provincia.enabled = YES;
    self.ciudad.text = @"";
    [self.ciudad setBackgroundColor:currentTextBackgroundColor];
    self.ciudad.enabled = YES;
    self.direccion.text = @"";
    [self.direccion setBackgroundColor:currentTextBackgroundColor];
    self.direccion.enabled = YES;
}

@end
