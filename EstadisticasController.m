//
//  CoberturaMapController.m
//  CoberturaMovilIOS
//
//  Created by Supertel on 06/10/14.
//  Copyright (c) 2014 Superintendencia de Telecomunicaciones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EstadisticasController.h"
#import "Helper.h"
#import "SMETutorialController.h"
#import "SMEPasswordController.h"

@interface EstadisticasController ()

@end

@implementation EstadisticasController
{
    
}

NSString *const e_urlAddressIpad = @"http://smovilecuador.supertel.gob.ec/SenalMovilEcuadorWeb/estadisticas.html?m=1";
NSString *const e_urlAddressIpad_local = @"http://smovilecuador.supertel.gob.ec/SenalMovilEcuadorWeb/estadisticas.html?m=1";
NSString *const e_urlAddressComplete = @"http://smovilecuador.supertel.gob.ec/SenalMovilEcuadorWeb/estadisticas.html?m=1";
NSString *const e_urlAddressComplete_local = @"http://smovilecuador.supertel.gob.ec/SenalMovilEcuadorWeb/estadisticas.html?m=1";

NSTimeInterval initialTime;
BOOL e_isWebLoaded = NO;
bool e_isInternetAvailable;
int e_currentPage;
int e_currentUrlMode=1;

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    self.e_activityIndicator.hidden = YES;
    
    if (![@"1" isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"webLoaded"]])
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            e_currentPage = 2;
        }
        else
        {
            e_currentPage = 1;
        }
        [self getEstadisticas:e_currentPage :e_currentUrlMode];
    }
    else
    {
        e_currentPage = [[NSString stringWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentPage"]] integerValue];
        e_currentUrlMode = [[NSString stringWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"modeView"]] integerValue];
        if (e_isWebLoaded==NO)
        {
            [self getEstadisticas:e_currentPage :e_currentUrlMode];
        }
    }
    
    [_e_btn_change setEnabled:YES];
    self.screenName = @"Estadisticas";
    initialTime = [[NSDate date] timeIntervalSince1970];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fromBackground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toBackground) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{

}

-(IBAction)changeView:(id)sender
{
    /*
     if (currentPage==1)
     {
     isWebLoaded = NO;
     [self checkConnectivity:2 :currentUrlMode];
     }
     else if (currentPage==2)
     {
     isWebLoaded = NO;
     [self checkConnectivity:1 :currentUrlMode];
     }
     */
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:e_urlAddressComplete]];
    
}


- (void) fromBackground
{
    // bool currentInternet = [[Helper alloc] isInternetAvailable];
    // if ( currentInternet != isInternetAvailable)
    //{
    
    //isWebLoaded = NO;
    _e_btn_change.enabled = YES;
    [self getEstadisticas:e_currentPage :e_currentUrlMode];
    //}
    
    NSLog(@"From Background");
}

- (void) toBackground
{
    //isWebLoaded = NO;
    e_isInternetAvailable = [[Helper alloc] isInternetAvailable];
    [[NSUserDefaults standardUserDefaults] setValue:@"-1" forKey:@"webLoaded"];
}

- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    //_webView = nil;
    //   isWebLoaded = NO;
    //[[NSUserDefaults standardUserDefaults] setValue:@"-1" forKey:@"webLoaded"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/* METODOS DE LA ALERTA */

- (void) getEstadisticas: (int) modeView : (int) modeUrl
{
    if (!e_isWebLoaded && [[Helper alloc] isInternetAvailable])
    {
        
        NSURL *url;
        if (modeView==1)
        {
            if (modeUrl==1)
            {
                url = [NSURL URLWithString:e_urlAddressIpad];
            }
            else
            {
                url = [NSURL URLWithString:e_urlAddressIpad_local];
            }
            e_currentPage = 1;
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"currentPage"];
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"modeView"];
        }
        else
        {
            if (modeUrl==1)
            {
                url = [NSURL URLWithString:e_urlAddressComplete];
            }
            else
            {
                url = [NSURL URLWithString:e_urlAddressComplete_local];
            }
            e_currentPage = 2;
            [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"currentPage"];
            [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"modeView"];
        }
        
        [self loadPage:url];
        //_btn_change.enabled = NO;
        //        }
        self.e_background.hidden = YES;
        self.e_webView.hidden = NO;
        e_isInternetAvailable = YES;
    }
    else if (![[Helper alloc] isInternetAvailable])
    {
        [self showAlert:@"Conexión a Internet" :@"Conéctese a una Red Móvil o Wi-Fi para visualizar los mapas"];
        self.e_background.hidden = NO;
        self.e_webView.hidden = YES;
        NSURL *url = [NSURL URLWithString:@"about:blank"];
        [self loadPage:url];
        e_isWebLoaded = NO;
        e_isInternetAvailable = NO;
    }
}

- (void) loadPage: (NSURL*) requestUrl
{
    NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
    _e_webView.delegate = self;
    [_e_webView loadRequest:request];
}

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

/* METODOS DEL WEB VIEW */

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    //    _btn_change.enabled = NO;
    self.e_activityIndicator.hidden = NO;
    [self.e_activityIndicator startAnimating];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",[NSString stringWithFormat:@"webView didFailWithError: error %ld", (long)error.code]);
    [self.e_activityIndicator stopAnimating];
    self.e_activityIndicator.hidden = YES;
    e_isWebLoaded = NO;
    _e_btn_change.enabled = YES;
    if (error.code == -1004 && e_currentUrlMode==1)
    {
        e_currentUrlMode=2;
        [self getEstadisticas:e_currentPage :e_currentUrlMode];
    }
    else if (e_currentUrlMode==2)
    {
        e_currentUrlMode=1;
        [self getEstadisticas:e_currentPage :e_currentUrlMode];
    }
    else
    {
        [self showAlert: @"Error" : @"Ocurrió un error cargando los mapas. Por favor intente nuevamente más tarde."];
    }
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"webLoaded"];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [self.e_activityIndicator stopAnimating];
    self.e_activityIndicator.hidden = YES;
    e_isWebLoaded = YES;
    _e_btn_change.enabled = YES;
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"webLoaded"];
    
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSNumber *loadTime = [NSNumber numberWithInt:((int)(currentTime-initialTime)*1000)];
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createTimingWithCategory:@"tiempo_carga"    // Timing category (required)
                                                         interval:loadTime        // Timing interval (required)
                                                             name:@"estadisticas"  // Timing name
                                                            label:nil] build]];
}
@end
