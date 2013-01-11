//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "GIModule.h"
#import "GIInjector.h"
#import "GIInjectorEntry.h"
#import "GRReflection.h"

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
    for (GIInjectorEntry *entry in [_context allValues])
        [self unMap:entry.object from:entry.keyObject];

    _injector = nil;
}

- (void)map:(id)object to:(id)keyObject {
    [_injector map:object to:keyObject];
    [self addEntryForKeyObject:keyObject];
}

- (void)mapSingleton:(id)object to:(id)keyObject {
    [_injector mapSingleton:object to:keyObject];
    [self addEntryForKeyObject:keyObject];}

- (void)mapEagerSingleton:(id)object to:(id)keyObject {
    [_injector mapEagerSingleton:object to:keyObject];
    [self addEntryForKeyObject:keyObject];
}

- (BOOL)isObject:(id)object mappedTo:(id)keyObject {
    return [_injector isObject:object mappedTo:keyObject];
}

- (void)unMap:(id)object from:(id)keyObject {
    [_injector unMap:object from:keyObject];
    [_context removeObjectForKey:[self keyForObject:keyObject]];
}

- (GIInjectorEntry *)entryForKeyObject:(id)keyObject {
    return [_injector entryForKeyObject:keyObject];
}

- (void)addEntryForKeyObject:(id)keyObject {
    GIInjectorEntry *entry = [_injector entryForKeyObject:keyObject];
    _context[[self keyForObject:entry.keyObject]] = entry;
}

- (NSString *)keyForObject:(id)object {
    if ([GRReflection isProtocol:object])
        return [NSString stringWithFormat:@"<%@>", NSStringFromProtocol(object)];

    return NSStringFromClass(object);
}

@end