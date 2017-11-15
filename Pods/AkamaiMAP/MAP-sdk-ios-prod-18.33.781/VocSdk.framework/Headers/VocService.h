/*!
 @header VocService.h

 @brief Header file where SDK registration, service initialization and other primary SDK functionalies are defined.

 @copyright (c)2015,2016,2017 Akamai Technologies, Inc. All Rights Reserved. Reproduction in whole or in part in any form or medium without express written permission is prohibited.
*/


#ifndef VocSdk_VocService_h
#define VocSdk_VocService_h

#import <VocSdk/VocSdkBase.h>

@class VocServiceFactory;
@class VocObjFilter;
@class VocItemFilter;
@class VocVideoFilter;
@class VocItemCategoryFilter;
@class VocItemSourceFilter;
@class VocImportInfo;

@protocol VocConfig;
@protocol VocItem;
@protocol VocFile;
@protocol VocItemCategory;
@protocol VocItemSource;
@protocol VocItemDASHVideo;
@protocol VocItemSet;
@protocol VocVideoSet;
@protocol VocCategorySet;
@protocol VocSourceSet;
@protocol VocObjSet;
@protocol VocNetworkQuality;
@protocol VocService;
@protocol VocServiceDelegate;
@protocol VocDataQuery;

/*!
   @interface VocServiceFactory

   @brief Factory for VocService.

   @discussion VocServiceFactory is used to create instance of VocService.   For more details on how VocService works and how to create it see VocService.

   @see VocService
 */
@interface VocServiceFactory : NSObject

/*!
   @brief Factory method for VocService.

   @discussion This factory method creates instance of VocService. A delegate implementing VocServiceDelegate protocol and delegate queue are required. In most cases the delegate queue will be the main app queue, however there is no restriction what type of queue to use. If the queue is not serial then users of Voc SDK must ensure voc item objects are accessed serially since they are not thread safe. One such way to achieve that would be to add a lock object of some kind to voc item userInfo and use it to serialize access.

   @param delegate The delegate for VocService.
   @param delegateQueue The queue on which the delegate calls will be invoked, item set delegate calls are also invoked on this queue.
   @param options (optional) The options to configure VocService.
   @param error This parameter has the error information if web accelerator instance cannot be created.

   @return VocService The instance of VocService.
 */
+ (nullable id<VocService>)createServiceWithDelegate:(nonnull id<VocServiceDelegate>) delegate
												   delegateQueue:(nonnull NSOperationQueue *) delegateQueue
														 options:(nullable NSDictionary *) options
														   error:(NSError * __nullable __autoreleasing * __nullable) error;

/*! @brief init is disabled for VocServiceFactory. */
- (nullable instancetype)init NS_UNAVAILABLE;

@end





/*!
   @protocol VocService

   @brief VocService encapsulates the functionality provided by Voc SDK.

   @discussion VocService instance is created through VocServiceFactory.
   To create the service, a delegate implementing VocServiceDelegate protocol and delegate queue are required. In most cases the delegate queue will be the main app queue, however there is no restriction what type of queue to use. If the queue is not serial then users of Voc SDK must ensure voc item objects are accessed serially since they are not thread safe. One such way to achieve that would be to add a lock object of some kind to voc item userInfo and use it to serialize access.

   VocService state is available through VocService.state property. Initially VocService is in VOCServiceStateNotRegistered state until it is successfully registered with VoC server. To register call [VocService registerService].

   VocService might become unregistered and return to VOCServiceStateNotRegistered state if the user is deleted from server or some time has passed since SDK could connect to VoC server.

   @see VocServiceFactory
 */
@protocol VocService <NSObject, VocDataQuery>


/*! @brief The current state of voc service. */
@property (readonly,assign,nonatomic)			VOCServiceState		state;

/*! @brief Provides access to various configations properties of voc service. */
@property (readonly,nonnull,strong,nonatomic)	id<VocConfig>		config;

/*! @brief Gives the current network connection type and if there is one at all. */
@property (readonly,assign,nonatomic)			VOCConnectionType	connectionType;

