//
//  VelocidadTestController.m
//  CoberturaMovilIOS
//
//  Created by Supertel on 06/10/14.
//  Copyright (c) 2014 Superintendencia de Telecomunicaciones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VelocidadTestController.h"
#import "Tab_VelocidadController.h"
#import "DBHelper.h"
#import "Helper.h"
#import "Reachability.h"


@interface VelocidadTestController()

@end

@implementation VelocidadTestController

/*
    #define isIpad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    #define isIphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    #define screenWidth ([[UIScreen mainScreen] bounds].size.width)
    #define screenHeight ([[UIScreen mainScreen] bounds].size.height)
    #define screenMaxLength (MAX(screenWidth, screenHeight))
    #define screenMinLength (MIN(screenWidth, screenHeight))
    #define isIphone4s (isIphone && screenMaxLength < 568.0)
    #define isIphone5 (isIphone && screenMaxLength == 568.0)
    #define isIphone6 (isIphone && screenMaxLength > 568.0)
*/
    double currentLatitude=-900;
    double currentLongitude=-900;
    double downloadSpeed=0;
    double uploadSpeed=0;
    double speed=0;
    double angle_ipad=43.0;
    double angle_iphone6=44.5;
    double angle_iphone5=44.5;
    double angle_iphone4=42.5;
    double angle=42.5;
    CGFloat* previous_speed=0;
    NSInteger mcc;
    NSInteger mnc;
    NSInteger ping=0;
    NSInteger conexion;
    NSInteger networkType;
    NSString *proveedor;
    NSString *currentAddress;
    NSString *currentCity;
    NSString *currentProvince;
    NSString *response;
    int responseCode;
    NSMutableData *ws_response;
    NSTimeInterval initialTime;
    NSTimeInterval finalTime;
    NSTimeInterval initialTestTime;
    NSTimeInterval initialSendTime;
    CGFloat totalLength;
    //CGFloat currentTotalLength=295994;
    CGFloat currentTotalLength=0;
    Boolean isDownload;
    CGPoint currentImgPosition;
    CGPoint currentTxtPosition;
    CGPoint cityCenter;
    NSString * identifier;
    double datetime;
    BOOL isLocationUpdating=NO;
    BOOL isIphone4s = NO;
    BOOL isIphone5 = NO;
    BOOL isIphone6 = NO;
    BOOL isIpad = NO;
//    NSString * uploadUrl = @"http://190.57.148.84:8180/ImageUploadWebApp/uploadimg.jsp";
    NSString * uploadUrl = @"http://smovilecuador.supertel.gob.ec/ImageUploadWebApp/uploadimg.jsp";


-(void) viewWillAppear:(BOOL)animated
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized){
        //[self.btn_start setEnabled:YES];
    }
    [self getNetworkInfo];
    self.screenName = @"Speedtest Medidor";
}

- (void) viewDidLoad
{

    /* Initialize Location Updates */
    [self initializeLocManager];
    isDownload = NO;
    cityCenter = [_city center];
    [_img_dummy setHidden:YES];
    [_txt_dummy setHidden:YES];
    [_city setHidden:YES];
    [_address setHidden:YES];
    [_date_time setHidden:YES];
    [_txt_init setHidden:YES];
    [_indicator setHidden:YES];
    [_btn_start setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startTest:)];
    [singleTap setNumberOfTapsRequired:1];
    [_btn_start addGestureRecognizer:singleTap];
    [_progress_bar setProgress:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fromBackground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [self detectSize];
}

- (void) fromBackground
{
    [self getNetworkInfo];
}

- (IBAction)setSpeed:(id)sender
{
    [self animateNeedle: [self.txt_speed.text doubleValue]];

}

- (void) detectSize
{
    isIpad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    bool isIphone = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
    double screenWidth = ([[UIScreen mainScreen] bounds].size.width);
    double screenHeight = ([[UIScreen mainScreen] bounds].size.height);
    double screenMaxLength = (MAX(screenWidth, screenHeight));
//    double screenMinLength = (MIN(screenWidth, screenHeight));
    isIphone4s = (isIphone && screenMaxLength < 568.0);
    isIphone5 = (isIphone && screenMaxLength == 568.0);
    isIphone6 = (isIphone && screenMaxLength > 568.0);
    
    
    if (isIphone4s)
    {
        [self animateNeedle:-.03];
    }
    else if (isIphone5)
    {
        [self animateNeedle:0];
    }
}

