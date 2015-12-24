//
//  STTViewController.m
//  BluemixSample
//
//  Created by Farooq Mulla on 11/28/15.
//  Copyright © 2015 Farooq Mulla. All rights reserved.
//

#import "STTViewController.h"
#import "BlueMixApplicationValues.h"
#import "SCSiriWaveformView.h"


@interface STTViewController () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *modelSelectorButton;
@property (strong, nonatomic) UIPickerView *pickerView;
@property NSArray *STTLanguageModels;

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, weak) IBOutlet SCSiriWaveformView *waveformView;

@end

@implementation STTViewController

@synthesize stt;
@synthesize result;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *settings = @{AVSampleRateKey:          [NSNumber numberWithFloat: 44100.0],
                               AVFormatIDKey:            [NSNumber numberWithInt: kAudioFormatAppleLossless],
                               AVNumberOfChannelsKey:    [NSNumber numberWithInt: 2],
                               AVEncoderAudioQualityKey: [NSNumber numberWithInt: AVAudioQualityMin]};
    
    NSError *error;
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];

    if(error) {
        NSLog(@"Ups, could not create recorder %@", error);
        return;
    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:&error];

    CADisplayLink *displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeters)];
    [displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];

    // STT setup
    STTConfiguration *conf = [[STTConfiguration alloc] init];
    
    // Use opus compression, better for mobile devices.
    [conf setAudioCodec:WATSONSDK_AUDIO_CODEC_TYPE_OPUS];
    [conf setApiURL:[[BlueMixApplicationValues sharedInstance] STTURL]];
    [conf setBasicAuthUsername:[[BlueMixApplicationValues sharedInstance] STTUserName]];
    [conf setBasicAuthPassword:[[BlueMixApplicationValues sharedInstance] STTPassword]];
    
    //    [conf setTokenGenerator:^(void (^tokenHandler)(NSString *token)){
    //        NSURL *url = [[NSURL alloc] initWithString:@"https://my-token-factory/token"];
    //        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //        [request setHTTPMethod:@"GET"];
    //        [request setURL:url];
    //
    //        NSError *error = [[NSError alloc] init];
    //        NSHTTPURLResponse *responseCode = nil;
    //        NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    //        if ([responseCode statusCode] != 200) {
    //            NSLog(@"Error getting %@, HTTP status code %li", url, (long)[responseCode statusCode]);
    //            return;
    //        }
    //        tokenHandler([[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding]);
    //    } ];
    
    self.stt = [SpeechToText initWithConfig:conf];
    
    
    // list models call to populate picker
    [stt listModels:^(NSDictionary* res, NSError* err){
        
        if(err == nil)
            [self modelHandler:res];
        else
            result.text = [err localizedDescription];
        NSLog(@"Error: %@",[err localizedDescription]);
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressSelectModel:(id)sender {
    
    [self.pickerView setHidden:NO];
    [self.pickerView setOpaque:YES];
}


-(IBAction) pressStartRecord:(id) sender
{
    [self.recorder prepareToRecord];
    [self.recorder setMeteringEnabled:YES];
    [self.recorder record];

    // start recognize
    [stt recognize:^(NSDictionary* res, NSError* err){
        
        if(err == nil) {
            
            
            if([self.stt isFinalTranscript:res]) {
                
                NSLog(@"this is the final transcript");
                [stt endRecognize];
                
                NSLog(@"confidence score is %@",[stt getConfidenceScore:res]);
            }
            
            result.text = [stt getTranscript:res];
            
            
        } else {
            NSLog(@"received error from the SDK %@",[err localizedDescription]);
            [stt endRecognize];
        }
    }];
    
    // get power readings until recording has finished
    [stt getPowerLevel:^(float power){
        
        CGRect frm = self.soundbar.frame;
        frm.size.width = 3*(70 + power);
        self.soundbar.frame = frm;
        self.soundbar.center = CGPointMake(self.view.frame.size.width / 2, self.soundbar.center.y);
    }];
    
    
    
}

- (void) modelHandler:(NSDictionary *) dict {
    
    self.STTLanguageModels = [dict objectForKey:@"models"];
    
    // create the picker view now we have the data.
    [self.pickerView setBackgroundColor:[UIColor lightGrayColor]];
    [self.pickerView setOpaque:YES];
    [self.pickerView setHidden:YES];
    
    // add a tap gesture recognizer so we can detect a tap on the already selected uipickerview item
    UITapGestureRecognizer* gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
    [self.pickerView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.delegate = self;
    
    
    [self.view addSubview:self.pickerView];
    // select the us broadband model by default
    [self.pickerView selectRow:self.STTLanguageModels.count-1 inComponent:0 animated:YES];
}



#pragma mark language model selection

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    // return
    return true;
}

-(void)pickerViewTapGestureRecognized:(UIGestureRecognizer *)sender {
    
    if(self.STTLanguageModels != nil)
    {
        NSDictionary *model = [self.STTLanguageModels objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        
        NSString *modelName = [model objectForKey:@"name"];
        NSString *modelDesc = [model objectForKey:@"description"];
        
        self.modelSelectorButton.titleLabel.text = [NSString stringWithFormat:@"    %@",modelDesc];
        [[self.stt config] setModelName:modelName];
        [self.pickerView setHidden:YES];
    }
    
}

- (UIPickerView *)pickerView
{
    if (!_pickerView)
    {
        int pickerHeight = 250;
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-pickerHeight+33, [UIScreen mainScreen].bounds.size.width, pickerHeight)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    
    return _pickerView;
}

#pragma mark - UIPickerViewDataSource Methods

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if(self.STTLanguageModels != nil)
    {
        return [self.STTLanguageModels count];
    }
    
    return 0;
}

#pragma mark - UIPickerViewDelegate Methods

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 200;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        tView.numberOfLines=1;
    }
    // Fill the label text here
    NSDictionary *model = [self.STTLanguageModels objectAtIndex:row];
    tView.text=[model objectForKey:@"description"];
    return tView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if(self.STTLanguageModels != nil)
    {
        NSDictionary *model = [self.STTLanguageModels objectAtIndex:row];
        
        NSString *modelName = [model objectForKey:@"name"];
        NSString *modelDesc = [model objectForKey:@"description"];
        
        
        self.modelSelectorButton.titleLabel.text = [NSString stringWithFormat:@"    %@",modelDesc];
        
        [[self.stt config] setModelName:modelName];
        [self.pickerView setHidden:YES];
    }
    
}



//For Wave
- (void)updateMeters
{
    CGFloat normalizedValue;
    [self.recorder updateMeters];
    normalizedValue = [self _normalizedPowerLevelFromDecibels:[self.recorder averagePowerForChannel:0]];
    [self.waveformView updateWithLevel:normalizedValue];
}

#pragma mark - Private

- (CGFloat)_normalizedPowerLevelFromDecibels:(CGFloat)decibels
{
    if (decibels < -60.0f || decibels == 0.0f) {
        return 0.0f;
    }
    
    return powf((powf(10.0f, 0.05f * decibels) - powf(10.0f, 0.05f * -60.0f)) * (1.0f / (1.0f - powf(10.0f, 0.05f * -60.0f))), 1.0f / 2.0f);
}

@end