/*! @brief Shows if voc service policies allow downloads at the moment. */
@property (readonly,assign,nonatomic)			BOOL				downloadAllowed;

/*! @brief Access the last policy status of voc service. */
@property (readonly, assign, nonatomic)			VOCPolicyStatus		lastPolicyStatus;


#pragma mark -- registration --

/*!
   @brief Registers SDK with Voc server.

   @param sdkLicense The license key provided by Akamai.
   @param segments   The segments that client wants to subscribe.
   @param completion The completion block that executes after registration.
 */
- (void)registerWithLicense:(nonnull NSString *)sdkLicense
					segments:(nullable NSArray *)segments
				 completion:(nullable void (^)(NSError * __nullable))completion VOCSDK_DEPRECATED;

/*!
   @brief Registers SDK with Voc server.

   @param sdkLicense The license key provided by Akamai.
   @param user The user id for the registration.
   @param segments   The segments that client wants to subscribe.
   @param completion The completion block that executes after registration.
 */
- (void)registerWithLicense:(nonnull NSString *)sdkLicense
                       user:(nullable NSString *)user
                   segments:(nullable NSArray *)segments
                 completion:(nullable void (^)(NSError * __nullable))completion VOCSDK_DEPRECATED;

/*!
   @brief Unregisters voc service with Voc server and stops downloading.
 */
- (void)unregisterService:(nullable void (^)(NSError *   __nullable))completion;





#pragma mark -- downloads --
/*! @brief The last time download had started. */
@property (readonly,nullable,strong,atomic)  NSDate*  latestFetchStart;

/*!
   @brief Start/Resume downloading a collection of items.

   @description Provides consumer of SDK to starts downloading an item. Also, the same API is used for resume downloading of previously downloading items. Items should have eligible download behavior so that the SDK can download the items.

   @param vocItems An array of VocItem instances that needs to be downloaded.
   @param completion Completion block executes after initiating download of content items. If the API fails to initiate a download, the completion block returns a non-nil error.
 */
- (void)downloadItems:(nonnull NSArray*  )vocItems
		   completion:(nullable void (^)(NSError * __nullable))completion;

/*!
   @brief Start/Resume downloading a collection of items based on options.

   @param vocItems An array of VocItem instances that needs to be downloaded. Item associated with the URL should have eligible download behavior so that the SDK can download the item.
   @param options A dictionary of options to apply on the item downloads. The dictionary contains one or more of the following options: @"downloadBehavior"  :   valid values are @(VOCItemDownloadFullAuto), @(VOCItemDownloadThumbnailOnly), or @(VOCItemDownloadNone)                  @"videoPartialDownloadLength":   how much of an HLS video to download. Valid values are 0 to 32767 seconds (0 meaning all) nil can be passed when no options need changing.
   @param completion Completion block executes after initiating download of content items. If the API fails to initiate a download, the completion block returns a non-nil error.

   @see VOCItemDownloadBehavior VocConfig::itemDownloadBehavior VocItem::downloadBehavior
 */
- (void)downloadItems:(nonnull NSArray*  )vocItems
			  options:(nullable NSDictionary*)options
		   completion:(nullable void (^)(NSError * __nullable))completion;

/*!
   @brief Start downloading an item based on URL.

   @discussion This API method returns an absolute path of the downloaded item and the error if any. This method is asynchronous and completion block will be invoked on delegate queue. This method is safe to be called on any thread. Item associated with the URL should have eligible download behavior so that the SDK can download the item.

   @param url is the string URL of the content to be downloaded.
   @param completion Completion block executes after downloading the content item. If the API fails to initiate a download, the completion block returns a non-nil error. If item gets downloaded, the downloadedPath will be the local absolute path where the client can access the content.

   @see VOCItemDownloadBehavior VocConfig::itemDownloadBehavior VocItem::downloadBehavior
 */
- (void)downloadItemWithURL:(nonnull NSString *) url
				 completion:(nullable void (^)(NSError * __nullable error,
											   NSString * __nullable downloadedPath))completion;