- (void) getNetworkInfo
{
    /* Get Mobile Network Info */
    
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    //CTCarrier *carrierInfo = [networkInfo subscriberCellularProvider];
    networkType = [[Helper alloc] getNetworkInt:[networkInfo currentRadioAccessTechnology]];
    conexion = [[Helper alloc] getConexionInt];
    if ( conexion == 1)
    {
        //WIFI
        [_img_wifi setHidden:NO];
        [_img_wifi setImage:[UIImage imageNamed:@"logo_wifi.png"]];
        [_network setHidden:YES];
        [_img_operadora setHidden:YES];
    }
    else if ( conexion == 2 )
    {
        //RED MOVIL
        if (networkType!=-1)
        {
            CTCarrier *carrierInfo = [networkInfo subscriberCellularProvider];
            mcc = [[carrierInfo mobileCountryCode] integerValue];
            mnc = [[carrierInfo mobileNetworkCode] integerValue];
            
            if (mcc==740)
            {
                proveedor = [[Helper alloc] getCarrierName:mnc];
                [_img_operadora setImage:[UIImage imageNamed:[[Helper alloc] getCarrierImage:proveedor]]];
                [_img_operadora setHidden:NO];
                [_network setText:[[Helper alloc] getNetworkTypeStringFromInteger:networkType]];
                [_network setHidden:NO];
                [_img_wifi setHidden:YES];
            }
            else
            {
                [_img_operadora setHidden:YES];
                [_network setHidden:YES];
                [_img_wifi setHidden:YES];
            }
        }
        else
        {
            [_img_operadora setHidden:YES];
            [_network setHidden:YES];
            [_img_wifi setHidden:YES];
        }
    }

    
}

-(void)startTest:(UIGestureRecognizer *)recognizer
{
    conexion = [[Helper alloc] getConexionInt];
   // _date_time.text = [[Helper alloc] getDateTimeString:[[NSDate date] timeIntervalSince1970]*1000];
    if (isLocationUpdating)
    {
        if ([[Helper alloc] isInternetAvailable])
        {
            [self startPinging];
        }
        else
        {
            [self showAlert:@"Conexión a Internet" :@"Conéctese a una Red Móvil o Wi-Fi para usar el medidor de velocidad"];
        }
    }
    else
    {
        [self initializeLocManager];
    }
    
}

- (void) startPinging
{
    //Tamaño del archivo de prueba
    currentTotalLength=540233;
      //Descargar un archivo pequeño para determinar la velocidad y segun eso descargar un archivo más grande
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://190.57.148.84:8180/SpeedTestDownload/imagen_uno.jpg"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://smovilecuador.supertel.gob.ec/SenalMovilEcuadorWeb/recursos/SpeedTestDownload/imagen_uno.jpg"]];
    self.previousConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    [self.previousConnection start];
    [self animateButton:0];
    [_city setHidden:YES];
    [_address setHidden:YES];
    [_date_time setHidden:YES];
    [_download_speed setText:@""];
    [_upload_speed setText:@""];
    [self animateNeedle:0];

    [_indicator setHidden:NO];
    [_indicator startAnimating];
    

    /*
     [_txt_init setHidden:NO];
     [_txt_init setAlpha:1];
     [_txt_init setText:@"Inicializando..."];
     */
    // _date_time.text = [[Helper alloc] getDateString:[[NSDate date] timeIntervalSince1970]];
    /*[UIView animateWithDuration:0.6 delay:0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
        [_txt_init setAlpha:0];
    } completion:nil
    ];*/
  //  self.timer = [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(toggleLabelAlpha) userInfo:nil repeats:YES];
  //  [self.timer fire];
    [_progress_bar setProgress:0];

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"eventos"     // Event category (required)
                                                          action:@"boton_presionado"  // Event action (required)
                                                           label:@"speedtest_iniciar"          // Event label
                                                           value:nil] build]];    // Event value
    initialTestTime = [[NSDate date] timeIntervalSince1970];
}

