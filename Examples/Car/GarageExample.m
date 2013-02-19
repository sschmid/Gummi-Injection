//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "GarageExample.h"
#import "Engine.h"
#import "GIInjector.h"
#import "HybridEngine.h"
#import "Garage.h"

@implementation GarageExample

- (id)init {
    self = [super init];
    if (self) {
        GIInjector *injector = [GIInjector sharedInjector];

        // No need to set up rules for simple injections that can be created with alloc init.
        // Car and Wheels get injected automatically.
        // For protocols there's no way to know which implementation to return -
        // we need to set up a rule for it.
        [injector map:[HybridEngine class] to:@protocol(Engine)];

        // Injector creates Cars and injects Wheels and Engine.
        Garage *garage = [injector getObject:[Garage class]];

        // or use the macro
        // Garage *garage = getObject([Garage class]);

        // This will happen:
        // - [injector getObject:[Garage class]];
        // - getObject looks up type Garage -> no rule set -> Instantiate Garage with default initializer and inject into object
        // - Garage wants Cars
        //   - Look up type Car -> no rule set -> Instantiate Car with default initializer and inject into object
        //     - Each Car wants Wheels
        //         - Look up type Wheel -> no rule set -> Instantiate Wheel with default initializer and inject into object
        //     - Each Car wants <Engine>
        //         - Look up type <Engine> -> rule found: [HybridEngine class]
        //         - Instantiate HybridEngine with default initializer and inject into object
        //     - All dependencies of Car are now set. Call injection_complete selector (see Car.m)
        // Done

        NSLog(@"Garage is full with cars: %@", garage.isFull == 0 ? @"NO" : @"YES"); // YES, all dependencies set
    }

    return self;
}

@end