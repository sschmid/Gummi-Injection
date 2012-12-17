//
// Created by sschmid on 15.12.12.
//
// contact@sschmid.com
//


#import "Kiwi.h"
#import "SDInjector.h"
#import "Car.h"
#import "Garage.h"
#import "SingletonFoo.h"
#import "SingletonBar.h"
#import "HybridMotor.h"
#import "Wheel.h"

SPEC_BEGIN(SDInjectorSpec)

        describe(@"SDInjector", ^{

            __block SDInjector *injector;
            beforeEach(^{
                injector = [[SDInjector alloc] init];
            });

            it(@"instantiates an injector", ^{
                [[injector should] beKindOfClass:[SDInjector class]];
            });

            it(@"has no mappings", ^{
                [[theValue([injector is:[Car class] mappedTo:[Car class]]) should] beNo];
            });

            it(@"retrieves objects from empty context", ^{
                Wheel *wheel = [injector getObject:[Wheel class]];

                [[wheel should] beKindOfClass:[Wheel class]];
            });

            it(@"raises exception when asking for unmapped protocol", ^{
                [[theBlock(^{
                    [injector getObject:@protocol(Vehicle)];
                }) should] raiseWithName:@"SDInjectorException"];
            });

            it(@"raises exception when class does not conform to protocol", ^{
                [[theBlock(^{
                    [injector map:@protocol(Vehicle) to:[NSObject class]];
                }) should] raiseWithName:@"SDInjectorException"];
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
                    BOOL m1 = [injector is:[Car class] mappedTo:[Car class]];
                    BOOL m2 = [injector is:[Garage class] mappedTo:[Garage class]];
                    BOOL m3 = [injector is:@protocol(Motor) mappedTo:[HybridMotor class]];

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
                    BOOL m1 = [injector is:@protocol(Vehicle) mappedTo:[Car class]];
                    BOOL m2 = [injector is:[Garage class] mappedTo:[Garage class]];
                    BOOL m3 = [injector is:@protocol(Motor) mappedTo:[HybridMotor class]];

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
                    [injector map:@protocol(Vehicle) to:[Car class] asSingleton:YES];
                    [injector mapSingleton:[Garage class]];
                    [injector map:@protocol(Motor) to:[HybridMotor class]];
                    car = [injector getObject:@protocol(Vehicle)];
                    garage = [injector getObject:[Garage class]];

                });

                it(@"has mapping", ^{
                    BOOL m1 = [injector is:@protocol(Vehicle) mappedTo:[Car class]];
                    BOOL m2 = [injector is:[Garage class] mappedTo:[Garage class]];
                    BOOL m3 = [injector is:@protocol(Motor) mappedTo:[HybridMotor class]];

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
                    [injector mapSingleton:[SingletonFoo class]];
                    [injector mapSingleton:[SingletonBar class]];
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
                    BOOL m1 = [injector is:@protocol(Motor) mappedTo:[HybridMotor class]];
                    BOOL m2 = [injector is:@protocol(Vehicle) mappedTo:mappedCar];
                    BOOL m3 = [injector is:[Garage class] mappedTo:garage];

                    BOOL m4 = [injector is:[Garage class] mappedTo:[Garage class]];
                    BOOL m5 = [injector is:[Garage class] mappedTo:[[Garage alloc] init]];
                    BOOL m6 = [injector is:[Car class] mappedTo:[Car class]];
                    BOOL m7 = [injector is:[Car class] mappedTo:[Car car]];

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
                    }) should] raiseWithName:@"SDInjectorException"];
                });

            });

            context(@"when context has eager", ^{

                it(@"creates instance", ^{
                    BOOL wasToggled = [SingletonFoo isInitialized];
                    [injector mapEagerSingleton:[SingletonFoo class]];
                    BOOL isToggled = [SingletonFoo isInitialized];

                    [[theValue(wasToggled) shouldNot] equal:theValue(isToggled)];
                });

                it(@"always return same instance", ^{
                    [injector mapEagerSingleton:[SingletonFoo class]];

                    [[[injector getObject:[SingletonFoo class]] should] equal:[injector getObject:[SingletonFoo class]]];
                });

            });

            it(@"removes mappings", ^{
                [injector map:@protocol(Vehicle) to:[Car class]];
                BOOL has1 = [injector is:@protocol(Vehicle) mappedTo:[Car class]];
                [injector unMap:@protocol(Vehicle) from:[Car class]];
                BOOL has2 = [injector is:@protocol(Vehicle) mappedTo:[Car class]];

                [[theValue(has1) should] beYes];
                [[theValue(has2) should] beNo];
            });

        });

        SPEC_END