- (void) startDownload: (NSString *)urlString
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    self.testConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    [self.testConnection start];
    _progress_bar.progress = 0;
    isDownload = YES;
    [self animateElements:0 :1];
    [self animateButton:0];
    [self animateNeedle:0];
    [self.download_speed setText:@"Descarga"];
   // [self.timer finalize];
//    [_txt_init setText:@""];
}

- (void) startUpload: (CGFloat *)speed_
{
    isDownload = NO;
    [self.upload_speed setText:@"Carga"];
    
    NSData *imageData = [self getUploadData:previous_speed];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:uploadUrl]];
    [request setHTTPMethod:@"POST"];

    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];

    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploaded_file\";filename=\"filename.png\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: multipart/form-data;boundary=%@\r\n\r\n", boundary ] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // setting the body of the post to the request
    [request setHTTPBody:body];

    self.uploadConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    [self.uploadConnection start];
    
    [self animateElements:1 :1];
    
    initialTime = [[NSDate date] timeIntervalSince1970];
    totalLength = 0;
}

- (void) saveToDatabase{
    
   // if (conexion == 2)
  //  {
        NSString * time = [NSString stringWithFormat:@"%.0f", (initialTime * 1000)];
        VelocidadTest *tmp = [[VelocidadTest alloc] initWithId:-1 withDateTime:time withConexion:conexion withProveedor:proveedor withNetworkType:networkType withMcc:mcc withMnc:mnc withPing:ping withDownloadSpeed:downloadSpeed withUploadSpeed:uploadSpeed withLatitude:currentLatitude withLongitude:currentLongitude withProvince:currentProvince withCity:currentCity withAddress:currentAddress withStatus:0];
        
        BOOL saved = [[DBHelper getSharedInstance] insertTest:tmp];
        if (saved && conexion == 2){
            [self sendSpeedtest:tmp];
        }
   // }
}

- (void) sendSpeedtest: (VelocidadTest *)test
{
    if ([[Helper alloc] isInternetAvailable])
    {
        if (currentLatitude!=-900 && currentLongitude!=-900)
        {
            //Crear cadena de texto y enviar al web service
            NSMutableURLRequest *request = [[Helper alloc] getSoapRequest:[self getTextString:test] : [self getNewFileName]];
            self.sendConnection = [NSURLConnection connectionWithRequest:request delegate:self];
            [self.sendConnection start];
            if (self.sendConnection)
            {
                ws_response = [NSMutableData alloc];
            }
            
            initialSendTime = [[NSDate date] timeIntervalSince1970];
        }
    }
}

- (void)toggleLabelAlpha {
    
    [self.txt_init setHidden:(!self.txt_init.hidden)];
}

- (void) initializeLocManager
{
    [self getNetworkInfo];
    if ([CLLocationManager locationServicesEnabled])
    {
        if (!isLocationUpdating)
        {
            self.lm = [[CLLocationManager alloc] init];
            if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways){
                self.lm.delegate = self;
                self.lm.desiredAccuracy = kCLLocationAccuracyBest;
                [self.lm startUpdatingLocation];
                isLocationUpdating = YES;
            }
            else
            {
                [self.lm requestAlwaysAuthorization];
                isLocationUpdating = NO;
                //            [self showAlert:@"Permiso de Localización" :@"Debe permitir a esta aplicación acceder a su localización en Ajustes>Privacidad>Localización"];
                //          [self.btn_start setEnabled:NO];
            }
        }
    }
    else
    {
        [self showAlert:@"Uso Localización" :@"Debe activar el uso de Localización en su dispositivo para usar esta aplicación"];
        isLocationUpdating = NO;
    }
}

