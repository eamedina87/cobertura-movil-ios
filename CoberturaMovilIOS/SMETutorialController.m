//
//  SMETutorialController.m
//  CoberturaMovilIOS
//
//  Created by Supertel on 27/10/14.
//  Copyright (c) 2014 Superintendencia de Telecomunicaciones. All rights reserved.
//

#import "SMETutorialController.h"
#import "SMETutorial1.h"
#import "SMETutorial2.h"
#import "SMETutorial3.h"

@interface SMETutorialController ()

@end

@implementation SMETutorialController

CGFloat y;
CGFloat dy;
int currentPage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    y = 65;
    dy = 65;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        y = 85;
        dy = 100;
    }
    NSString *pageViewID = @"VelocidadPageViewController";
    NSString *initialViewID = @"TutorialScreen1";
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:pageViewID];
    self.pageViewController.dataSource = self;
//    self.pageViewController.delegate = self;
    
    UIViewController *initial = [self.storyboard instantiateViewControllerWithIdentifier:initialViewID];
    currentPage = 0;
    NSArray *viewControllers = @[initial];
    self.currentController = initial;
    [self.pageViewController setViewControllers:viewControllers direction: UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    self.pageViewController.view.frame = CGRectMake(0, 45, self.view.frame.size.width, self.view.frame.size.height - 100);
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    self.pageViewController.view.frame = CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height-dy);
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    if (![@"1" isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"tutorialSeen"]])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"tutorialSeen"];
        [self.btn_salir setTitle:@"Saltar"];
    }
}

#pragma mark

-(UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    /*if (currentPage == 1)
    {
        
        UIViewController *c = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialScreen1"];
        self.currentController = c;
        currentPage = 0;
        return self.currentController;
    }
    else */ if (currentPage == 2)
    {
        UIViewController *c = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialScreen1"];
        self.currentController = c;
        currentPage = 1;
        return self.currentController;
    }
    else if (currentPage == 3)
    {
        UIViewController *c = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialScreen2"];
        self.currentController = c;
        currentPage = 2;
        return self.currentController;
    }
    return nil;
}

- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    if (currentPage == 0)
    {
        UIViewController *c = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialScreen2"];
        self.currentController = c;
        currentPage = 1;
        return self.currentController;
    }
    else if (currentPage == 1)
    {
        UIViewController *c = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialScreen3"];
        if ([[self.btn_salir title] isEqualToString:@"Saltar"])
        {
            [self.btn_salir setTitle:@"Cerrar"];
        }
        self.currentController = c;
        currentPage = 2;
        return self.currentController;
    }
    else if (currentPage == 2)
    {
        UIViewController *c = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialScreen4"];
        self.currentController = c;
        currentPage = 3;
        return self.currentController;
    }
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    if ([pendingViewControllers count] > 0)
    {
        NSLog(@"Count > 0");
    }
    NSLog(@"Transition");
}

- (NSInteger) presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 4;
}

- (NSInteger) presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}


- (IBAction)closeView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
