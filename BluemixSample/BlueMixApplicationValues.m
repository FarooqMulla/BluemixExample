//
//  BlueMixApplicationValues.m
//  BluemixSample
//
//  Created by Farooq Mulla on 11/28/15.
//  Copyright © 2015 Farooq Mulla. All rights reserved.
//

#import "BlueMixApplicationValues.h"


NSString *const BLUEMIX_APPLICATION_ROUTE = @"applicationRoute";
NSString *const BLUEMIX_APPLICATION_GUID = @"applicationGUID";

NSString *const BLUEMIX_APPLICATION_STTVALUES = @"STTValues";
NSString *const BLUEMIX_APPLICATION_TTSVALUES = @"TTSValues";

NSString *const BLUEMIX_APPLICATION_URL = @"url";
NSString *const BLUEMIX_APPLICATION_USERNAME = @"userName";
NSString *const BLUEMIX_APPLICATION_PASSWORD = @"password";

@interface BlueMixApplicationValues ()

@property (nonatomic, strong) NSString *applicationRoute;
@property (nonatomic, strong) NSString *applicationGUID;
@property (nonatomic, strong) NSDictionary *STTValues;
@property (nonatomic, strong) NSDictionary *TTSValues;

@end

@implementation BlueMixApplicationValues

static BlueMixApplicationValues *_sharedInstance;


+(BlueMixApplicationValues *)sharedInstance
{
    if(!_sharedInstance)
    {
        _sharedInstance = [[self alloc] init];
    }
    
    return _sharedInstance;
}

- (instancetype)init
{
    if(self = [super init])
    {
        NSDictionary *mainDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bluemixAppValues" ofType:@"plist"]];
        NSDictionary *values = nil;
#ifdef NODEJS
        values = [mainDictionary objectForKey:@"NodeJS"];
#else
        values = [mainDictionary objectForKey:@"JAVA"];
#endif
      
        [self setApplicationRoute:[values objectForKey:BLUEMIX_APPLICATION_ROUTE]];
        [self setApplicationGUID:[values objectForKey:BLUEMIX_APPLICATION_GUID]];
        [self setSTTValues:[values objectForKey:BLUEMIX_APPLICATION_STTVALUES]];
        [self setTTSValues:[values objectForKey:BLUEMIX_APPLICATION_TTSVALUES]];
    }
    return self;
}


- (NSString *)STTURL
{
    return [[self STTValues] objectForKey:BLUEMIX_APPLICATION_URL];
}

- (NSString *)STTUserName
{
    return [[self STTValues] objectForKey:BLUEMIX_APPLICATION_USERNAME];
}

- (NSString *)STTPassword
{
    return [[self STTValues] objectForKey:BLUEMIX_APPLICATION_PASSWORD];
}

-(NSString *)TTSURL
{
    return [[self TTSValues] objectForKey:BLUEMIX_APPLICATION_URL];
}

- (NSString *)TTSUserName
{
    return [[self TTSValues] objectForKey:BLUEMIX_APPLICATION_USERNAME];
}

-(NSString *)TTSPassword
{
    return [[self TTSValues] objectForKey:BLUEMIX_APPLICATION_PASSWORD];
}

@end