/* METODOS DE LA CONEXION A INTERNET CARGA/DESCARGA DE DATOS */

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    [_indicator stopAnimating];
    [_indicator setHidden:YES];
    
    if (connection == self.testConnection)
    {
        [self showAlert:@"Error" : [NSString stringWithFormat:@"Ocurrió un error en la conexión. Por favor intente mas tarde. (%ld)", (long)[error code]]];
        [self animateButton:1];
        [self animateElements:0 :0];
    }
    else if (connection == self.previousConnection)
    {
        //Error, paralizar el test
        [self showAlert:@"Error" : [NSString stringWithFormat:@"Ocurrió un error inicializando la prueba de velocidad. Intente más tarde"]];
        [self animateButton:1];
        //[_txt_init setText:@""];
    }
    else if (connection == self.uploadConnection)
    {
        [self showAlert:@"Error" : [NSString stringWithFormat:@"Ocurrió un error en el test de velocidad de carga. Intente más tarde"]];
        [self animateElements:1 :0];
        [self animateButton:1];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    responseCode = [(NSHTTPURLResponse *)response statusCode];
    if (responseCode == 200)
    {
        ws_response.length = 0;
        initialTime = [[NSDate date] timeIntervalSince1970];
        totalLength = 0;
        //[self rotateToZero];
    }
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if (connection == self.uploadConnection)
    {
        totalLength += bytesWritten;
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
        speed = (totalLength*8/1000000)/(currentTime-initialTime);
        uploadSpeed = speed;
        [self animateNeedle:speed];
//        _txt_dummy.text = [NSString stringWithFormat:@"%.2f", speed];
          _upload_speed.text = [NSString stringWithFormat:@"%.2f", speed];

        _progress_bar.progress = totalLength / currentTotalLength;
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (responseCode == 200)
    {
        [ws_response appendData:data];
        if (connection == self.testConnection || connection == self.previousConnection)
        {
            totalLength += [data length];
             //Calcular velocidad actual en Mbps (bytes/1000000*8)/(currentTime-initialTime)
            NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
            speed = (totalLength*8/1000000)/(currentTime-initialTime);
            _progress_bar.progress = totalLength/currentTotalLength;
            if (connection == self.testConnection)
            {
                [self animateNeedle:speed];
                if (isDownload){
                    _download_speed.text = [NSString stringWithFormat:@"%.2f", speed];
                    downloadSpeed = speed;
                }
                else
                {
                  /*  _upload_speed.text = [NSString stringWithFormat:@"%.2f", speed];
                    uploadSpeed = speed;
                    _progress_bar.progress = totalLength/currentTotalLength;
                   */
                }
            }
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseCode == 200)
    {
        if (connection == self.sendConnection)
        {
            //Parse server response
            NSString *xmlResponse = [[NSString alloc] initWithData:ws_response encoding:NSUTF8StringEncoding];
            if (xmlResponse && xmlResponse.length>0)
            {
                NSXMLParser *parser = [[NSXMLParser alloc] initWithData:ws_response];
                parser.delegate = self;
                [parser parse];
                
            }
        }
        else if (connection == self.testConnection)
        {
            if (totalLength == currentTotalLength || !isDownload)
            {
                if (isDownload)
                {
                    [self animateElements:0 :0]; //Elementos de Download hacia abajo
                    [self startUpload:previous_speed];
                }
           /*     else
                {
                    [self animateElements:1 :0]; //Elementos de Upload hacia abajo
                    [self saveToDatabase];
                }*/
            }
            else
            {
                //Descarga no completada
                [self animateButton:1];
            }
        }
        else if (connection == self.previousConnection)
        {
            if (totalLength == currentTotalLength)
            {
                [_city setText:@""];
                previous_speed = &speed;
                [self startDownload:[self getURLString:speed]];
            }
            else
            {
                [self showAlert:@"Error" :@"Ocurrió un error al momento de inicializar la prueba de velocidad"];
            }
        }
        /*else if (connection == self.uploadConnection)
        {
           // if (totalLength == currentTotalLength)
          //  {
                [self animateElements:1 :0]; //Elementos de Upload hacia abajo
                [self animateButton:1];
                [self saveToDatabase];
           // }
        }*/
        
    }
    else if (connection == self.uploadConnection)
    {
            // if (totalLength == currentTotalLength)
            //  {
            [self animateElements:1 :0]; //Elementos de Upload hacia abajo
            [self animateButton:1];
            [self saveToDatabase];
            // }
        
            NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
            NSNumber *loadTime = [NSNumber numberWithInt:((int)(currentTime-initialTestTime)*1000)];
            id tracker = [[GAI sharedInstance] defaultTracker];
            [tracker send:[[GAIDictionaryBuilder createTimingWithCategory:@"tiempo_carga"    // Timing category (required)
                                                             interval:loadTime        // Timing interval (required)
                                                                 name:@"speedtest_medicion"  // Timing name
                                                                label:nil] build]];
    }
    else
    {
        //Error en la descarga/carga
        //Mostrar mensaje de Error
        [self animateRestartViews];
        [self animateButton:1];
        //restartViews()
    }
}

/* METODOS DE LAS ANIMACIONES */

- (void) animateNeedle: (double) speed{
    /*
     Se ajusta el ángulo al cual deben rotar la aguja del velocìmetro.
     Está ajustado para teléfonos iPhone 5, 5s, 6 y 6s.
     Para iPhone 5s y iPad, se hacen unos ajustes en el àngulo, debido al redimensionamiento de los componentes graficos
    */
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    if (isIphone4s)
    {
        angle=angle_iphone4;
    }
    else if (isIphone5)
    {
        angle=angle_iphone5;
    }
    else if (isIphone6)
    {
        angle=angle_iphone6;
    }
    else if (isIpad)
    {
        angle=angle_ipad;
    }
    
    double angleDev = angle;
    if (speed>=5)
    {
        if (isIphone4s)
        {
            angleDev = angle_iphone4+1.3+.6;
        }
        if (isIpad)
        {
            angleDev = angle_ipad+1.3;
        }
        [self.img_needle setTransform: CGAffineTransformMakeRotation((M_PI / 180) * (angleDev) * 6)];
    }
    else if (speed>=1)
    {
        if (speed>=3 && isIphone4s)
        {
            angleDev = angle_iphone4+1.5;
        }
        else if (speed >=3 && isIpad)
        {
            angleDev = angle_ipad + 1.2;
        }
        [self.img_needle setTransform: CGAffineTransformMakeRotation((M_PI / 180) * ((angleDev * speed)+angle))];
    }
    else
    {
        [self.img_needle setTransform: CGAffineTransformMakeRotation((M_PI / 180) * (angleDev * 2 * speed))];
    }
    [UIView commitAnimations];

}

- (void) animateElements: (int) indicadorTipo : (int) indicadorDireccion {
    /* 
        INDICADOR_TIPO = 0 DOWNLOAD ELEMENTS
        INDICADOR_TIPO = 1 UPLOAD ELEMENTS
        INDICADOR_DIRECCION = 1 HACIA ARRIBA
        INDICADOR_DIRECCION = 0 HACIA ABAJO
        Mueve los elementos de Carga/Descarga hacia el centro y a su lugar original
        Muestra y oculta botones y elementos de texto
    */
    
   // CGPoint img_position = [_img_dummy center];
    CGPoint txt_position = [_txt_dummy center];
    if (indicadorTipo == 0 && indicadorDireccion == 0)
    {
        //Elementos de Descarga hacia abajo
        
        [UIView animateWithDuration:1.0 delay:0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
            _download_speed.center = currentTxtPosition;
            _download_speed.text = [NSString stringWithFormat: @"%@ Mbps", _download_speed.text];
            //_img_download.center = currentImgPosition;
        } completion:nil];

    }
    else if (indicadorTipo == 0 && indicadorDireccion == 1)
    {
        //Elementos de Descarga hacia arriba
        currentImgPosition = [_img_download center];
        currentTxtPosition = [_download_speed center];
        
        [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _download_speed.center = txt_position;
        } completion:nil];

    }
    else if (indicadorTipo == 1 && indicadorDireccion == 0)
    {
        //Elementos de Carga hacia abajo
        [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _upload_speed.center = currentTxtPosition;
            _upload_speed.text = [NSString stringWithFormat: @"%@ Mbps", _upload_speed.text];
        } completion:nil];
        [self animateButton:1];
        [_date_time setHidden:NO];
        [self animateShowViews];
        
        
    }
    else if (indicadorTipo == 1 && indicadorDireccion == 1)
    {
        //Elementos de Carga hacia arriba
        currentImgPosition = [_img_upload center];
        currentTxtPosition = [_upload_speed center];
        [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _upload_speed.center = txt_position;
        } completion:nil];    }
    
}

