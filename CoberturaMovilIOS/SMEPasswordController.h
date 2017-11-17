//
//  SMEPasswordController.h
//  CoberturaMovilIOS
//
//  Created by Supertel on 30/10/14.
//  Copyright (c) 2014 Superintendencia de Telecomunicaciones. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMEPasswordController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UILabel *passwordIncorrect;
- (IBAction)checkPassword:(id)sender;
@end
