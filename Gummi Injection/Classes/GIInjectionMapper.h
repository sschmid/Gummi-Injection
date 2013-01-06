//
// Created by Simon Schmid
//
// contact@sschmid.com
//


@class GIInjectorEntry;

@protocol GIInjectionMapper <NSObject>

- (GIInjectorEntry *)map:(id)object to:(id)whenAskedFor;
- (GIInjectorEntry *)mapSingleton:(id)object to:(id)whenAskedFor lazy:(BOOL)lazy;

- (BOOL)isObject:(id)object mappedTo:(id)whenAskedFor;
- (void)unMap:(id)object from:(id)whenAskedFor;

@end