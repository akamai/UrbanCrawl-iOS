/*!
   @header AkaWebAccelerator.h

   @brief Import this header file for accessing MAP SDK APIs.

   @copyright (c)2015,2016,2017 Akamai Technologies, Inc. All Rights Reserved. Reproduction in whole or in part in any form or medium without express written permission is prohibited.
 */

#ifndef VocSdk_AkaWebAccelerator_h
#define VocSdk_AkaWebAccelerator_h

#import <VocSdk/VocSdkBase.h>
#import <VocSdk/VocService.h>

@protocol AkaWebAccelerator;
@class VocServiceFactory;


/*!
   @category VocServiceFactory (AkaWebAccelerator)

   @brief It is a category of VocServiceFactory with MAP SDK specific APIs.

   @see VocServiceFactory
 */
@interface VocServiceFactory (AkaWebAccelerator)

/*!
   @brief Creates instance of web accelerator.

   @discussion This factory method creates instance of web accelerator. A delegate implementing VocServiceDelegate protocol and delegate queue are required. In most cases the delegate queue will be the main app queue, however there is no restriction what type of queue to use. If the queue is not serial then users of Voc SDK must ensure voc item objects are accessed serially since they are not thread safe.

   @param delegate The delegate for VocService.
   @param delegateQueue The queue on which the delegate calls will be invoked, item set delegate calls are also invoked on this queue.
   @param options (optional) The options to configure VocService.
   @param error This parameter has the error information if VocService instance cannot be created.
 */
+ (nullable id<AkaWebAccelerator>)createAkaWebAcceleratorWithDelegate:(nonnull id<VocServiceDelegate>) delegate
														delegateQueue:(nonnull NSOperationQueue *) delegateQueue
															  options:(nullable NSDictionary *) options
																error:(NSError * __nullable __autoreleasing * __nullable) error;

/*!
   @brief Sets up NSURLSession configurations to pass requests through the SDK's URL handler.

   @param sessionConfig Instance of NSURLSessionConfiguration.
 */
+ (void) setupSessionConfiguration:(nonnull NSURLSessionConfiguration *)sessionConfig;

@end


/*!
   @protocol AkaWebAccelerator.

   @brief AkaWebAccelerator Service encapsulates the Mobile Accelerator functionality provided by Voc SDK.

   @see VocService
 */
@protocol AkaWebAccelerator <VocService>

/*!
   @brief Replaces current list of segments to which user has joined. Content will be updated on next download.

   @param segments A set of segments.
 */
- (void)subscribeSegments:(nonnull NSSet <NSString *> *)segments;


//Analytics
/*!
   @brief Creates a new record of an instantaneous event. Saves a string and time stamp to analytics.

   @param eventName Name of the event.
 */
- (void)logEvent:(nonnull NSString *) eventName;

/*!
   @brief Starts recording of a timed event for analytics.

   @discussion Pair with -stopEvent: to record a string, start time, and end time.

   @param eventName Name of the event.
 */
- (void)startEvent:(nonnull NSString *) eventName;

/*!
   @brief Stops recording of a timed event for analytics.

   @discussion Pair with -startEvent: to record a string, start time, and end time.

   @param eventName Name of the event.
 */
- (void)stopEvent:(nonnull NSString *) eventName;


/*!
   @brief Enable or Disable the Debug Console.

   @param bDebugConsole If YES, enables extra information in the debug console.
 */
-(void) setDebugConsoleLog:(BOOL) bDebugConsole;

/*!
   @brief Debug API to print the Manifest Contents.
 */
-(void) printManifest;

/*!
   @brief Debug API to print the Current SDK Capabilities.
 */
-(void) printCurrentCapabilities;



//TODO: THESE APIS WILL BE REMOVED SOON. PLEASE DO NOT USE.
// Wrap AkaURLProtocol class methods for sample app
- (NSTimeInterval) timeLoadingFromCache;
- (NSTimeInterval) timeLoadingFromNetwork;
- (NSInteger) filesDownloaded;
- (NSInteger) bytesDownloaded;
- (NSInteger) filesLoadedFromCache;
- (NSInteger) bytesLoadedFromCache;
- (NSInteger) filesNotHandled;
- (nonnull NSMutableArray *) filesRequested;
- (nullable NSString *) statsConnectionType;
- (void) clearStats;

@end



#endif /* VocSdk_AkaWebAccelerator_h */