- (void) animateButton: (int) indicador
{
    if (indicador == 0){
        //ocultar buton
        _btn_start.hidden = YES;
    }
    else
    {
        //mostrar boton
        _btn_start.hidden = NO;
    }
}

- (void) animateRestartViews
{
    if (isDownload)
    {
       [self animateElements:0 :0];
    }
    else
    {
       [self animateElements:1 :0];
    }
}

- (void) animateShowViews
{
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_date_time setHidden:NO];
    } completion:nil];
    
    if (![_address.text isEqualToString:@"Dirección"]){
        [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [_address setHidden:NO];
        } completion:nil];
    }
    if (![_city.text isEqualToString:@"Ciudad"]){
       /* if ([_address isHidden])
        {
            _city.center = [_address center];
        }
        else {
            _city.center = cityCenter;
        }*/
        [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [_city setHidden:NO];
        } completion:nil];
    }
    [_indicator stopAnimating];
    [_indicator setHidden:YES];
}
/* METODOS DEL PINGER */

- (void) simplePing: (SimplePing *)pinger didStartWithAddress:(NSData *)address
{
    [self showAlert:@"Pinger started" :@"Did Start With Address"];
}


- (void) simplePing: (SimplePing *)pinger didFailWithError:(NSError *)error
{
    [self showAlert:@"Pinger error" : [NSString stringWithFormat:@"Did Fail With Error: %ld", (long)[error code]]];
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

/*METODOS DE LOCALIZACION*/

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations objectAtIndex:0];
    //[self.lm stopUpdatingLocation];
    
    if (currentLatitude != currentLocation.coordinate.latitude || currentLongitude != currentLocation.coordinate.longitude)
    {
        currentLatitude = currentLocation.coordinate.latitude;
        currentLongitude = currentLocation.coordinate.longitude;
        
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
                     _address.text = [NSString stringWithFormat:@"%@", currentAddress];
                 }
                 if (placemark.locality)
                 {
                     currentCity = [NSString stringWithString:placemark.locality];
                     _city.text = [NSString stringWithFormat:@"%@", currentCity];
                 }
                 if (placemark.administrativeArea)
                 {
                     currentProvince = [NSString stringWithString:placemark.administrativeArea];
                 }
             }
         }];
    }
    
}

