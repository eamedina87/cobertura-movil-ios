//
//  EventosMapController.c
//  CoberturaMovilIOS
//
//  Created by Supertel on 06/10/14.
//  Copyright (c) 2014 Superintendencia de Telecomunicaciones. All rights reserved.
//

#include "EventosMapController.h"
@interface EventosMapController ()

@end

@implementation EventosMapController

- (void) viewDidLoad {
    [super viewDidLoad];
    NSString *urlString = @"http://190.57.148.84:8180/CoberturaMovilEcuador/mMapasCobertura.jsp";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    _webView = nil;

}

- (void) didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
