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
    for (NSString *key in [_context copy]) {
        GIInjectorEntry *entry = _context[key];
        [self unMap:entry.object from:entry.keyObject];
    }
    _injector = nil;
}

- (void)map:(id)object to:(id)keyObject {
    [_injector map:object to:keyObject];
    GIInjectorEntry *entry = [_injector entryForKeyObject:keyObject];
    [_context setObject:entry forKey:[self keyForObject:entry.keyObject]];
}

- (void)mapSingleton:(id)object to:(id)keyObject lazy:(BOOL)lazy {
    [_injector mapSingleton:object to:keyObject lazy:lazy];
    GIInjectorEntry *entry = [_injector entryForKeyObject:keyObject];
    [_context setObject:entry forKey:[self keyForObject:entry.keyObject]];
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

- (NSString *)keyForObject:(id)object {
    if ([GRReflection isProtocol:object])
        return [NSString stringWithFormat:@"<%@>", NSStringFromProtocol(object)];

    return NSStringFromClass(object);
}

@end