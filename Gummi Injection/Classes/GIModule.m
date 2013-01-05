//
// Created by Simon Schmid
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
        [self unMap:entry.whenAskedFor from:entry.use];
    }
    _injector = nil;
}

- (GIInjectorEntry *)map:(id)whenAskedFor to:(id)use {
    GIInjectorEntry *entry = [_injector map:whenAskedFor to:use];
    [_context setObject:entry forKey:[self keyForObject:entry.whenAskedFor]];
    return entry;
}

- (GIInjectorEntry *)mapSingleton:(id)whenAskedFor to:(id)use lazy:(BOOL)lazy {
    GIInjectorEntry *entry = [_injector mapSingleton:whenAskedFor to:use lazy:lazy];
    [_context setObject:entry forKey:[self keyForObject:entry.whenAskedFor]];
    return entry;
}

- (BOOL)isObject:(id)whenAskedFor mappedTo:(id)use {
    return [_injector isObject:whenAskedFor mappedTo:use];
}

- (void)unMap:(id)whenAskedFor from:(id)use {
    [_injector unMap:whenAskedFor from:use];
    [_context removeObjectForKey:[self keyForObject:whenAskedFor]];
}

- (NSString *)keyForObject:(id)object {
    if ([GIReflector isProtocol:object])
        return [NSString stringWithFormat:@"<%@>", NSStringFromProtocol(object)];

    return NSStringFromClass(object);
}

@end