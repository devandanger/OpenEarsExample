//
//  OEViewController.h
//  OpenEarsExample
//
//  Created by Evan Anger on 12/11/12.
//  Copyright (c) 2012 JPETech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenEars/LanguageModelGenerator.h>
#import <OpenEars/PocketsphinxController.h>
#import <OpenEars/OpenEarsEventsObserver.h>

@interface OEViewController : UIViewController<OpenEarsEventsObserverDelegate>
{
    OpenEarsEventsObserver *openEarsEventsObserver;
}
-(IBAction)initialRecognition:(id)sender;
@property (strong, nonatomic) LanguageModelGenerator *languageModelGenerator;
@property (weak, nonatomic) IBOutlet UITextView *recognitionResults;
@property (strong, nonatomic) NSString *lmPath;
@property (strong, nonatomic) NSString *dicPath;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) OpenEarsEventsObserver *openEarsEventsObserver;
@end
