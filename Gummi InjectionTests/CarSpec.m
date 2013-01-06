//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "Kiwi.h"
#import "Car.h"
#import "Wheel.h"
#import "HybridMotor.h"

SPEC_BEGIN(CarSpec)

        describe(@"Car", ^{

            __block Car *car;
            beforeEach(^{
                car = [Car car];
            });

            it(@"creates a car", ^{
                [[car should] beKindOfClass:[Car class]];
            });

            it(@"has no wheels", ^{
                [[theValue(car.numWheels) should] equal:theValue(0)];
            });

            it(@"has no motor", ^{
                BOOL hasMotor = car.motor != nil;
                [[theValue(hasMotor) should] beNo];
            });

            it(@"can not drive", ^{
                [[theValue(car.canDrive) should] beNo];
            });

            it(@"creates a wheel", ^{
                [[[Wheel wheel] should] beKindOfClass:[Wheel class]];
            });

            it(@"creates a motor", ^{
                [[[HybridMotor motor] should] beKindOfClass:[HybridMotor class]];
                [[[HybridMotor motor] should] conformsToProtocol:@protocol(Motor)];
            });

            it(@"adds wheels", ^{
                car.leftFrontWheel = [Wheel wheel];
                car.rightFrontWheel = [Wheel wheel];
                car.leftRearWheel = [Wheel wheel];
                car.rightRearWheel = [Wheel wheel];

                BOOL hasAllWheels = car.numWheels == 4;
                BOOL hasFLW = [car.leftFrontWheel isKindOfClass:[Wheel class]];
                BOOL hasFRW = [car.rightFrontWheel isKindOfClass:[Wheel class]];
                BOOL hasBLW = [car.leftRearWheel isKindOfClass:[Wheel class]];
                BOOL hasBRW = [car.rightRearWheel isKindOfClass:[Wheel class]];

                [[theValue(hasAllWheels && hasBLW && hasFLW && hasFRW && hasBRW) should] beYes];
            });

            it(@"can not drive without motor", ^{
                car.leftFrontWheel = [Wheel wheel];
                car.rightFrontWheel = [Wheel wheel];
                car.leftRearWheel = [Wheel wheel];
                car.rightRearWheel = [Wheel wheel];

                [[theValue(car.canDrive) should] beNo];
            });

            it(@"adds a motor", ^{
                car.motor = [HybridMotor motor];
                BOOL hasMotor = car.motor != nil;

                [[theValue(hasMotor) should] beYes];
            });

            it(@"can not drive without wheels", ^{
                car.motor = [HybridMotor motor];
                [[theValue(car.canDrive) should] beNo];
            });

            it(@"can drive", ^{
                car.leftFrontWheel = [Wheel wheel];
                car.rightFrontWheel = [Wheel wheel];
                car.leftRearWheel = [Wheel wheel];
                car.rightRearWheel = [Wheel wheel];
                car.motor = [HybridMotor motor];

                [[theValue(car.canDrive) should] beYes];
            });

        });

        SPEC_END
