//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "BaseObject.h"
#import "BaseDependency.h"
#import "GIInjector.h"


@implementation BaseObject
inject(@"baseDependency")
@synthesize baseDependency = _baseDependency;
@end