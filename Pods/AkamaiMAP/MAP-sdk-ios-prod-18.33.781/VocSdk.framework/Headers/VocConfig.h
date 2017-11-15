/*!
   @header VocConfig.h

   @brief Header file where SDK configurations are handled.

   @copyright (c)2015,2016,2017 Akamai Technologies, Inc. All Rights Reserved. Reproduction in whole or in part in any form or medium without express written permission is prohibited.
 */

#ifndef VocSdk_VocConfig_h
#define VocSdk_VocConfig_h

#import <VocSdk/VocSdkBase.h>


/*!
   @protocol VocConfig

   @brief Voc service configuration.
 */
@protocol VocConfig <NSObject>

/*! @brief The license provided through configuration or registration API. */
@property (readonly,nullable,atomic)		NSString				*license;

/*! @brief Unique id for voc service assigned during registration. */
@property (readonly,nullable,atomic)		NSString				*vocId;

/*!
    @brief Upon user/sdk registration, the registration request will be sent to lookup server to identify the server host that manages the account.

    @discussion This configuration holds the effective setting for voc lookup server. It returns lookupServerHostOverride if set, else it returns lookupServerHostDefault.
 */
@property (readonly,nonnull,nonatomic)		NSURL					*lookupServerHost;

/*!
   @brief Setting for voc lookup server that overrides the default.

   @discussion It is usually nil but during testing can be used to point to dev/qa servers.
 */
@property (readwrite,nullable,atomic)		NSURL					*lookupServerHostOverride;

/*! @brief The default setting for voc lookup server. */
@property (readonly,nonnull,nonatomic)		NSURL					*lookupServerHostDefault;

/*!
   @brief Serverhost is the one that manages the content on the device.

   @discussion This configuration holds the  effective setting for voc server. It returns serverHostOverride if set, else it returns serverHostFromLookup.
 */
@property (readonly,nonnull,nonatomic)		NSURL					*serverHost;

/*!
   @brief Setting for voc server that overrides the value from lookup.

   @discussion It is usually nil but during testing can be used to point to dev/qa servers.
 */
@property (readwrite,nullable,atomic)		NSURL					*serverHostOverride;

/*! @brief The voc server setting obtained from voc lookup. */
@property (readonly,nonnull,atomic)			NSURL					*serverHostFromLookup;

/*! @brief Whether or not server registration happens on first download */
@property (readonly, atomic)				BOOL					 delayedRegistration;

/*!
   @brief Downloads will not occur if battery level is below this limit.

   @discussion The value is from 0 to 100. Default is 0.
 */
@property (readwrite,assign,nonatomic)		int16_t					lowBatteryLimit;

/*!
   @brief Files larger than this value will not be downloaded.

   @discussion Default value is 104 MB.
 */
@property (readwrite,assign,atomic)			int64_t					fileSizeMax;

/*!
   @brief Controls how broad the delivered content relevance should be.

   @discussion Default value is VOCContentRelevanceBroad.
 */
@property (readwrite,assign,nonatomic)		VOCContentRelevance		userContentRelevance;

/*!
   @brief Access this configuration to know if downloads happen on wifi only, wifi and cellular or can be disabled all together.
   @discussion Default value is VOCNetworkSelectionWifiAndCellular and server configuration could override it.
 */
@property (readonly,assign,nonatomic)		VOCNetworkSelection		networkSelection;

/*!
 @brief Allows client to controls if download needs to happen on wifi only, wifi and cellular or can be disabled all together.
 @discussion Default value is VOCNetworkSelectionInvalid and it is a value used internally. SDK discourages client to set VOCNetworkSelectionInvalid value.
 */
@property (readwrite,assign,nonatomic)		VOCNetworkSelection		networkSelectionOverride;

/*!
 @brief Access this configuration to know what is the server network preference for download.
 */
@property (readonly,assign,nonatomic)		VOCNetworkSelection		networkSelectionDefault;

