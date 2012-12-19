//
// Created by sschmid on 17.12.12.
//
// contact@sschmid.com
//


#import "Kiwi.h"
#import "SDModule.h"
#import "Vehicle.h"
#import "SDInjector.h"


SPEC_BEGIN(SDModuleSpec)

        describe(@"SDModule", ^{

            __block SDModule *module;
            __block SDInjector *injector;
            beforeEach(^{
                module = [[SDModule alloc] init];
                injector = [[SDInjector alloc] init];
            });

            it(@"creates obj", ^{
                [[module should] beKindOfClass:[SDModule class]];
            });

            it(@"has no mappings", ^{
                [[module.context should] beEmpty];
            });

            it(@"adds module", ^{
                [injector addModule:module];

            });

        });

        SPEC_END
