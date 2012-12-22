//
// Created by sschmid on 17.12.12.
//
// contact@sschmid.com
//


#import "SDModule.h"
#import "SDInjector.h"
#import "SDInjectorEntry.h"
#import "SDReflector.h"

@implementation SDModule

- (id)init {
    self = [super init];
    if (self) {
        _context = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (void)configure:(SDInjector *)injector {
    _injector = injector;
}

- (void)unload {
    for (NSString *key in _context) {
        SDInjectorEntry *entry = _context[key];
        [_injector unMap:entry.whenAskedFor from:entry.use];
    }
    _context = nil;
    _injector = nil;
}

- (SDInjectorEntry *)map:(id)whenAskedFor to:(id)use {
    SDInjectorEntry *entry = [_injector map:whenAskedFor to:use];
    [self addEntry:entry];
    return entry;
}

- (SDInjectorEntry *)mapSingleton:(id)whenAskedFor to:(id)use lazy:(BOOL)lazy {
    SDInjectorEntry *entry = [_injector mapSingleton:whenAskedFor to:use lazy:lazy];
    [self addEntry:entry];
    return entry;
}

- (BOOL)isObject:(id)whenAskedFor mappedTo:(id)use {
    return [_injector isObject:whenAskedFor mappedTo:use];
}

- (void)unMap:(id)whenAskedFor from:(id)use {
    [_injector unMap:whenAskedFor from:use];
}

- (void)addEntry:(SDInjectorEntry *)entry {
    [_context setObject:entry forKey:[self keyForObject:entry.whenAskedFor]];
}

- (NSString *)keyForObject:(id)object {
    if ([SDReflector isProtocol:object])
        return [NSString stringWithFormat:@"<%@>", NSStringFromProtocol(object)];

    return NSStringFromClass(object);
}

@end