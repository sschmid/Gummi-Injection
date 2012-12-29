//
// Created by sschmid on 17.12.12.
//
// contact@sschmid.com
//


@class GIInjectorEntry;

@protocol GIInjectionMapper <NSObject>

- (GIInjectorEntry *)map:(id)whenAskedFor to:(id)use;
- (GIInjectorEntry *)mapSingleton:(id)whenAskedFor to:(id)use lazy:(BOOL)lazy;

- (BOOL)isObject:(id)whenAskedFor mappedTo:(id)use;
- (void)unMap:(id)whenAskedFor from:(id)use;

@end