/*!
   @brief Daily wifi quota.

   @discussion VOCDownloadQuotaUnlimited for no limit. The default is unlimited and server configuration could override it.
 */
@property (readonly,assign,atomic)			int64_t					dailyWifiQuota;

/*!
   @brief Daily cellular quota.

   @discussion VOCDownloadQuotaUnlimited for no limit. The default is unlimited and server configuration could override it.
 */
@property (readonly,assign,atomic)			int64_t					dailyCellularQuota;

/*!
   @brief Daily wifi data used.

   @discussion Resets to 0 at 00:00.
 */
@property (readonly,assign,atomic)			int64_t					dailyWifiUsed;

/*!
   @brief Daily cellular data used.

   @discussion Resets to 0 at 00:00.
 */
@property (readonly,assign,atomic)			int64_t					dailyCellularUsed;

/*! @brief The sum of dailyWifiUsed and dailyCellularUsed. */
@property (readonly,assign,atomic)			int64_t					dailyDownloadUsed;

/*!
   @brief The requested video quality.

   @discussion The value range is from 0 to 10 and default value is 5. The server configuration could override it.
 */
@property (readwrite,assign,nonatomic)		NSInteger				videoQuality;

/*!
   @brief Tells voc server to use production APNS (Apple Push Notification Service) environment.

   @discussion By default the value is YES. It takes effect during registration so it has to be set before registering. Changes after registering have no effect.
 */
@property (readwrite,assign,nonatomic)		BOOL					useProductionApns;

/*!
   @brief This configuration will drive the download behavior of sdk provided the item download
   behavior is set to VOCItemDownloadSdkBehavior.

   @discussion Default behavior is download all files associated with the item automatically. Individual item can override this behavior. See VocItem::downloadBehavior VOCItemDownloadSdkBehavior is an invalid value for this config.
 */
@property (readwrite,assign,nonatomic)		VOCItemDownloadBehavior	itemDownloadBehavior;

/*!
   @brief If YES, triggers SDK purge mechanism when needed.

   @discussion By default voc service automatically manages the cache.It removes the old content from DB and its associated files from cache folder. This can be disabled and managed by SDK customer by setting this property to NO.
 */
@property (readwrite,assign,nonatomic)		BOOL					enableAutoPurge;

/*!
   @brief If YES, downloads are only allowed when charging.

   @discussion Default value is NO.
 */
@property (readwrite,assign, nonatomic)		BOOL					downloadOnlyWhenCharging;

/*!
   @brief Limits the number of concurrent downloads, -1 no limit.

   @discussion Default value is -1.
 */
@property (readwrite,assign, nonatomic)		int						maxConcurrentDownloads;

/*!
   @brief If set as NO, VocService::bytesDownloaded wont be updated.

   @discussion During download bytesDownloaded is updated every time a chunk of data is downloaded.However sometimes if download is interrupted it cannot be resumed and bytesDownloaded will reset to 0. This might not be desired behavior and can be changed by setting this property to NO. When this property is set to NO bytesDownloaded is not updated until after the file is fully downloaded. Default value is YES.
 */
@property (readwrite,assign,nonatomic)		BOOL					trackFileDownloadProgress;

/*!
 @brief if Yes, user download request will start immediately and does not respect device policies.

 @discussion Default value is NO.
 */
@property (readwrite,assign,nonatomic)		BOOL					forceDownload;

/*!
 @brief Limits the number of downloads that are scheduled later, -1 no limit.

 @discussion Default value is 1000.
 */
@property (readwrite,assign,nonatomic)		int						maxLaterDownloads;

/*!
 @brief Expiry window for later downloads. The item gets removed once expired. The unit is in seconds.

 @discussion Default value is 1209600 seconds(2 weeks).
 */
@property (readwrite,assign,nonatomic)		NSTimeInterval						expiryWindowForLaterDownloads;

@end

#endif