- (NSString *) getNewFileName{
    
    NSString *fileName = [NSString stringWithFormat:@"cc_1_%@_%.0f.txt",[identifier substringFromIndex:[identifier length]-5],initialTime];
    return fileName;
}

- (NSString *) getTextString: (VelocidadTest *) test
{
    int os = 0;
    UIDevice *device = [UIDevice currentDevice];
    NSString *osversion = [device systemVersion];
    NSString *model = [device model];
    identifier = [[device identifierForVendor] UUIDString];
    NSString *deviceName = [device name];
    //datetime = test.date_time; **************************************************************************
  
    
    NSString *textOut = [NSString stringWithFormat:@"%d;%@;Apple;%@;%@;%@!%@;%ld;%ld;%@;%ld;%ld;%ld;%f;%f;%f;%f;%@;%@;%@", os, osversion,  model, deviceName, identifier, test.date_time, (long)test.conexion, (long)test.network_type, test.proveedor, (long)test.mcc, (long)test.mnc, (long)test.ping, test.downloadSpeed, test.uploadSpeed, test.latitude, test.longitude, test.province, test.city, test.address];
    
    return textOut;
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
            //Speedtest no fue guardado
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"eventos"     // Event category (required)
                                                                  action:@"webservice"  // Event action (required)
                                                                   label:@"speedtest_no_recibido"          // Event label
                                                                   value:nil] build]];    // Event value
        }
        else if ([response isEqualToString:@"true"])
        {
            //Speedtest enviado
            //Cambiar status de speedtest a enviado
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"eventos"     // Event category (required)
                                                                  action:@"webservice"  // Event action (required)
                                                                   label:@"speedtest_recibido"          // Event label
                                                                   value:nil] build]];    // Event value
            
            NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
            NSNumber *loadTime = [NSNumber numberWithInt:((int)(currentTime-initialSendTime)*1000)];
            id tracker2 = [[GAI sharedInstance] defaultTracker];
            [tracker2 send:[[GAIDictionaryBuilder createTimingWithCategory:@"tiempo_carga"    // Timing category (required)
                                                                 interval:loadTime        // Timing interval (required)
                                                                     name:@"speedtest_envio"  // Timing name
                                                                    label:nil] build]];
        }
    }
}

