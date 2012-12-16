//
// Created by sschmid on 16.12.12.
//
// contact@sschmid.com
//


#import "SingletonFoo.h"
#import "SingletonBar.h"
#import "SDInjector.h"


@implementation SingletonFoo
inject(@"bar")
@synthesize bar = _bar;

@end