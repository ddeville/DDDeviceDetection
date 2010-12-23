//
//  DDDeviceDetection.m
//  Device Detection
//
//  Created by Damien DeVille on 8/17/10.
//  Copyright 2010 Damien DeVille. All rights reserved.
//

#import "DDDeviceDetection.h"
#include <sys/utsname.h>
#include <sys/types.h>
#include <sys/sysctl.h>


/*
	In case you compile against an earlier version of the SDK
	it is safer to (re)define the OS version numbers.
 */

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_2_0
#define kCFCoreFoundationVersionNumber_iPhoneOS_2_0 478.23
#endif

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_2_1
#define kCFCoreFoundationVersionNumber_iPhoneOS_2_1 478.26
#endif

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_2_2
#define kCFCoreFoundationVersionNumber_iPhoneOS_2_2 478.29
#endif

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_3_0
#define kCFCoreFoundationVersionNumber_iPhoneOS_3_0 478.47
#endif

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_3_1
#define kCFCoreFoundationVersionNumber_iPhoneOS_3_1 478.52
#endif

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_3_2
#define kCFCoreFoundationVersionNumber_iPhoneOS_3_2 478.61
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_4_0
#define kCFCoreFoundationVersionNumber_iOS_4_0 550.32
#endif

/*
	the following are only defined in iOS 4.0 so it is worth
	defining them in case you do not compile with 4.0
 */
#ifndef UIImagePickerControllerCameraDeviceRear
#define UIImagePickerControllerCameraDeviceRear 0
#endif

#ifndef UIImagePickerControllerCameraDeviceFront
#define UIImagePickerControllerCameraDeviceFront 1
#endif

#ifndef kUTTypeMovie
#define kUTTypeMovie @"public.movie"
#endif

/*
	Category on UIScreen defining a scale method matching
	the scale property defined in iOS 4.0.
	This is mainly to avoid a compiler warning when building
	with an earlier version of the SDK
 */
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 40000
@interface UIScreen (ScaleFactor)
- (float)scale ;
@end
@implementation UIScreen (ScaleFactor)
- (float)scale
{
	return 1.0f ;
}
@end
#endif



@interface DDDeviceDetection (Private)

+ (NSString *)detectPlatform ;

@end














@implementation DDDeviceDetection

#pragma mark -
#pragma mark Private methods

+ (NSString *)detectPlatform
{
	size_t size ;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0) ;
	char *machine = malloc(size) ;
	sysctlbyname("hw.machine", machine, &size, NULL, 0) ;
	NSString *platform = [NSString stringWithCString: machine encoding: NSUTF8StringEncoding] ;
	free(machine) ;
	return platform ;
}







#pragma mark -
#pragma mark Return device name

+ (NSString *)returnDeviceName
{
	NSString *platform = [self detectPlatform] ;
	if ([platform isEqualToString: @"iPhone1,1"])
		return @"iPhone 1G" ;
	if ([platform isEqualToString: @"iPhone1,2"])
		return @"iPhone 3G" ;
	if ([platform isEqualToString: @"iPhone2,1"])
		return @"iPhone 3GS" ;
	if ([platform isEqualToString: @"iPhone3,1"])
		return @"iPhone 4" ;
	if ([platform isEqualToString: @"iPod1,1"])
		return @"iPod Touch 1G" ;
	if ([platform isEqualToString: @"iPod2,1"])
		return @"iPod Touch 2G" ;
	if ([platform isEqualToString: @"iPod3,1"])
		return @"iPod Touch 3G" ;
	if ([platform isEqualToString: @"iPod4,1"])
		return @"iPod Touch 4G" ;
	if ([platform isEqualToString: @"iPad1,1"])
		return @"iPad" ;
	if ([platform isEqualToString: @"i386"])
		return @"Simulator" ;
	return platform ;
}






#pragma mark -
#pragma mark Detect device type

+ (BOOL)isAniPod
{
	NSRange textRange =[[self detectPlatform] rangeOfString: @"iPod"] ;
	if(textRange.location != NSNotFound)
		return YES ;
	return NO ;
}



+ (BOOL)isAniPhone
{
	NSRange textRange =[[self detectPlatform] rangeOfString: @"iPhone"] ;
	if(textRange.location != NSNotFound)
		return YES ;
	return NO ;
}



+ (BOOL)isAniPad
{
	NSRange textRange =[[self detectPlatform] rangeOfString: @"iPad"] ;
	if(textRange.location != NSNotFound)
		return YES ;
	return NO ;
}



+ (BOOL)isSimulator
{
	NSRange textRange =[[self detectPlatform] rangeOfString: @"i386"] ;
	if(textRange.location != NSNotFound)
		return YES ;
	return NO ;
}










#pragma mark -
#pragma mark Detect OS version

+ (BOOL)isRunningiOS2
{
	if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iPhoneOS_2_0 && kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iPhoneOS_3_0)
		return YES ;
	return NO ;
}



+ (BOOL)isRunningiOS3
{
	if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iPhoneOS_3_0 && kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_4_0)
		return YES ;
	return NO ;
}



+ (BOOL)isRunningiOS4
{
	if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_4_0)
		return YES ;
	return NO ;
}











#pragma mark -
#pragma mark Detect software capabilities

+ (BOOL)isMultitaskingSupported
{
	if ([[UIDevice currentDevice] respondsToSelector: @selector(isMultitaskingSupported)])
		if ([[UIDevice currentDevice] performSelector: @selector(isMultitaskingSupported)])
			return YES ;
	return NO ;
}










#pragma mark -
#pragma mark Message capabilities

