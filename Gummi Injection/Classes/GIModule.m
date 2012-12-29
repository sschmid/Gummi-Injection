//
// Created by sschmid on 17.12.12.
//
// contact@sschmid.com
//


#import "GIModule.h"
#import "GIInjector.h"
#import "GIInjectorEntry.h"
#import "GIReflector.h"

@implementation GIModule

- (id)init {
    self = [super init];
    if (self) {
        _context = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (void)configure:(GIInjector *)injector {
    _injector = injector;
}

- (void)unload {
    for (NSString *key in _context) {
        GIInjectorEntry *entry = _context[key];
        [_injector unMap:entry.whenAskedFor from:entry.use];
    }
    _context = nil;
    _injector = nil;
}

- (GIInjectorEntry *)map:(id)whenAskedFor to:(id)use {
    GIInjectorEntry *entry = [_injector map:whenAskedFor to:use];
    [self addEntry:entry];
    return entry;
}

- (GIInjectorEntry *)mapSingleton:(id)whenAskedFor to:(id)use lazy:(BOOL)lazy {
    GIInjectorEntry *entry = [_injector mapSingleton:whenAskedFor to:use lazy:lazy];
    [self addEntry:entry];
    return entry;
}

- (BOOL)isObject:(id)whenAskedFor mappedTo:(id)use {
    return [_injector isObject:whenAskedFor mappedTo:use];
}

- (void)unMap:(id)whenAskedFor from:(id)use {
    [_injector unMap:whenAskedFor from:use];
}

- (void)addEntry:(GIInjectorEntry *)entry {
    [_context setObject:entry forKey:[self keyForObject:entry.whenAskedFor]];
}

- (NSString *)keyForObject:(id)object {
    if ([GIReflector isProtocol:object])
        return [NSString stringWithFormat:@"<%@>", NSStringFromProtocol(object)];

    return NSStringFromClass(object);
}

@end