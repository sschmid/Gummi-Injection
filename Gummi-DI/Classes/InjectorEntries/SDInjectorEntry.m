//
// Created by sschmid on 15.12.12.
//
// contact@sschmid.com
//


#import "SDInjectorEntry.h"
#import "SDInjector.h"
#import "SDReflector.h"


@implementation SDInjectorEntry
@synthesize whenAskedFor = _whenAskedFor;
@synthesize use = _use;

- (id)initWithObject:(id)whenAskedFor mappedTo:(id)use injector:(SDInjector *)injector {
    self = [super init];
    if (self) {
        if ([SDReflector isProtocol:whenAskedFor] && ![use conformsToProtocol:whenAskedFor])
            @throw [NSException exceptionWithName:@"SDInjectorEntryException" reason:[NSString stringWithFormat:@"%@ does not conform to protocol %@", use, whenAskedFor] userInfo:nil];

        _whenAskedFor = whenAskedFor;
        _use = use;
        _injector = injector;
    }

    return self;
}

- (id)extractObject {
    return _use;
}

@end