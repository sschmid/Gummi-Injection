//
// Created by sschmid on 15.12.12.
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>

@class SDInjector;


@interface SDInjectorEntry : NSObject {
    SDInjector *_injector;
}

@property(nonatomic, strong) id object;

+ (id)entryWithObject:(id)object injector:(SDInjector *)injector;

- (id)initWithObject:(id)object injector:(SDInjector *)injector;
- (id)extractObject;

@end
