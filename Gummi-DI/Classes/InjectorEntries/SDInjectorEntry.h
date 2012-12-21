//
// Created by sschmid on 15.12.12.
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>

@class SDInjector;

@interface SDInjectorEntry : NSObject {
    id _whenAskedFor;
    id _use;
    SDInjector *_injector;
}

@property(nonatomic, strong, readonly) id whenAskedFor;
@property(nonatomic, strong, readonly) id use;

- (id)initWithObject:(id)whenAskedFor mappedTo:(id)use injector:(SDInjector *)injector;
- (id)extractObject;

@end
