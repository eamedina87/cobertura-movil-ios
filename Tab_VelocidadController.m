//
//  Tab_VelocidadController.m
//  CoberturaMovilIOS
//
//  Created by Supertel on 06/10/14.
//  Copyright (c) 2014 Superintendencia de Telecomunicaciones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tab_VelocidadController.h"


@interface Tab_VelocidadController ()

@end

@implementation Tab_VelocidadController

{
    CGFloat y;
    CGFloat dy;
    int currentPage;
}

CGImageRef UIGetScreenImage(void);

- (void) viewDidLoad
{
    [super viewDidLoad];
    [_btn_share setHidden:YES];
    y = 65;
    dy = 50;
    
    NSString *pageViewID = @"VelocidadPageViewController";
    NSString *initialViewID = @"VelocidadTestController";
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        y = 85;
        initialViewID = @"VelocidadTestControllerPad";
    }
    
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        //pageViewID = @"VelocidadPageViewControllerLandscape";
        initialViewID = @"VelocidadTestControllerLandscape";
        y = 85;
        dy = 0;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            self.toolbar.hidden = YES;
            y=0;
        }
    }
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:pageViewID];
    self.pageViewController.dataSource = self;
    
    UIViewController *initial = [self.storyboard instantiateViewControllerWithIdentifier:initialViewID];
//    [self setButtonTitle:@"Historial"];
    //[_btn_changeView setHidden:YES];
    currentPage = 0;
    NSArray *viewControllers = @[initial];
    self.currentController = initial;
    [self.pageViewController setViewControllers:viewControllers direction: UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    

    self.pageViewController.view.frame = CGRectMake(0, 45, self.view.frame.size.width, self.view.frame.size.height - 100);
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    /*
    let views = self.pageViewController.view.subviews
    var pageControl : UIPageControl! = nil
    for control in views
    {
        if control.isKindOfClass(UIPageControl) {
            pageControl = control as UIPageControl
        }
    }
    
    if (pageControl != nil)
    {
        pageControl.hidden = true
    }*/
    
    self.pageViewController.view.frame = CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height - dy);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void) changeView:(id)sender
{
    
//    if ([self.currentController isKindOfClass:[VelocidadHistorialController class]] || currentPage == 1)
    if ([self.currentController isKindOfClass:[VelocidadHistorialController class]] && currentPage == 1)
    {
        NSString *identifier = @"VelocidadTestController";
        /*UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            identifier = @"VelocidadTestControllerLandscape";
        }*/
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            identifier = @"VelocidadTestControllerPad";
        }
        UIViewController *initial = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        currentPage = 0;
        [self setButtonTitle:@"Historial"];
        self.currentController = initial;
        NSArray *viewControllers = @[initial];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        
    }
    else if ([self.currentController isKindOfClass:[VelocidadTestController class]] && currentPage == 0)
    {
        UIViewController *initial = [self.storyboard instantiateViewControllerWithIdentifier:@"VelocidadHistorialController"];
        [self setButtonTitle:@"Medidor"];
        currentPage = 1;
        self.currentController = initial;
        NSArray *viewControllers = @[initial];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
}

- (void) share:(id)sender
{/*
   CGImageRef screen = UIGetScreenImage();
    UIImage *image = [UIImage imageWithCGImage:screen];
    CGImageRelease(screen);
    
    UIImageWriteToSavedPhotosAlbum(image, self, <#SEL completionSelector#>, nil);*/
}

- (void) orientationChanged:(id)object
{
    //[self changeOrientation];
}

- (void) changeOrientation {
/*
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
     
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            self.toolbar.hidden = YES;
            y = 0;
            dy = 0;
            self.pageViewController.view.frame = CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height - dy);
        }
        
        if ([self.currentController isKindOfClass:[VelocidadHistorialController class]])
         {
         UIViewController *initial = [self.storyboard instantiateViewControllerWithIdentifier:@"VelocidadHistorialController"];
         self.currentController = initial;
         NSArray *viewControllers = @[initial];
         [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
         
         }
         else if ([self.currentController isKindOfClass:[VelocidadTestController class]])
         {
             UIViewController *initial = [self.storyboard instantiateViewControllerWithIdentifier:@"VelocidadTestControllerLandscape"];
             self.currentController = initial;
             NSArray *viewControllers = @[initial];
             [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
         }
        
    }
    else if (UIInterfaceOrientationIsPortrait(orientation))
    {
        self.toolbar.hidden = NO;
        y = 65;
        dy = 50;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            y = 85;
        }
        self.pageViewController.view.frame = CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height - dy);
        if ([self.currentController isKindOfClass:[VelocidadHistorialController class]])
         {
         UIViewController *initial = [self.storyboard instantiateViewControllerWithIdentifier:@"VelocidadHistorialController"];
         self.currentController = initial;
         NSArray *viewControllers = @[initial];
         [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
         
         }
         else if ([self.currentController isKindOfClass:[VelocidadTestController class]])
         {
             UIViewController *initial = [self.storyboard instantiateViewControllerWithIdentifier:@"VelocidadTestController"];
             self.currentController = initial;
             NSArray *viewControllers = @[initial];
             [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
         }
    }*/
}

#pragma mark

-(UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    //if ([viewController isKindOfClass:[VelocidadHistorialController class]] || (currentPage == 1)){
/*    if ([viewController isKindOfClass:[VelocidadHistorialController class]] && currentPage == 1)
    {
        NSString *controller = @"VelocidadTestController";
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            controller = @"VelocidadTestControllerPad";
        }
        self.currentController = [self.storyboard instantiateViewControllerWithIdentifier:controller];
        [self setButtonTitle:@"Historial"];
        currentPage = 0;
        return self.currentController;
    }*/
    return nil;
}

- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
//    if ([viewController isKindOfClass:[VelocidadTestController class]] && (currentPage == 0))
    /*if (currentPage==0)
    {
        self.currentController = [self.storyboard instantiateViewControllerWithIdentifier:@"VelocidadHistorialController"];
        [self setButtonTitle:@"Medidor"];
        currentPage = 1;
        return self.currentController;
    }*/
    return nil;
}

- (void) setButtonTitle: (NSString* ) btnTitle
{
    [self.btn_changeView setTitle:btnTitle forState:UIControlStateNormal];
    self.btn_changeView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.btn_changeView.contentVerticalAlignment =UIControlContentVerticalAlignmentFill;
}

@end