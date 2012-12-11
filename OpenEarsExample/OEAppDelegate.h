//
//  OEAppDelegate.h
//  OpenEarsExample
//
//  Created by Evan Anger on 12/11/12.
//  Copyright (c) 2012 JPETech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OEViewController;

@interface OEAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) OEViewController *viewController;

@end
