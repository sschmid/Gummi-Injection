//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "SingletonBar.h"
#import "SingletonFoo.h"
#import "GIInjector.h"


@implementation SingletonBar
inject(@"foo")
@synthesize foo = _foo;

@end