+ (BOOL)canSendEmail
{
	if ([NSClassFromString(@"MFMailComposeViewController") respondsToSelector: @selector(canSendMail)])
		if ([NSClassFromString(@"MFMailComposeViewController") performSelector: @selector(canSendMail)])
			return YES ;
	return NO ;
}



+ (BOOL)canSendSMS
{
	if ([NSClassFromString(@"MFMessageComposeViewController") respondsToSelector: @selector(canSendText)])
		if ([NSClassFromString(@"MFMessageComposeViewController") performSelector: @selector(canSendText)])
			return YES ;
	return NO ;
}








#pragma mark -
#pragma mark Audio capabilities checking

+ (BOOL)isInSilentMode
{
	/*
		NOTE: this won't work in the simulator, so we simply assume
		the simulator is never in silent mode
	 */
	if ([self isSimulator])
		return NO ;
	else
	{
		// we first check if the AudioToolbox has been correctly imported
#ifdef kAudioSessionProperty_AudioRoute
		CFStringRef state ;
		UInt32 propertySize = sizeof(CFStringRef) ;
		AudioSessionInitialize(NULL, NULL, NULL, NULL) ;
		AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &state) ;
		
		if(CFStringGetLength(state) == 0)
			return YES ;
		else
			return NO ;
#else
		NSLog(@"import the AudioToolbox if you want to test that!") ;	
#endif
	}
	return NO ;
}



+ (BOOL)hasSpeakersOn
{
	/*
		NOTE: this won't work in the simulator, so we simply assume
		the simulator always has speakers on
	 */
	if ([self isSimulator])
		return NO ;
	else
	{
		// we first check if the AudioToolbox has been correctly imported
#ifdef kAudioSessionProperty_AudioRoute
		CFStringRef state ;
		UInt32 propertySize = sizeof(CFStringRef) ;
		AudioSessionInitialize(NULL, NULL, NULL, NULL) ;
		AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &state) ;
		if (CFStringGetLength(state) == 0)
			return NO ;
		else
			if ([(NSString *)state isEqualToString: @"Speaker"])
				return YES ;
#else
		NSLog(@"import the AudioToolbox if you want to test that!") ;	
#endif
	}
	return NO ;	
}



+ (BOOL)hasHeadphonesPlugged
{
	/*
		NOTE: this won't work in the simulator, so we simply assume
		the simulator never has headphones plugged in
	 */
	if ([self isSimulator])
		return NO ;
	else
	{
		// we first check if the AudioToolbox has been correctly imported
#ifdef kAudioSessionProperty_AudioRoute
		CFStringRef state ;
		UInt32 propertySize = sizeof(CFStringRef) ;
		AudioSessionInitialize(NULL, NULL, NULL, NULL) ;
		AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &state) ;
		if (CFStringGetLength(state) == 0)
			return NO ;
		else
			if ([(NSString *)state isEqualToString: @"Headphone"])
				return YES ;
#else
		NSLog(@"import the AudioToolbox if you want to test that!") ;	
#endif
	}
	return NO ;
}









#pragma mark -
#pragma mark Detect hardware capabilities

+ (BOOL)hasRetinaDisplay
{
	if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)] && [[UIScreen mainScreen] scale] == 2.0f)
		return YES ;
	return NO ;
}



+ (BOOL)hasCamera
{
	if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
		return YES ;
	return NO ;
}



+ (BOOL)canRecordVideo
{
	if ([UIImagePickerController respondsToSelector: @selector(availableMediaTypesForSourceType:)])
	{
		NSArray *mediaType = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera] ;
		if ([mediaType containsObject: kUTTypeMovie])
			return YES ;
	}
	return NO ;
}



+ (BOOL)hasFrontFacingCamera
{
	if ([UIImagePickerController respondsToSelector: @selector(isCameraDeviceAvailable:)])
		if ([UIImagePickerController performSelector: @selector(isCameraDeviceAvailable:) withObject: (id)UIImagePickerControllerCameraDeviceFront])
			return YES ;
	return NO ;
}



+ (BOOL)hasRearFlashLight
{
	if ([UIImagePickerController respondsToSelector: @selector(isFlashAvailableForCameraDevice:)])
		if ([UIImagePickerController performSelector: @selector(isFlashAvailableForCameraDevice:) withObject: (id)UIImagePickerControllerCameraDeviceRear])
			return YES ;
	return NO ;
}



+ (BOOL)hasCompass
{
	if ([NSClassFromString(@"CLLocationManager") respondsToSelector: @selector(headingAvailable)])
	{
		// in iOS 4.0, headingAvailable is a class method
		if ([NSClassFromString(@"CLLocationManager") performSelector: @selector(headingAvailable)])
			return YES ;
	}
	else
	{
		// prior to iOS 4.0, headingAvailable is a property (deprecated in iOS 4.0)
		id coreLocationManager = [[[NSClassFromString(@"CLLocationManager") alloc] init] autorelease] ;
		if ([coreLocationManager respondsToSelector: @selector(headingAvailable)])
			return YES ;
	}
	return NO ;
}



+ (BOOL)hasGyroscope
{
	// we first check whether the CoreMotion manager class is defined
	if (NSClassFromString(@"CMMotionManager") == nil)
		return NO ;
	// if it is defined (iOS >= 4.0), we check if the device has the gyroscope
	id coreMotionManager = [[[NSClassFromString(@"CMMotionManager") alloc] init] autorelease] ;
	if ([coreMotionManager performSelector: @selector(isGyroAvailable)])
		return YES ;
	return NO ;
}


@end
