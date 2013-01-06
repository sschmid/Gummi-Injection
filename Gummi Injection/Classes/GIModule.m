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
    for (NSString *key in [_context copy]) {
        GIInjectorEntry *entry = _context[key];
        [self unMap:entry.object from:entry.whenAskedFor];
    }
    _injector = nil;
}

- (GIInjectorEntry *)map:(id)object to:(id)whenAskedFor {
    GIInjectorEntry *entry = [_injector map:object to:whenAskedFor];
    [_context setObject:entry forKey:[self keyForObject:entry.whenAskedFor]];
    return entry;
}

- (GIInjectorEntry *)mapSingleton:(id)object to:(id)whenAskedFor lazy:(BOOL)lazy {
    GIInjectorEntry *entry = [_injector mapSingleton:object to:whenAskedFor lazy:lazy];
    [_context setObject:entry forKey:[self keyForObject:entry.whenAskedFor]];
    return entry;
}

- (BOOL)isObject:(id)object mappedTo:(id)whenAskedFor {
    return [_injector isObject:object mappedTo:whenAskedFor];
}

- (void)unMap:(id)object from:(id)whenAskedFor {
    [_injector unMap:object from:whenAskedFor];
    [_context removeObjectForKey:[self keyForObject:whenAskedFor]];
}

- (NSString *)keyForObject:(id)object {
    if ([GIReflector isProtocol:object])
        return [NSString stringWithFormat:@"<%@>", NSStringFromProtocol(object)];

    return NSStringFromClass(object);
}

@end