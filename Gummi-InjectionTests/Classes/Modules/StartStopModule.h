//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import "GIModule.h"

@class StartStopObject;

@interface StartStopModule : GIModule
@property(nonatomic, strong) StartStopObject *startStopObject;
@end