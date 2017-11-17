//
//  CoberturaMapController.m
//  CoberturaMovilIOS
//
//  Created by Supertel on 06/10/14.
//  Copyright (c) 2014 Superintendencia de Telecomunicaciones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoberturaMapController.h"
#import "Helper.h"
#import "SMETutorialController.h"
#import "SMEPasswordController.h"

@interface CoberturaMapController ()

@end

@implementation CoberturaMapController
{

}

NSString *const urlAddressIpad = @"http://smovilecuador.supertel.gob.ec/SenalMovilEcuadorWeb/mapas-movil.html";
NSString *const urlAddressIpad_local = @"http://smovilecuador.supertel.gob.ec/SenalMovilEcuadorWeb/mapas-movil.html";
NSString *const urlAddressComplete = @"http://smovilecuador.supertel.gob.ec/SenalMovilEcuadorWeb/mapas-movil.html";
NSString *const urlAddressComplete_local = @"http://smovilecuador.supertel.gob.ec/SenalMovilEcuadorWeb/mapas-movil.html";
NSTimeInterval initialTime;

BOOL isWebLoaded = NO;
bool isInternetAvailable;
int currentPage;
int currentUrlMode=1;

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    self.activityIndicator.hidden = YES;
    
    if (![@"1" isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"webLoaded"]])
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            currentPage = 2;
        }
        else
        {
            currentPage = 1;
        }
        [self getMapa:currentPage :currentUrlMode];
    }
    else
    {
        currentPage = [[NSString stringWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentPage"]] integerValue];
        currentUrlMode = [[NSString stringWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"modeView"]] integerValue];
        if (isWebLoaded==NO)
        {
            [self getMapa:currentPage :currentUrlMode];
        }
    }

    [_btn_change setEnabled:YES];
    self.screenName = @"Cobertura Mapa";
    initialTime = [[NSDate date] timeIntervalSince1970];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    /*if (![@"1" isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"passwordCorrect"]])
    {
        [self showPasswordScreen];
    } else */if (![@"1" isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"tutorialSeen"]])
    {
        [self showTutorial];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fromBackground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toBackground) name:UIApplicationWillResignActiveNotification object:nil];
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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlAddressComplete]];

}

- (void) showTutorial
{
    [self performSegueWithIdentifier:@"openTut" sender:self];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"eventos"     // Event category (required)
                                                          action:@"boton_presionado"  // Event action (required)
                                                           label:@"tutorial_mostrar"          // Event label
                                                           value:nil] build]];    // Event value
    
  //  SMETutorialController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialPageViewController"];
   // [self presentViewController:controller animated:NO completion:nil];
}

- (void) showPasswordScreen
{
    SMEPasswordController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SMEPasswordController"];
    [self presentViewController:controller animated:NO completion:nil];
}

- (void) fromBackground
{
   // bool currentInternet = [[Helper alloc] isInternetAvailable];
   // if ( currentInternet != isInternetAvailable)
    //{
        
        //isWebLoaded = NO;
     _btn_change.enabled = YES;
    [self getMapa:currentPage :currentUrlMode];
    //}
   
    NSLog(@"From Background");
}

- (void) toBackground
{
    //isWebLoaded = NO;
    isInternetAvailable = [[Helper alloc] isInternetAvailable];
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

- (void) getMapa: (int) modeView : (int) modeUrl
{
    if (!isWebLoaded && [[Helper alloc] isInternetAvailable])
    {

        NSURL *url;
        if (modeView==1)
        {
            if (modeUrl==1)
            {
                url = [NSURL URLWithString:urlAddressIpad];
            }
            else
            {
                url = [NSURL URLWithString:urlAddressIpad_local];
            }
            currentPage = 1;
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"currentPage"];
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"modeView"];
        }
        else
        {
            if (modeUrl==1)
            {
                url = [NSURL URLWithString:urlAddressComplete];
            }
            else
            {
                url = [NSURL URLWithString:urlAddressComplete_local];
            }
            currentPage = 2;
            [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"currentPage"];
            [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"modeView"];
        }
        
        [self loadPage: url];
        
        self.background.hidden = YES;
        self.webView.hidden = NO;
        isInternetAvailable = YES;
    }
    else if (![[Helper alloc] isInternetAvailable])
    {
        [self showAlert:@"Conexión a Internet" :@"Conéctese a una Red Móvil o Wi-Fi para visualizar los mapas"];
        self.background.hidden = NO;
        self.webView.hidden = YES;
        NSURL *url = [NSURL URLWithString:@"about:blank"];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        [_webView loadRequest:request];
        [self loadPage:url];
        isWebLoaded = NO;
        isInternetAvailable = NO;
    }

}

- (void) loadPage: (NSURL*) requestUrl
{
    NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
    _webView.delegate = self;
    [_webView loadRequest:request];
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
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",[NSString stringWithFormat:@"webView didFailWithError: error %ld", (long)error.code]);
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    isWebLoaded = NO;
    _btn_change.enabled = YES;
    if (error.code == -1004 && currentUrlMode==1)
    {
        currentUrlMode=2;
        [self getMapa:currentPage :currentUrlMode];
    }
    else if (currentUrlMode==2)
    {
        currentUrlMode=1;
        [self getMapa:currentPage :currentUrlMode];
    }
    else
    {
        [self showAlert: @"Error" : @"Ocurrió un error cargando los mapas. Por favor intente nuevamente más tarde."];
    }
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"webLoaded"];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    isWebLoaded = YES;
    _btn_change.enabled = YES;
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"webLoaded"];
    
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSNumber *loadTime = [NSNumber numberWithInt:((int)(currentTime-initialTime)*1000)];
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createTimingWithCategory:@"tiempo_carga"    // Timing category (required)
                                                         interval:loadTime        // Timing interval (required)
                                                             name:@"cobertura_mapa"  // Timing name
                                                            label:nil] build]];
}
@end
