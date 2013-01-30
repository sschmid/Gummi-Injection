//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "Kiwi.h"
#import "Car.h"
#import "Wheel.h"
#import "HybridEngine.h"

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

            it(@"has no engine", ^{
                BOOL hasEngine = car.engine != nil;
                [[theValue(hasEngine) should] beNo];
            });

            it(@"can not drive", ^{
                [[theValue(car.canDrive) should] beNo];
            });

            it(@"creates a wheel", ^{
                [[[Wheel wheel] should] beKindOfClass:[Wheel class]];
            });

            it(@"creates a engine", ^{
                [[[HybridEngine engine] should] beKindOfClass:[HybridEngine class]];
                [[[HybridEngine engine] should] conformsToProtocol:@protocol(Engine)];
            });

            it(@"adds wheels", ^{
                car.wheel1 = [Wheel wheel];
                car.wheel2 = [Wheel wheel];
                car.wheel3 = [Wheel wheel];
                car.wheel4 = [Wheel wheel];

                BOOL hasAllWheels = car.numWheels == 4;
                BOOL hasWheel1 = [car.wheel1 isKindOfClass:[Wheel class]];
                BOOL hasWheel2 = [car.wheel2 isKindOfClass:[Wheel class]];
                BOOL hasWheel3 = [car.wheel3 isKindOfClass:[Wheel class]];
                BOOL hasWheel4 = [car.wheel4 isKindOfClass:[Wheel class]];

                [[theValue(hasAllWheels && hasWheel1 && hasWheel2 && hasWheel3 && hasWheel4) should] beYes];
            });

            it(@"can not drive without engine", ^{
                car.wheel1 = [Wheel wheel];
                car.wheel2 = [Wheel wheel];
                car.wheel3 = [Wheel wheel];
                car.wheel4 = [Wheel wheel];

                [[theValue(car.canDrive) should] beNo];
            });

            it(@"adds a engine", ^{
                car.engine = [HybridEngine engine];
                BOOL hasEngine = car.engine != nil;

                [[theValue(hasEngine) should] beYes];
            });

            it(@"can not drive without wheels", ^{
                car.engine = [HybridEngine engine];
                [[theValue(car.canDrive) should] beNo];
            });

            it(@"can drive", ^{
                car.wheel1 = [Wheel wheel];
                car.wheel2 = [Wheel wheel];
                car.wheel3 = [Wheel wheel];
                car.wheel4 = [Wheel wheel];
                car.engine = [HybridEngine engine];

                [[theValue(car.canDrive) should] beYes];
            });

        });

        SPEC_END
