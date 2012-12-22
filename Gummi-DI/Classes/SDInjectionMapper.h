//
// Created by sschmid on 17.12.12.
//
// contact@sschmid.com
//


@class SDInjectorEntry;

@protocol SDInjectionMapper <NSObject>

- (SDInjectorEntry *)map:(id)whenAskedFor to:(id)use;
- (SDInjectorEntry *)mapSingleton:(id)whenAskedFor to:(id)use lazy:(BOOL)lazy;

- (BOOL)isObject:(id)whenAskedFor mappedTo:(id)use;
- (void)unMap:(id)whenAskedFor from:(id)use;

@end