/*!
   @brief Pause download of the given item.

   @param item The item whose download needs to be paused.
   @param completion Completion block executes after pausing the download of given content item. If the API fails to pause the download, the completion block returns a non-nil error.
 */
- (void)pauseItemDownload:(nonnull id<VocItem>)item
			   completion:(nullable void (^)(NSError * __nullable))completion;

/*!
   @brief Pause download of a collection of items.

   @param vocItems is an array of VocItem.
   @param completion Completion block executes after pausing the download of given content items. If the API fails to pause the downloads, the completion block returns a non-nil error.
 */
- (void)pauseDownloadForItems:(nonnull NSSet*  )vocItems
				   completion:(nullable void (^)(NSError * __nullable))completion;

/*!
   @brief Initiates download of all the eligible VocItem(eligibility is based on download behavior of the item).

   @param completion Completion block executes after the download is started. If the API fails to initiate the download, the completion block returns a non-nil error.

   @see VOCItemDownloadBehavior VocConfig::itemDownloadBehavior VocItem::downloadBehavior
 */
- (void)startDownloadUserInitiatedWithCompletion:(nullable void (^)(NSError * __nullable))completion;

/*!
   @brief Cancels all the downloads.

   @param completion Completion block executes after the download is cancelled. If the API fails to cancel the download, the completion block returns a non-nil error.
 */
- (void)cancelCurrentDownloadWithCompletion:(nullable void (^)(NSError * __nullable))completion;


#pragma mark -- cache --
/*! @brief Size of the cache for downloaded files (bytes). */
@property (readwrite,assign,nonatomic)  uint64_t cacheSize;

/*! @brief The amount of storage used for downloaded files (bytes). */
@property (readonly,assign,nonatomic)   uint64_t cacheUsed;

/*! @brief The remaining storage available for downloaded files (bytes). This is the smaller values of the unused cache and the space available on device. */
@property (readonly,assign,nonatomic)   uint64_t cacheAvailable;


#pragma mark -- delete --

/*!
  @brief Removes all the downloaded files from device.

  @param completion Completion block executes after the cache is cleared. If the API fails to clear the cache, the completion block returns a non-nil error.
 */
- (void)clearCache:(nullable void (^)(NSError *   __nullable))completion;

/*!
   @brief Deletes a collection of items.

   @discussion Deletes the content in the file system but not the metadata. Items will be deleted according to options.

   @param vocItems is an array of VocItem
   @param options is a dictionary of options to apply to the items. The dictionary contains the below option: @"deleteThumbnail": It expects a value of type BOOL and default value is YES. If NO, delete all files associated with the item except thumbnail. This value is applied to entire collection of items.
 */
- (void)deleteFilesForItems:(nonnull NSSet *)vocItems
					options:(nullable NSDictionary*)options
				 completion:(nullable void (^)(NSError *   __nullable))completion;

/*!
   @brief Remove all the sources by name.

   @param args It is an array of name property of VocItemSource.
 */
- (void) purgeProviders:(nonnull NSArray*)args;



#pragma mark -- push notifications --
/*! @brief Apple Push Notification service(APNS) push token in readable format (read-only). */
@property (readonly,nullable,strong,atomic) NSString  *devicePushTokenString;

/*!
   @brief Must be set to the device APNS push token in order push notifications to work.

   @param devicePushToken It is the APNS push token.
 */
- (void)setDevicePushToken:(NSData * __nullable)devicePushToken;


#pragma  mark -- HLS Server --
/*! @brief Indicates if HLS server is running. */
@property (readonly,assign,nonatomic)	BOOL	hlsServerRunning;

/*! @brief If HLS server is running provides the url for accessing the server, if server is not running returns nil. */
@property (readonly,nullable,nonatomic)	NSURL	*hlsServerUrl;

/*!
   @brief Starts HLS server for HLS playback, execution completion block when HLS server has started.

   @discussion In addition to the completion here (that can be nil), VocServiceDelegate -hlsServerStarted:
   is invoked if the server was started. If the server did not start the delegate callback will not be
   invoked.

   @param completion Completion block executes after the HLS server is started. If the API fails to clear the cache, the completion block returns a non-nil error.
 */
