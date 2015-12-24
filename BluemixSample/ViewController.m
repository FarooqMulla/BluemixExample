//
//  ViewController.m
//  BluemixSample
//
//  Created by Farooq Mulla on 11/27/15.
//  Copyright © 2015 Farooq Mulla. All rights reserved.
//

#import "ViewController.h"
#import <IMFCore/IMFCore.h>
#import <IMFFacebookAuthentication/IMFFacebookAuthenticationHandler.h>
//#import <IMFGoogleAuthentication/IMFGoogleAuthenticationHandler.h>
#import "AFHTTPRequestOperationManager.h"

@interface AuthenticationDelegate : NSObject <IMFFacebookAuthenticationDelegate>

@end

@implementation AuthenticationDelegate

- (void)authenticationHandler:(IMFFacebookAuthenticationHandler*)authenticationHandler didReceiveAuthenticationRequestForAppId:(NSString*)appId
{
    NSLog(@"Facebook details....");
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_pushButton setEnabled:NO];
    // Do any additional setup after loading the view, typically from a nib.
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getLocation:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)TestGetConnection:(id)sender
{
    IMFClient *imfClient = [IMFClient sharedInstance];
    NSString *protectedURL = [NSString stringWithFormat:@"%@/api/hello",imfClient.backendRoute];
    IMFResourceRequest* request = [IMFResourceRequest requestWithPath:protectedURL];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
    [request sendWithCompletionHandler:^(IMFResponse *response, NSError *error) {
        if (error != nil) {
        } else {
            NSLog(@"You have connected to Bluemix successfully %@", response);
            
        }
    }];
}

- (IBAction)TestPostConnection:(id)sender
{
    IMFClient *imfClient = [IMFClient sharedInstance];
    NSString *protectedURL = [NSString stringWithFormat:@"%@/api/hello/getCustom",imfClient.backendRoute];
    IMFResourceRequest* request = [IMFResourceRequest requestWithPath:protectedURL];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request sendWithCompletionHandler:^(IMFResponse *response, NSError *error) {
        if (error != nil) {
        } else {
            NSLog(@"You have connected to Bluemix successfully %@", response);
            
        }
    }];
}


- (IBAction)getLocation:(id)sender
{
    NSURL *URL = [NSURL URLWithString:@"https://pitneybowes.pbondemand.com/location/address/lookup.json?latitude=41.415863&longitude=-73.419368&searchDistance=100&appId=47debc91-61d9-4ffb-afa8-e1ce42bbd3c0&appSecret=g0N7E8KZryzkY2Hb87FW"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successful Location JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [[op securityPolicy] setAllowInvalidCertificates:YES];
    [[op securityPolicy] setValidatesDomainName:NO];
    [[NSOperationQueue mainQueue] addOperation:op];
}

-(IBAction)AuthButtonClicked:(id)sender
{
    [[IMFFacebookAuthenticationHandler sharedInstance] registerWithDefaultDelegate];
//    [[IMFFacebookAuthenticationHandler sharedInstance] registerWithDelegate:[[AuthenticationDelegate alloc] init]];
    
//    [[IMFGoogleAuthenticationHandler sharedInstance] registerWithDefaultDelegate];

    [_pushButton setEnabled:YES];
}


-(IBAction)PushNotificationButtonClicked:(id)sender
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];

    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
}
@end