- (NSString *) getURLString:(CGFloat)previousSpeed
{
    if (previousSpeed < 0.5)
    {
        currentTotalLength = 540233;
        //return @"http://190.57.148.84:8180/SpeedTestDownload/imagen_uno.jpg";
        return @"http://smovilecuador.supertel.gob.ec/SenalMovilEcuadorWeb/recursos/SpeedTestDownload/imagen_uno.jpg";
    }
    else if (previousSpeed < 1.0)
    {
        currentTotalLength = 1302245;
//        return @"http://190.57.148.84:8180/SpeedTestDownload/imagen_dos.jpg";
        return @"http://smovilecuador.supertel.gob.ec/SenalMovilEcuadorWeb/recursos/SpeedTestDownload/imagen_dos.jpg";
    }
    else if (previousSpeed < 3.0)
    {
        currentTotalLength = 3445176;
//        return @"http://190.57.148.84:8180/SpeedTestDownload/imagen_tres.jpg";
        return @"http://smovilecuador.supertel.gob.ec/SenalMovilEcuadorWeb/recursos/SpeedTestDownload/imagen_tres.jpg";
    }
    else if (previousSpeed < 5.0)
    {
        currentTotalLength = 6484116;
//        return @"http://190.57.148.84:8180/SpeedTestDownload/imagen_cuatro.jpg";
        return @"http://smovilecuador.supertel.gob.ec/SenalMovilEcuadorWeb/recursos/SpeedTestDownload/imagen_cuatro.jpg";
    }
    else
    {
        currentTotalLength = 13642143;
        return @"http://smovilecuador.supertel.gob.ec/SenalMovilEcuadorWeb/recursos/SpeedTestDownload/imagen_cinco.jpg";
//        return @"http://190.57.148.84:8180/SpeedTestDownload/imagen_cinco.jpg";
    }
    /*
    else if (previousSpeed < 10.0)
    {
        currentTotalLength = 13329409;
        return @"https://s3-us-west-2.amazonaws.com/integrabucket/download_speed_5.rar";
    }
    else
    {
        currentTotalLength = 19184843;
        return @"https://s3-us-west-2.amazonaws.com/integrabucket/download_speed_6.rar";
    }
     */
    //return @"";
}

- (NSData *) getUploadData:(CGFloat*)previousSpeed
{
    NSURL *imgPath;
    
    if (downloadSpeed < 1)
    {
        //se debe escoger un archivo dependiendo del tamaño
        imgPath = [[NSBundle mainBundle] URLForResource:@"upload_1" withExtension:@"jpg"];
        currentTotalLength = 540233;
    }
    else /*if (downloadSpeed < 3)*/
    {
        imgPath = [[NSBundle mainBundle] URLForResource:@"upload_2" withExtension:@"jpg"];
        currentTotalLength = 1302245;
    }
    /*else
    {
        imgPath = [[NSBundle mainBundle] URLForResource:@"upload_3" withExtension:@"jpg"];
        currentTotalLength = 3445176;
    }*/
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[imgPath absoluteString]]];
    return data;
}


@end