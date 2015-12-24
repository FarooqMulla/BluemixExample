//
//  STTViewController.h
//  BluemixSample
//
//  Created by Farooq Mulla on 11/28/15.
//  Copyright © 2015 Farooq Mulla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeechToText.h"
#import "STTConfiguration.h"

@interface STTViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate>

@property SpeechToText *stt;
@property IBOutlet UILabel *result;
@property IBOutlet UIView *soundbar;
-(IBAction) pressStartRecord:(id) sender;


@end
