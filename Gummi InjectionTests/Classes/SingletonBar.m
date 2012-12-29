//
// Created by sschmid on 16.12.12.
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