- (void) startHLSServerWithCompletion:(nullable void(^)(BOOL success))completion;

/*!
   @brief Stops HLS server if it is running. Ignore if the hls server is not running.

   @discussion After the server has stopped VocServiceDelegate -hlsServerStopped: is invoked.
 */
- (void) stopHLSServer;


#pragma  mark -- Migration --

/*!
   @brief Imports the pre-existing fully or partially cached content in the client application into VocSDK.

  @discussion For fully cached item, the API imports both the file and metadata. For partially cached item, the API imports only the metadata.

   @param info The minimum number of information required to import the content to VocSDK passed
   as key value pairs. keys: VocImportFileMetadataContentId, VocImportFileMetadataProvider, VocImportFileMetadataFilePath, VocImportFileMetadataDuration, VocImportFileMetadataSize, VocImportFileMetadataContentType, VocImportFileMetadataContentUrl, VocImportFileMetadataTimeStamp, VocImportFileMetadataTitle, VocImportFileMetadataSummary, VocImportFileMetadataThumbFile, VocImportFileMetadataSDKPassthroughInfo, VocImportFileDownloadStatus, VocImportFileMetadataDownloadFinishedTime. For cached contents: The above provided key/value in info dictionary are required/optional as per their definition. For partially downloaded contents: VocImportFileMetadataFilePath, VocImportFileMetadataThumbFile values needs to be EXCLUDED from the info parameter.
   @param completion Completion block executes after the HLS server is started. If the API fails to clear the cache, the completion block returns a non-nil error.
 
    This method deprecated.
    Use  VocService::addNewContent:completion:
    for availing the same functionality in future.
 */
-(void)addDownloadedItem:(nonnull NSDictionary*)info
              completion:(nullable void (^)(NSError * _Nullable, id<VocItem>  _Nullable vocItem))completion VOCSDK_DEPRECATED;

/*!
 @brief Imports the pre-existing fully or partially cached content in the client application into VocSDK.

 @discussion For fully cached item, the API imports both the file and metadata. 
    For partially cached item, the API imports only the metadata.
    This API can be used to initiate download for a new content by importing the metadata.
*/
-(void)addNewContent:(nonnull VocImportInfo*)migrationInfo
              completion:(nullable void (^)(NSError * _Nullable, id<VocItem>  _Nullable vocItem))completion;

/*!
    @brief Downloads the content associated with the given contentIds and provider.

    @discussion The API downloads the content once content metadata is available locally. This API also allows to schedule a later metdata sync and item download. Item which already exist locally cannot be assigned for download later.  
 
    @param options A dictionary of options to apply on the item downloads. The dictionary contains one or more of the following options: @"downloadBehavior"  :   valid values are @(VOCItemDownloadFullAuto), @(VOCItemDownloadThumbnailOnly), or @(VOCItemDownloadNone)                  @"videoPartialDownloadLength":   how much of an HLS video to download. Valid values are 0 to 32767 seconds (0 meaning all) nil can be passed when no options need changing. @"downloadLater": YES, if it is marked for later download. @"availableTimeStamp": The UTC time stamp at which the item is available for download.
        @"quality": The quality requested for downloading. The default value is VOCQualitySelectionSdkBehavior. @"contentType": The type of content requested (Refer VOCItemTypeEnum). The default value is VOCItemTypeVideo. 
 */
-(void)downloadItemsWithContentIds:(nonnull NSArray*)contentIds provider:(nonnull NSString*)provider options:(nullable NSDictionary*)options completion:(nullable void (^)(NSError*_Nullable))completion;

#pragma mark -- UIApplicationDelegate --

/*!
   @brief Must be invoked when remote notification is received to let Voc SDK process it.

   @param application Singleton app object.
   @param completionHandler will be called only if the remote notification was for voc service (the method returned YES). Sometimes it might be called before this method returns. If this method returns NO the app will have to call the completionHandler received from iOS.
   @param userInfo This is obtained from UIApplicationDelegate::didReceiveRemoteNotification:fetchCompletionHandler: and passed into this method. It is a dictionary that contains information related to the remote notification, potentially including a badge number for the app icon, an alert sound, an alert message to display to the user, a notification identifier, and custom data.

   @return Will return YES if the remote notification is for voc service, otherwise NO.
 */
