//
//  DDDeviceDetection.h
//  Device Detection
//
//  Created by Damien DeVille on 8/17/10.
//  Copyright 2010 Damien DeVille. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
	Feel free to comment the following import if you don't need to test
	location capabilities and don't want to import the CoreLocation framework
 */
#import <CoreLocation/CoreLocation.h>

/*
	Feel free to comment the following import if you don't need to test
	audio capabilities and don't want to import the AudioToolbox framework
 */
#import <AudioToolbox/AudioToolbox.h>

/*
	Feel free to comment the following import if you don't need to test
	gyroscope capabilities and don't want to import the CoreMotion framework
 */
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
#import <CoreMotion/CoreMotion.h>
#endif



/*
	NOTE: this is a compile time flag that you can use (at compile time!)
	given that the following methods are for use at runtime
 */
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
#define RUNNING_IOS4_0_OR_GREATER
#endif


@interface DDDeviceDetection : NSObject

+ (NSString *)returnDeviceName ;

// device checking
+ (BOOL)isAniPod ;
+ (BOOL)isAniPhone ;
+ (BOOL)isAniPad ;
+ (BOOL)isSimulator ;

// OS version checking
+ (BOOL)isRunningiOS2 ;
+ (BOOL)isRunningiOS3 ;
+ (BOOL)isRunningiOS4 ;

// software capabilities checking
+ (BOOL)isMultitaskingSupported ;

// audio capabilities checking
+ (BOOL)isInSilentMode ;
+ (BOOL)hasSpeakersOn ;
+ (BOOL)hasHeadphonesPlugged ;

// hardware checking
+ (BOOL)hasRetinaDisplay ;
+ (BOOL)hasCamera ;
+ (BOOL)hasFrontFacingCamera ;
+ (BOOL)canRecordVideo ;
+ (BOOL)hasRearFlashLight ;

// needs the CoreLocation framework
+ (BOOL)hasCompass ;

// needs the CoreMotion framework
+ (BOOL)hasGyroscope ;


@end
