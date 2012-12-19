//
// Created by sschmid on 17.12.12.
//
// contact@sschmid.com
//


#import "SDModule.h"
#import "SDInjector.h"
#import "SDInjectorEntry.h"

@implementation SDModule

- (id)init {
    self = [super init];
    if (self) {
        _context = [[NSMutableArray alloc] init];
    }

    return self;
}

- (SDInjectorEntry *)map:(id)whenAskedFor to:(id)use {
    SDInjectorEntry *entry = [_injector map:whenAskedFor to:use];
    [_context addObject:entry];
    return entry;
}

- (SDInjectorEntry *)mapSingleton:(id)whenAskedFor to:(id)use lazy:(BOOL)lazy {
    SDInjectorEntry *entry = [_injector mapSingleton:whenAskedFor to:use lazy:lazy];
    [_context addObject:entry];
    return entry;
}

- (BOOL)is:(id)whenAskedFor mappedTo:(id)use {
    return [_injector is:whenAskedFor mappedTo:use];
}

- (void)unMap:(id)whenAskedFor from:(id)use {
    [_injector unMap:whenAskedFor from:use];
}

- (void)configure:(SDInjector *)injector {
    _injector = injector;
}

@end