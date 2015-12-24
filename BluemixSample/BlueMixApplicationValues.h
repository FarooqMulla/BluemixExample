//
//  BlueMixApplicationValues.h
//  BluemixSample
//
//  Created by Farooq Mulla on 11/28/15.
//  Copyright © 2015 Farooq Mulla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlueMixApplicationValues : NSObject


@property (nonatomic, strong, readonly) NSString *applicationRoute;
@property (nonatomic, strong, readonly) NSString *applicationGUID;

@property (nonatomic, assign, readonly) NSString *STTURL;
@property (nonatomic, assign, readonly) NSString *STTUserName;
@property (nonatomic, assign, readonly) NSString *STTPassword;

@property (nonatomic, assign, readonly) NSString *TTSURL;
@property (nonatomic, assign, readonly) NSString *TTSUserName;
@property (nonatomic, assign, readonly) NSString *TTSPassword;


+(BlueMixApplicationValues *)sharedInstance;

@end