- (BOOL)application:(nonnull UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo
																fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult result))completionHandler;

/*!
   @brief Must be invoked when OS wakes up app in background to perform fetch.

    @param application Singleton app object.
    @param completionHandler Gets called if voc service performs operation in the background otherwise completionHandler will not be called by voc service - the app will have to call it when it is done. If the app wants to perform operations in background it will have to give voc service a different completionHandler not the one it received. The app should call the original completionHandler only after both it is done and the compeltionHandler it gave to voc service is invoked.

   @return Will return YES if voc service performs operations in background.
 */
- (BOOL)application:(nonnull UIApplication *)application performFetchWithCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult result))completionHandler;


#pragma mark -- others --
/*! @brief List of SDK log files. */
@property (readonly,nullable,strong,atomic) NSArray*  sortedLogFilePaths;

/*!
   @brief Record user search queries to get better prediction results.

   @param searchQuery A string that user has used for searching content. This can be used by server for prediction.
   @param timeStamp The time and date on which this search was performed.
 */
- (void)addPredictionHint:(nonnull NSString*)searchQuery startTime:(nonnull NSDate*) timeStamp;

/*!
   @brief Gets the current network quality.
 */
- (nullable id<VocNetworkQuality>) networkQuality;

@end


/*!
   @protocol VocServiceDelegate

   @brief Interface for VocService delegate.

   @discussion VocServiceDelegate provides various methods to notify of various changes in VocService. All method calls happen on delegate queue.

   @see VocService
 */
@protocol VocServiceDelegate <NSObject>

@optional

/*!
   @brief Invoked when VocService transtions to not registered state.

   @discussion This is not called initially when the service is started in not registered state. When the service is in registered state it may be notified by Voc server that the user is no longer valid user and then VocService will transition to not registered state and invoke this method.

   @see VocService
 */
- (void) vocService:(nonnull id<VocService>)vocService didBecomeNotRegistered:(nonnull NSDictionary *)info;


/*!
   @brief Invoked when VocService registerWithLicense: is called and registering fails.

   @discussion Registration can fail for various reasons, like not network or bad license, etc. When this happens the completion passed in registerWithLicense: will be called and after that this delegate method will be called.

   @param vocService An instance of VocService.
   @param error Error details for registration failure.

   @see VocService
 */
- (void) vocService:(nonnull id<VocService>)vocService didFailToRegister:(nonnull NSError *)error;


/*!
   @brief Invoked when VocService registerWithLicense: is called and registration succeeds.

   @discussion When registration succeeds the completion passed in registerWithLicense: will be called and after that this delegate method will be called.

   @param vocService An instance of VocService.
   @param info More information on successful registration.

   @see VocService
 */
- (void) vocService:(nonnull id<VocService>)vocService didRegister:(nonnull NSDictionary*  )info;


/*!
   @brief Invoked when VocService has finished initialization.

   @discussion This delegate method will be called when the VocService has finished initialization. This indicates the SDK is ready for processing requests.

   @param vocService An instance of VocService.
   @param info More information on successful registration.

   @see VocService
 */
- (void) vocService:(nonnull id<VocService>)vocService didInitialize:(nonnull NSDictionary *)info;


/*!
   @brief Invoked when VocService learns about new items that can be cached.

   @discussion When VocService learns about new items that can be downloaded and cached this method will be called.

   @param vocService An instance of VocService.
   @param items Items that got newly discovered.

   @see VocService VOCItemDiscovered
 */
- (void) vocService:(nonnull id<VocService>)vocService itemsDiscovered:(nonnull NSArray *)items;


/*!
   @brief Invoked when VocService starts downloading items.

   @discussion When VocService starts downloading items this method will be called.

   @param vocService An instance of VocService.
   @param items Items that got started downloading.

   @see VocService VOCItemDownloading
 */
- (void) vocService:(nonnull id<VocService>)vocService itemsStartDownloading:(nonnull NSArray *)items;


