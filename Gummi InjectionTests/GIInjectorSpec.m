//
// Created by sschmid on 15.12.12.
//
// contact@sschmid.com
//


#import "Kiwi.h"
#import "GIInjector.h"
#import "Car.h"
#import "Garage.h"
#import "SingletonFoo.h"
#import "SingletonBar.h"
#import "HybridMotor.h"
#import "Wheel.h"
#import "GIModule.h"
#import "CarModule.h"

SPEC_BEGIN(GIInjectorSpec)

        describe(@"GIInjector", ^{

            __block GIInjector *injector;
            beforeEach(^{
                injector = [[GIInjector alloc] init];
            });

            it(@"instantiates an injector", ^{
                [[injector should] beKindOfClass:[GIInjector class]];
            });

            it(@"returns shared injector", ^{
                [[[GIInjector sharedInjector] should] equal:[GIInjector sharedInjector]];
            });

            it(@"has no mappings", ^{
                [[theValue([injector isObject:[Car class] mappedTo:[Car class]]) should] beNo];
            });

            it(@"retrieves objects from empty context", ^{
                Wheel *wheel = [injector getObject:[Wheel class]];

                [[wheel should] beKindOfClass:[Wheel class]];
            });

            it(@"raises exception when asking for unmapped protocol", ^{
                [[theBlock(^{
                    [injector getObject:@protocol(Vehicle)];
                }) should] raiseWithName:@"GIInjectorException"];
            });

            it(@"raises exception when class does not conform to protocol", ^{
                [[theBlock(^{
                    [injector map:@protocol(Vehicle) to:[NSObject class]];
                }) should] raiseWithName:@"GIInjectorEntryException"];
            });

            context(@"when context has classes mapped", ^{

                __block Car *car;
                __block Garage *garage;
                beforeEach(^{
                    [injector map:[Car class] to:[Car class]];
                    [injector map:[Garage class] to:[Garage class]];
                    [injector map:@protocol(Motor) to:[HybridMotor class]];
                    car = [injector getObject:[Car class]];
                    garage = [injector getObject:[Garage class]];
                });

                it(@"has mapping", ^{
                    BOOL m1 = [injector isObject:[Car class] mappedTo:[Car class]];
                    BOOL m2 = [injector isObject:[Garage class] mappedTo:[Garage class]];
                    BOOL m3 = [injector isObject:@protocol(Motor) mappedTo:[HybridMotor class]];

                    [[theValue(m1) should] beYes];
                    [[theValue(m2) should] beYes];
                    [[theValue(m3) should] beYes];
                });

                it(@"pulls object from context", ^{
                    [[car should] beKindOfClass:[Car class]];
                    [[garage should] beKindOfClass:[Garage class]];
                });

                it(@"returns new instances", ^{
                    [[[injector getObject:[Car class]] shouldNot] equal:[injector getObject:[Car class]]];
                });

                it(@"pulls object with all its dependecies set", ^{
                    [[theValue(car.canDrive) should] beYes];
                    [[theValue(garage.isFull) should] beYes];
                });

                it(@"sets dependencies of dependencies", ^{
                    [[theValue(garage.audi.canDrive) should] beYes];
                    [[theValue(garage.bmw.canDrive) should] beYes];
                    [[theValue(garage.mercedes.canDrive) should] beYes];
                });

            });

            context(@"when context has protocols mapped", ^{

                __block Car *car;
                __block Garage *garage;
                beforeEach(^{
                    [injector map:@protocol(Vehicle) to:[Car class]];
                    [injector map:[Garage class] to:[Garage class]];
                    [injector map:@protocol(Motor) to:[HybridMotor class]];
                    car = [injector getObject:@protocol(Vehicle)];
                    garage = [injector getObject:[Garage class]];
                });

                it(@"has mapping", ^{
                    BOOL m1 = [injector isObject:@protocol(Vehicle) mappedTo:[Car class]];
                    BOOL m2 = [injector isObject:[Garage class] mappedTo:[Garage class]];
                    BOOL m3 = [injector isObject:@protocol(Motor) mappedTo:[HybridMotor class]];

                    [[theValue(m1) should] beYes];
                    [[theValue(m2) should] beYes];
                    [[theValue(m3) should] beYes];
                });

                it(@"pulls object from context", ^{
                    [[car should] beKindOfClass:[Car class]];
                    [[garage should] beKindOfClass:[Garage class]];
                });

                it(@"pulls object with all its dependecies set", ^{
                    [[theValue(car.canDrive) should] beYes];
                    [[theValue(garage.isFull) should] beYes];
                });

                it(@"sets dependencies of dependencies", ^{
                    [[theValue(garage.audi.canDrive) should] beYes];
                    [[theValue(garage.bmw.canDrive) should] beYes];
                    [[theValue(garage.mercedes.canDrive) should] beYes];
                });

            });

            context(@"when context has singletons mapped", ^{

                __block Car *car;
                __block Garage *garage;
                beforeEach(^{
                    [injector mapSingleton:@protocol(Vehicle) to:[Car class] lazy:YES];
                    [injector mapSingleton:[Garage class] to:[Garage class] lazy:YES];
                    [injector map:@protocol(Motor) to:[HybridMotor class]];
                    car = [injector getObject:@protocol(Vehicle)];
                    garage = [injector getObject:[Garage class]];

                });

                it(@"has mapping", ^{
                    BOOL m1 = [injector isObject:@protocol(Vehicle) mappedTo:[Car class]];
                    BOOL m2 = [injector isObject:[Garage class] mappedTo:[Garage class]];
                    BOOL m3 = [injector isObject:@protocol(Motor) mappedTo:[HybridMotor class]];

                    [[theValue(m1) should] beYes];
                    [[theValue(m2) should] beYes];
                    [[theValue(m3) should] beYes];
                });

                it(@"pulls object from context", ^{
                    [[car should] beKindOfClass:[Car class]];
                });

                it(@"always returns same instance", ^{
                    [[[injector getObject:@protocol(Vehicle)] should] equal:[injector getObject:@protocol(Vehicle)]];
                    [[[injector getObject:[Garage class]] should] equal:[injector getObject:[Garage class]]];
                });

                it(@"pulls object with all its dependecies set", ^{
                    [[theValue(car.canDrive) should] beYes];
                    [[theValue(garage.isFull) should] beYes];
                });

                it(@"sets dependencies of dependencies", ^{
                    [[theValue(garage.audi.canDrive) should] beYes];
                    [[theValue(garage.bmw.canDrive) should] beYes];
                    [[theValue(garage.mercedes.canDrive) should] beYes];
                });
            });

            context(@"when circular dependency", ^{

                it(@"will be resolved for singletons", ^{
                    [injector mapSingleton:[SingletonFoo class] to:[SingletonFoo class] lazy:YES];
                    [injector mapSingleton:[SingletonBar class] to:[SingletonBar class] lazy:YES];
                    SingletonFoo *foo = [injector getObject:[SingletonFoo class]];
                    SingletonBar *bar = [injector getObject:[SingletonBar class]];

                    [[foo.bar should] equal:bar];
                    [[bar.foo should] equal:foo];
                });

            });

            context(@"when context has instance mapped", ^{

                __block Car *mappedCar;
                __block Car *retrievedCar;
                __block Garage *garage;
                beforeEach(^{
                    [injector map:@protocol(Motor) to:[HybridMotor class]];
                    mappedCar = [Car car];
                    garage = [[Garage alloc] init];
                    [injector map:@protocol(Vehicle) to:mappedCar];
                    [injector map:[Garage class] to:garage];
                    retrievedCar = [injector getObject:@protocol(Vehicle)];
                });

                it(@"has mapping", ^{
                    BOOL m1 = [injector isObject:@protocol(Motor) mappedTo:[HybridMotor class]];
                    BOOL m2 = [injector isObject:@protocol(Vehicle) mappedTo:mappedCar];
                    BOOL m3 = [injector isObject:[Garage class] mappedTo:garage];

                    BOOL m4 = [injector isObject:[Garage class] mappedTo:[Garage class]];
                    BOOL m5 = [injector isObject:[Garage class] mappedTo:[[Garage alloc] init]];
                    BOOL m6 = [injector isObject:[Car class] mappedTo:[Car class]];
                    BOOL m7 = [injector isObject:[Car class] mappedTo:[Car car]];

                    [[theValue(m1) should] beYes];
                    [[theValue(m2) should] beYes];
                    [[theValue(m3) should] beYes];

                    [[theValue(m4) should] beNo];
                    [[theValue(m5) should] beNo];
                    [[theValue(m6) should] beNo];
                    [[theValue(m7) should] beNo];
                });

                it(@"returns instance", ^{
                    [[retrievedCar should] equal:mappedCar];
                });

                it(@"pulls object with all its dependecies set", ^{
                    [[theValue(mappedCar.canDrive) should] beYes];
                    [[theValue(retrievedCar.canDrive) should] beYes];
                    [[theValue(garage.isFull) should] beYes];
                });

                it(@"sets dependencies of dependencies", ^{
                    [[theValue(garage.audi.canDrive) should] beYes];
                    [[theValue(garage.bmw.canDrive) should] beYes];
                    [[theValue(garage.mercedes.canDrive) should] beYes];
                });

            });

            context(@"when context has protocol mapped", ^{

                it(@"raises exception", ^{
                    [[theBlock(^{
                        [injector map:[NSObject class] to:@protocol(Vehicle)];
                    }) should] raiseWithName:@"GIInjectorException"];
                });

            });

            context(@"when context has eager", ^{

                it(@"creates instance", ^{
                    BOOL wasToggled = [SingletonFoo isInitialized];
                    [injector mapSingleton:[SingletonFoo class] to:[SingletonFoo class] lazy:NO];
                    BOOL isToggled = [SingletonFoo isInitialized];

                    [[theValue(wasToggled) shouldNot] equal:theValue(isToggled)];
                });

                it(@"always return same instance", ^{
                    [injector mapSingleton:[SingletonFoo class] to:[SingletonFoo class] lazy:NO];

                    [[[injector getObject:[SingletonFoo class]] should] equal:[injector getObject:[SingletonFoo class]]];
                });

            });

            it(@"removes mappings", ^{
                [injector map:@protocol(Vehicle) to:[Car class]];
                BOOL has1 = [injector isObject:@protocol(Vehicle) mappedTo:[Car class]];
                [injector unMap:@protocol(Vehicle) from:[Car class]];
                BOOL has2 = [injector isObject:@protocol(Vehicle) mappedTo:[Car class]];

                [[theValue(has1) should] beYes];
                [[theValue(has2) should] beNo];
            });

            it(@"has no module class", ^{
                BOOL has = [injector hasModuleClass:[GIModule class]];
                [[theValue(has) should] beNo];
            });

            it(@"has no module", ^{
                BOOL has = [injector hasModule:[[GIModule alloc] init]];
                [[theValue(has) should] beNo];
            });

            context(@"when added a module", ^{

                __block CarModule *carModule;
                beforeEach(^{
                    carModule = [[CarModule alloc] init];
                    [injector addModule:carModule];
                });

                it(@"has module", ^{
                    BOOL has = [injector hasModule:carModule];
                    [[theValue(has) should] beYes];
                });

                it(@"has module class", ^{
                    BOOL has = [injector hasModuleClass:[CarModule class]];
                    [[theValue(has) should] beYes];
                });

                it(@"has modules mappings", ^{
                    BOOL has = [injector isObject:[SingletonFoo class] mappedTo:[SingletonFoo class]];
                    [[theValue(has) should] beYes];
                });

                context(@"when removed module", ^{

                    beforeEach(^{
                        [injector removeModule:carModule];
                    });

                    it(@"has no module", ^{
                        BOOL has = [injector hasModule:carModule];
                        [[theValue(has) should] beNo];
                    });

                    it(@"has no module class", ^{
                        BOOL has = [injector hasModuleClass:[CarModule class]];
                        [[theValue(has) should] beNo];
                    });

                    it(@"has no modules mappings", ^{
                        BOOL has = [injector isObject:[SingletonFoo class] mappedTo:[SingletonFoo class]];
                        [[theValue(has) should] beNo];
                    });

                });

                context(@"when removed module class", ^{

                    beforeEach(^{
                        [injector removeModuleClass:[CarModule class]];
                    });

                    it(@"has no module", ^{
                        BOOL has = [injector hasModule:carModule];
                        [[theValue(has) should] beNo];
                    });

                    it(@"has no module class", ^{
                        BOOL has = [injector hasModuleClass:[CarModule class]];
                        [[theValue(has) should] beNo];
                    });

                    it(@"has no modules mappings", ^{
                        BOOL has = [injector isObject:[SingletonFoo class] mappedTo:[SingletonFoo class]];
                        [[theValue(has) should] beNo];
                    });

                });

            });

        });

        SPEC_END