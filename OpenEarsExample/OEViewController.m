//
//  OEViewController.m
//  OpenEarsExample
//
//  Created by Evan Anger on 12/11/12.
//  Copyright (c) 2012 JPETech LLC. All rights reserved.
//

#import "OEViewController.h"

@interface OEViewController ()
{
    PocketsphinxController *pocketsphinxController;
}
@property (strong, nonatomic) PocketsphinxController *pocketsphinxController;
@end

@implementation OEViewController
@synthesize languageModelGenerator;
@synthesize pocketsphinxController;
@synthesize lmPath;
@synthesize dicPath;
@synthesize openEarsEventsObserver;
@synthesize recognitionResults;
@synthesize status;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    languageModelGenerator = [[LanguageModelGenerator alloc] init];
    
    NSArray *words = @[@"INSURANCE",@"DEDUCTIBLE", @"300", @"CSL", @"VIOLATION"];
    NSString *name = @"NavigationTerms";
    NSError *err = [languageModelGenerator generateLanguageModelFromArray:words  withFilesNamed:name];

    
    if([err code] != noErr)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error initializing language model generator"
                                                            message:@"Unable to learn recognition"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
        [alertView show];
    }
    else
    {
        NSDictionary *languageGeneratorResult = [err userInfo];
        lmPath = [languageGeneratorResult objectForKey:@"LMPath"];
        dicPath = [languageGeneratorResult objectForKey:@"DictionaryPath"];
    }
    [self.openEarsEventsObserver setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PocketsphinxController *)pocketsphinxController {
	if (pocketsphinxController == nil) {
		pocketsphinxController = [[PocketsphinxController alloc] init];
	}
	return pocketsphinxController;
}

- (OpenEarsEventsObserver *)openEarsEventsObserver {
	if (openEarsEventsObserver == nil) {
		openEarsEventsObserver = [[OpenEarsEventsObserver alloc] init];
	}
	return openEarsEventsObserver;
}


-(IBAction)initialRecognition:(id)sender
{
    [self.pocketsphinxController startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath languageModelIsJSGF:NO];
}

#pragma mark PocketSphinxController

- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID
{
    [recognitionResults setText:[NSString stringWithFormat:@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID]];
}

- (void) pocketsphinxDidStartCalibration
{
	[status setText:@"Pocketsphinx calibration has started."];
}

- (void) pocketsphinxDidCompleteCalibration
{
	[status setText:@"Pocketsphinx calibration is complete."];
}

- (void) pocketsphinxDidStartListening
{
	[status setText:@"Pocketsphinx is now listening."];
}

- (void) pocketsphinxDidDetectSpeech
{
	[status setText:@"Pocketsphinx has detected speech."];
}

- (void) pocketsphinxDidDetectFinishedSpeech
{
	[status setText:@"Pocketsphinx has detected a period of silence, concluding an utterance."];
}

- (void) pocketsphinxDidStopListening
{
	[status setText:@"Pocketsphinx has stopped listening."];
}

- (void) pocketsphinxDidSuspendRecognition
{
	[status setText:@"Pocketsphinx has suspended recognition."];
}

- (void) pocketsphinxDidResumeRecognition {
	[status setText:@"Pocketsphinx has resumed recognition."];
}

- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString {
	NSLog(@"Pocketsphinx is now using the following language model: \n%@ and the following dictionary: %@",newLanguageModelPathAsString,newDictionaryPathAsString);
}

- (void) pocketSphinxContinuousSetupDidFail { // This can let you know that something went wrong with the recognition loop startup. Turn on OPENEARSLOGGING to learn why.
	NSLog(@"Setting up the continuous recognition loop has failed for some reason, please turn on OpenEarsLogging to learn more.");
}
@end
