//
//  SMEPasswordController.m
//  CoberturaMovilIOS
//
//  Created by Supertel on 30/10/14.
//  Copyright (c) 2014 Superintendencia de Telecomunicaciones. All rights reserved.
//

#import "SMEPasswordController.h"

@implementation SMEPasswordController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.passwordIncorrect setHidden:YES];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)checkPassword:(id)sender
{
    if ([self.password.text isEqualToString:@"supertel2014"])
    {
        if (![@"1" isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"passwordCorrect"]])
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"passwordCorrect"];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.passwordIncorrect setHidden:NO];
    }
    
}

@end
