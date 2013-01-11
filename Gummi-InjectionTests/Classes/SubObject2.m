//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "SubObject2.h"
#import "Sub2Dependency.h"
#import "GIInjector.h"


@implementation SubObject2
inject(@"sub2Dependency")
@synthesize sub2Dependency = _sub2Dependency;
@end