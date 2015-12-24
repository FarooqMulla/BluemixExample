//
//  ViewController.h
//  BluemixSample
//
//  Created by Farooq Mulla on 11/27/15.
//  Copyright © 2015 Farooq Mulla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *authButton;
@property (strong, nonatomic) IBOutlet UIButton *pushButton;

-(IBAction)TestGetConnection:(id)sender;
-(IBAction)TestPostConnection:(id)sender;
-(IBAction)AuthButtonClicked:(id)sender;
-(IBAction)PushNotificationButtonClicked:(id)sender;

@end

