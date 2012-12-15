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

        describe(@"SDInjector", ^{

            __block SDInjector *injector;
            beforeEach(^{
                injector = [[SDInjector alloc] init];
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
                    [injector map:@protocol(Vehicle) to:[NSObject class]];
                }) should] raiseWithName:(NSString *) @"SDInjectorException"];
            });

            context(@"when context has classes mapped", ^{

                __block Car *car;
                __block Garage *garage;
                beforeEach(^{
                    [injector map:[Car class] to:[Car class]];
                    [injector map:[Garage class] to:[Garage class]];
                    car = [injector getObject:[Car class]];
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


            context(@"when context has protocols mappes", ^{

                __block Car *car;
                __block Garage *garage;
                beforeEach(^{
                    [injector map:@protocol(Vehicle) to:[Car class]];
                    [injector map:[Garage class] to:[Garage class]];
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

        });

        SPEC_END