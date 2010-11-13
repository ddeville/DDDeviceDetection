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
	message capabilities and don't want to import the MessageUI framework
 */
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30000
#import <MessageUI/MessageUI.h>
#endif

/*
	Feel free to comment the following import if you don't need to test
	gyroscope capabilities and don't want to import the CoreMotion framework
 */
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
#import <CoreMotion/CoreMotion.h>
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

// message capabilities
+ (BOOL)canSendEmail ;
+ (BOOL)canSendSMS ;

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
