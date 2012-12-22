//
// Created by sschmid on 19.12.12.
//
// contact@sschmid.com
//


#import "CarModule.h"
#import "SDInjector.h"
#import "SingletonFoo.h"


@implementation CarModule

- (void)configure:(SDInjector *)injector {
    [super configure:injector];

    [self mapSingleton:[SingletonFoo class] to:[SingletonFoo class] lazy:YES];
}

@end