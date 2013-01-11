//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "SubObject1.h"
#import "Sub1Dependency.h"
#import "GIInjector.h"


@implementation SubObject1
inject(@"sub1Dependency")
@synthesize sub1Dependency = _sub1Dependency;
@end