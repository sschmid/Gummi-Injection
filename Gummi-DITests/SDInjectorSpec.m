//
// Created by sschmid on 15.12.12.
//
// contact@sschmid.com
//


#import "Kiwi.h"
#import "SDInjector.h"
#import "Car.h"
#import "Wheel.h"
#import "Garage.h"

SPEC_BEGIN(SDInjectorSpec)

//        describe(@"Reflection", ^{
//            __block SDInjector *injector;
//            beforeEach(^{
//                injector = [SDInjector sharedInjector];
//            });
//
//            it(@"gets the class of a property", ^{
//                id wheelClass = [injector getTypeForProperty:@"frontLeftWheel" ofClass:[Car class]];
//
//                [[wheelClass should] equal:[Wheel class]];
//            });
//
//            it(@"raises exeption for unknown property names", ^{
//                [[theBlock(^{
//                    [injector getTypeForProperty:@"iDoNotExist" ofClass:[Car class]];
//                }) should] raiseWithName:(NSString *) @"SDInjectorException"];
//            });
//
//        });

        describe(@"SDInjector", ^{

            __block SDInjector *injector;
            beforeEach(^{
                injector = [SDInjector sharedInjector];
            });

            it(@"instantiates an injector", ^{
                [[injector should] beKindOfClass:[SDInjector class]];
            });

            it(@"has no objects in context", ^{
                Car *car = [injector getObject:[Car class]];

                [car shouldBeNil];
            });

            it(@"raises exception when class does not conform to protocol", ^{
                [[theBlock(^{
                    [injector map:@protocol(Vehicle) to:[NSObject class] asSingleton:NO];
                }) should] raiseWithName:(NSString *) @"SDInjectorException"];
            });

            context(@"when context has classes mapped", ^{

                __block Car *car;
                __block Garage *garage;
                beforeEach(^{
                    [injector map:[Car class] to:[Car class] asSingleton:NO];
                    [injector map:[Garage class] to:[Garage class] asSingleton:NO];
                    car = [injector getObject:[Car class]];
                    garage = [injector getObject:[Garage class]];
                });

                it(@"pulls object from context", ^{
                    [[car should] beKindOfClass:[Car class]];
                    [[garage should] beKindOfClass:[Garage class]];
                });

                it(@"returns new instances", ^{
                    [[[injector getObject:[Car class]] shouldNot] equal:[injector getObject:[Car class]]];
                });

                it(@"pulls object with all its dependecies set", ^{
                    [[theValue(car.numWheels) should] equal:theValue(4)];
                    [[car.frontRightWheel should] beKindOfClass:[Wheel class]];
                    [[car.frontLeftWheel should] beKindOfClass:[Wheel class]];
                    [[car.backLeftWheel should] beKindOfClass:[Wheel class]];
                    [[car.backRightWheel should] beKindOfClass:[Wheel class]];
                });

                it(@"pulls object with all its dependecies set", ^{
                    [[garage.audi should] beKindOfClass:[Car class]];
                    [[garage.bmw should] beKindOfClass:[Car class]];
                    [[garage.mercedes should] beKindOfClass:[Car class]];
                });

                it(@"sets dependencies of dependencies", ^{
                    [[theValue(garage.audi.numWheels) should] equal:theValue(4)];
                    [[garage.audi.frontRightWheel should] beKindOfClass:[Wheel class]];
                    [[garage.audi.frontLeftWheel should] beKindOfClass:[Wheel class]];
                    [[garage.audi.backLeftWheel should] beKindOfClass:[Wheel class]];
                    [[garage.audi.backRightWheel should] beKindOfClass:[Wheel class]];

                    [[theValue(garage.bmw.numWheels) should] equal:theValue(4)];
                    [[garage.bmw.frontRightWheel should] beKindOfClass:[Wheel class]];
                    [[garage.bmw.frontLeftWheel should] beKindOfClass:[Wheel class]];
                    [[garage.bmw.backLeftWheel should] beKindOfClass:[Wheel class]];
                    [[garage.bmw.backRightWheel should] beKindOfClass:[Wheel class]];

                    [[theValue(garage.mercedes.numWheels) should] equal:theValue(4)];
                    [[garage.mercedes.frontRightWheel should] beKindOfClass:[Wheel class]];
                    [[garage.mercedes.frontLeftWheel should] beKindOfClass:[Wheel class]];
                    [[garage.mercedes.backLeftWheel should] beKindOfClass:[Wheel class]];
                    [[garage.mercedes.backRightWheel should] beKindOfClass:[Wheel class]];
                });

            });


            context(@"when context has protocols mapped", ^{

                __block Car *car;
                __block Garage *garage;
                beforeEach(^{
                    [injector map:@protocol(Vehicle) to:[Car class] asSingleton:NO];
                    [injector map:[Garage class] to:[Garage class] asSingleton:NO];
                    car = [injector getObject:@protocol(Vehicle)];
                    garage = [injector getObject:[Garage class]];
                });

                it(@"pulls object from context", ^{
                    [[car should] beKindOfClass:[Car class]];
                    [[garage should] beKindOfClass:[Garage class]];
                });

                it(@"pulls object with all its dependecies set", ^{
                    [[theValue(car.numWheels) should] equal:theValue(4)];
                    [[car.frontRightWheel should] beKindOfClass:[Wheel class]];
                    [[car.frontLeftWheel should] beKindOfClass:[Wheel class]];
                    [[car.backLeftWheel should] beKindOfClass:[Wheel class]];
                    [[car.backRightWheel should] beKindOfClass:[Wheel class]];
                });

                it(@"pulls object with all its dependecies set", ^{
                    [[garage.audi should] beKindOfClass:[Car class]];
                    [[garage.bmw should] beKindOfClass:[Car class]];
                    [[garage.mercedes should] beKindOfClass:[Car class]];
                });

                it(@"sets dependencies of dependencies", ^{
                    [[theValue(garage.audi.numWheels) should] equal:theValue(4)];
                    [[garage.audi.frontRightWheel should] beKindOfClass:[Wheel class]];
                    [[garage.audi.frontLeftWheel should] beKindOfClass:[Wheel class]];
                    [[garage.audi.backLeftWheel should] beKindOfClass:[Wheel class]];
                    [[garage.audi.backRightWheel should] beKindOfClass:[Wheel class]];

                    [[theValue(garage.bmw.numWheels) should] equal:theValue(4)];
                    [[garage.bmw.frontRightWheel should] beKindOfClass:[Wheel class]];
                    [[garage.bmw.frontLeftWheel should] beKindOfClass:[Wheel class]];
                    [[garage.bmw.backLeftWheel should] beKindOfClass:[Wheel class]];
                    [[garage.bmw.backRightWheel should] beKindOfClass:[Wheel class]];

                    [[theValue(garage.mercedes.numWheels) should] equal:theValue(4)];
                    [[garage.mercedes.frontRightWheel should] beKindOfClass:[Wheel class]];
                    [[garage.mercedes.frontLeftWheel should] beKindOfClass:[Wheel class]];
                    [[garage.mercedes.backLeftWheel should] beKindOfClass:[Wheel class]];
                    [[garage.mercedes.backRightWheel should] beKindOfClass:[Wheel class]];
                });

            });

            context(@"when context has singletons mapped", ^{

                beforeEach(^{
                    //[injector map:[Car class] to:[Car class] asSingleton:YES];
                    [injector mapSingleton:[Car class]];
                });

                it(@"pulls object from context", ^{
                    Car *car = [injector getObject:[Car class]];

                    [[car should] beKindOfClass:[Car class]];
                });

                it(@"always returns same instance", ^{
                    [[[injector getObject:[Car class]] should] equal:[injector getObject:[Car class]]];
                });

            });

        });

        SPEC_END