/*!
   @brief Invoked when VocService successfully downloads items.

   @discussion When VocService successfully downloads items this method will be called.

   @param vocService An instance of VocService.
   @param items Items that got cached.

   @see VocService VOCItemCached
 */
- (void) vocService:(nonnull id<VocService>)vocService itemsDownloaded:(nonnull NSArray *)items;


/*!
   @brief This method will be invoked to signal that items will be removed from cache.

   @discussion Eviction cannot be cancelled. VOC SDK will not evict/remove an item until after the return from this call. Before returning make sure that there are no outstanding references to items listed here.

   @param vocService An instance of VocService.
   @param items Items that got deleted.

   @see VocService VOCItemDeleted
 */
- (void) vocService:(nonnull id<VocService>)vocService itemsEvicted:(nonnull NSArray *)items;


/*!
   @brief This method will be invoked to signal a change in network quality.

   @discussion This method will receive the results of the latest network quality check.

   @param vocService An instance of VocService.
   @param networkQuality An instance of VocNetworkQuality.
 */
- (void) vocService:(nonnull id<VocService>)vocService networkQualityUpdate:(nonnull id<VocNetworkQuality>)networkQuality;

/*!
   @brief This method will be invoked when a file is ready for download and
            the client can modify the download URL request of the file.

   @param request NSMutableURLRequest of VocFile that is ready for downloading
   @param item VocFile that is requested for downloading is associated with this item
   @param file VocFile that is requested for downloading
   @param completion completion handler to be invoked when the request is converted, if the download should not proceed pass nil to completion handler.

   @example Download URL request of file can be authenticated by the delegate handler by various token authentication methods such as appending the token in URL query string parameter, adding the token as cookie etc.
 */
- (void) vocService:(nonnull id<VocService>)vocService convertDownloadRequest:(nonnull NSMutableURLRequest*) request
			   item:(nonnull id<VocItem>)item
			   file:(nonnull id<VocFile>)file
		 completion:(nonnull void (^)(NSMutableURLRequest* __nullable request))completion;


/*!
   @brief This method will be invoked when a DRM file has completely been downloaded and the client can decide if the rest of the HLS file has to be downloaded or not.

   @param vocService An instance of VocService.
   @param file DRM VocFile that is completely downloaded
   @param completion handler to be invoked with a BOOL value suggesting to
   continue the download for the specific HLS file.
 */
- (void) vocService:(nonnull id<VocService>)vocService downloadCompletedForDRMFile:(nonnull id<VocFile>)file
		 completion:(nonnull void (^)(BOOL shouldContinueDownload))completion;


/*!
   @brief This method will be invoked when the HLS server (re)starts.

   @discussion This is invoked in response to -startHLSServerWithCompletion or but can also happen if the HLS server is left running and the app transitions in background and then to foreground. When the app enters background the HLS server will stop after some time and will restart after the application enters foreground.

   @param vocService the vocService instance
   @param url the url of the HLS server
 */
- (void) vocService:(nonnull id<VocService>)vocService hlsServerStarted:(nonnull NSURL*)url;

/*!
   @brief This method will be invoked when the HLS server stops.

   @discussion This is invoked in response to -stopHLSServer but also can happen if the HLS server is left running and the app transitions in background and then to foreground. When the app enters background the HLS server will stop after some time and will restart after the application enters foreground.

   @param vocService the vocService instance
   @param url the url of the HLS server
 */
- (void) vocService:(nonnull id<VocService>)vocService hlsServerStopped:(nonnull NSURL*)url;

@end


/*!
   @protocol VocNetworkQuality

   @brief Interface for network quality

   @discussion VocNetworkQuality encapsulates the network quality properties.

   @see VocService
 */
@protocol VocNetworkQuality <NSObject>

/*! @brief The latest network quality status. */
@property (readonly, assign, nonatomic) VocNetworkQualityStatus qualityStatus;

/*! @brief Time stamp of the latest network quality measurement. */
@property (readonly, nonnull, strong, nonatomic) NSDate *timeStamp;

@end

#endif
