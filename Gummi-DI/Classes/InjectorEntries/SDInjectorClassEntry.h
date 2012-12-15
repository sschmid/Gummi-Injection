//
// Created by sschmid on 15.12.12.
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>
#import "SDInjectorEntry.h"


@interface SDInjectorClassEntry : SDInjectorEntry

+ (id)entryWithObject:(id)object injector:(SDInjector *)injector asSingleton:(BOOL)asSingleton;

- (id)initWithObject:(id)object injector:(SDInjector *)injector asSingleton:(BOOL)asSingleton;

@end