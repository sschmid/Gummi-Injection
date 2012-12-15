//
// Created by sschmid on 15.12.12.
//
// contact@sschmid.com
//


#import "SDInjectorEntry.h"
#import "SDInjector.h"


@interface SDInjectorEntry ()
@property(nonatomic, strong) SDInjector *injector;

@end

@implementation SDInjectorEntry
@synthesize object = _object;
@synthesize injector = _injector;


+ (id)entryWithObject:(id)object injector:(SDInjector *)injector {
    return [[self alloc] initWithObject:object injector:injector];
}

- (id)initWithObject:(id)object injector:(SDInjector *)injector {
    self = [super init];
    if (self) {
        self.object = object;
        self.injector = injector;
    }

    return self;
}

- (id)extractObject {
    return self.object;
}

@end