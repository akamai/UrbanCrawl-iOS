/*!
   @header VocSdkBase.h

   @brief Header file that defines the common parts that relate to all aspects of the SDK.

   @copyright (c)2015,2016,2017 Akamai Technologies, Inc. All Rights Reserved. Reproduction in whole or in part in any form or medium without express written permission is prohibited.
 */


#ifndef VocSdk_VocSdkBase_h
#define VocSdk_VocSdkBase_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#if !defined(VOCSDK_EXPORT)

	#if defined(__cplusplus)
		#define VOCSDK_EXPORT	extern "C"
	#else
		#define VOCSDK_EXPORT	extern
	#endif

#endif

#pragma mark -- Version --
/*!
   @brief Voc SDK major build number constant.
 */
VOCSDK_EXPORT const int VocSdkVersionMajor;

/*!
   @brief Voc SDK minor build number constant.
 */
VOCSDK_EXPORT const int VocSdkVersionMinor;

/*!
   @brief Voc SDK release build number constant.
 */

VOCSDK_EXPORT const int VocSdkVersionBuild;

/*!
   @brief Voc SDK build number string constant.
 */
VOCSDK_EXPORT const unsigned char VocSdkVersionString[];



#pragma mark -- Logging --
/*!
   @enum LOG_LEVEL
   @brief A list of log level customer can set.

   @constant VOCSDK_DIAG_LOG_LEVEL_NONE Prints nothing.
   @constant VOCSDK_DIAG_LOG_LEVEL_LOW Prints Errors.
   @constant VOCSDK_DIAG_LOG_LEVEL_HIGH Prints Errors and Warnings.
 */
enum : int
{
	VOCSDK_DIAG_LOG_LEVEL_NONE			= 0,

	VOCSDK_DIAG_LOG_LEVEL_LOW			= 5,

	VOCSDK_DIAG_LOG_LEVEL_HIGH			= 10
};

/*!
   @brief Get the current diagnostic logging level.

   @return int Returns the current diagnostic logging level.
 */
VOCSDK_EXPORT int vocsdk_diag_get_log_level();

/*!
   @brief Controls the verbosity of the diagnostic messages in the console that VOC SDK will print.

   @discussion Log levels are defined in LOG_LEVEL enum.
 */
VOCSDK_EXPORT void vocsdk_diag_set_log_level(int level);


#pragma mark -- Policy Status --
/*!
   @brief Download Policy Status enumeration.

   @constant VOCPolicyStatusInPolicy SDK meets all the policies and can download.
   @constant VOCPolicyStatusNotRegistered SDK is not registered and cannot download.
   @constant VOCPolicyStatusNoDownload Policy does not allow SDK to download.
   @constant VOCPolicyStatusWifiDisallowedOnBattery Policy disallows SDK to download when device is not charging.
   @constant VOCPolicyStatusWifiNotAllowed Policy disallows SDK to download when in wifi.
   @constant VOCPolicyStatusHostUnreachableViaWifi Host is unreachable via wifi.
   @constant VOCPolicyStatusCellularDisallowedOnBattery Policy disallows SDK to download when device is on a cellular connection and it is not charging.
   @constant VOCPolicyStatusCellularTimeOfDay Time of Day policy disallows SDK to use cellular network for download.
   @constant VOCPolicyStatusCellularNotAllowed Network policy disallows SDK to use cellular network for download.
   @constant VOCPolicyStatusHostUnreachableViaCellular Host is unreachable via cellular.
   @constant VOCPolicyStatusBatteryTooLow Current device battery level is lower than required by battery policy.
   @constant VOCPolicyStatusCacheIsFull  Policy disallows SDK to download since cache allocated for SDK is full.
   @constant VOCPolicyStatusDailyLimitReached  Policy disallows SDK to download since daily download limit has reached.
 */
typedef NS_OPTIONS(NSInteger, VOCPolicyStatus) {
	VOCPolicyStatusInPolicy						= 0,
	VOCPolicyStatusNotRegistered				= 1,
	VOCPolicyStatusNoDownload					= 2,
	VOCPolicyStatusWifiDisallowedOnBattery		= 4,
	VOCPolicyStatusWifiNotAllowed				= 8,
	VOCPolicyStatusHostUnreachableViaWifi		= 0x10,
	VOCPolicyStatusCellularDisallowedOnBattery	= 0x20,
	VOCPolicyStatusCellularTimeOfDay			= 0x40,
	VOCPolicyStatusCellularNotAllowed			= 0x80,
	VOCPolicyStatusHostUnreachableViaCellular	= 0x100,
	VOCPolicyStatusBatteryTooLow				= 0x200,
	VOCPolicyStatusCacheIsFull					= 0x400,  //UNUSED
	VOCPolicyStatusNoFreeSpaceForCache			= 0x800,  //UNUSED
	VOCPolicyStatusDailyLimitReached			= 0x1000, //UNUSED
};

#pragma mark -- States --
/*!
   @brief Voc service states enumeration.

   @constant VOCServiceStateNotRegistered VocService is not registered. This is the initial state.
   @constant VOCServiceStateInitializing VocService is initializing. This is a transient state when service is starting up and still initializing, after that it will transtion to one of the other states.
   @constant VOCServiceStateIdle VocService is registered and initialized and is not downloading at the moment.
   @constant VOCServiceStateIdle VOCServiceStateIdle VocService is registered and initialized and is actively downloading at the moment.

   @see VocService
 */
typedef NS_ENUM(NSInteger, VOCServiceState) {

	VOCServiceStateNotRegistered		= 0,

	VOCServiceStateInitializing			= 1,

	VOCServiceStateIdle					= 2,

	VOCServiceStateDownloading			= 3
};

/*!
   @brief Item states enumeration.

   @constant VOCItemDiscovered Item is known to the SDK, download is not yet initiated.
   @constant VOCItemQueued Item has been added to downloading queue, it is currently not downloading. It will start downloading.
   @constant VOCItemDownloading Item is being downloaded.
   @constant VOCItemIdle Item is currently not downloading. Item has been queued for downloading before but did not finish downloading. Download will resume automatically at some point.
   @constant VOCItemPaused Item is currently not downloading. It has been explicitly paused with VocSerice pauseItems:.
   @constant VOCItemCached Item download was completed successfully. Cached content is ready for use.
   @constant VOCItemFailed Item failed to download. There are no cached files. No more download attempts will be made, unless explicit download for this item is triggered again.
   @constant VOCItemDeleted Item has been deleted and cannot be used any more. There are no cached files.
   @constant VOCItemPartiallyCached Item has been cached for a specified duration. User can download the complete duration by initiating download.

   @see VocService
 */
typedef NS_ENUM(NSInteger, VOCItemState) {

	VOCItemMetadataNotReceived			= 9,

	VOCItemDiscovered					= 0,

	VOCItemQueued						= 5,

	VOCItemDownloading					= 1,

	VOCItemIdle							= 6,

	VOCItemPaused						= 7,

	VOCItemCached						= 2,

	VOCItemFailed						= 4,

	VOCItemDeleted						= 3,

    VOCItemPartiallyCached				= 8,

	//deprecated mixed case aliases
	VocItemQueued = VOCItemQueued,
	VocItemIdle = VOCItemIdle,
	VocItemPaused = VOCItemPaused,
	VocItemFailed = VOCItemFailed,
};

/*!
   @brief File states enumeration.

   @constant VOCFileDiscovered File is known to the SDK, download is not yet initiated.
   @constant VOCFileDownloading File is being downloaded.
   @constant VOCFileCached File download was completed successfully.
   @constant VOCFileDeleted File has been deleted and cannot be used any more.
   @constant VOCFileError File handling by SDK such as downloading, saving etc. has resulted into an error.
   @constant VOCFileNotCached SDK identified the file as not eligible to be downloaded due to SDK configurations.
  @constant VOCFileIdle File is currently not downloading. File has been queued for downloading before but did not finish downloading. Download will resume automatically at some point.
 */
typedef NS_ENUM(NSInteger, VOCFileState) {

	VOCFileDiscovered			= 0,

	VOCFileDownloading			= 1,

	VOCFileCached				= 2,

	VOCFileDeleted				= 3,

	VOCFileError				= 4,

	VOCFileNotCached			= 5,

	VOCFileSkipDownload			= 6,

	VOCFileIdle					= 7
};


#pragma mark -- Types --
/*!
   @brief VocObj type enumeration.

   @constant VOCObjTypeItem Content item type.
   @constant VOCObjTypeItemCategory Category type.
   @constant VOCObjTypeItemSource Source/Provider type.
 */
typedef NS_ENUM(NSInteger, VOCObjType) {

	VOCObjTypeItem				= 0,

	VOCObjTypeItemCategory		= 1,

	VOCObjTypeItemSource		= 2,

	VOCObjTypeCount
};

/*!
   @brief Content item type enumeration.

   @constant VOCItemTypeVideo Video content.
   @constant VOCItemTypeHLSVideo HLS Video content.
   @constant VOCItemTypeDASHVideo DASH Video content.
   @constant VOCItemTypeGeneral A type that can accomodate any content.
 */
typedef NS_ENUM(NSInteger, VOCItemTypeEnum) {

	VOCItemTypeVideo			= 0,

	VOCItemTypeHLSVideo			= 1,

    VOCItemTypeDASHVideo		= 2,

    VOCItemTypeGeneral          = 8,

	VOCItemTypeCount
};


/*!
   @brief File type enumeration.

   @constant VOCUnknownFile The type of the file cannot be determined.
   @constant VOCMainFile main file is the one pointed by content item url, or one of the main file variants. Not used for HLS and DASH.
   @constant VOCThumbFile a thumbnail file.
   @constant VOCSubtitleFile a subtitle file.
   @constant VOCHLSMasterFile a HLS master m3u8 file
   @constant VOCHLSMediaPlaylist a HLS variant stream playlist file.
   @constant VOCHLSSegment a HLS segment file.
   @constant VOCHLSKey a HLS encryption key file.
   @constant VOCHLSDRM a HLS DRM key.

   @constant VOCDASHMainFile a DASH main mpd file.
   @constant VOCDASHSegment a DASH segment file.
 */
typedef NS_ENUM(int16_t, VocFileType) {

	VOCUnknownFile						= -1,

	VOCMainFile							= 0,

	VOCThumbFile						= 1,

	VOCSubtitleFile						= 2,


	VOCHLSMasterFile					= 10,

	VOCHLSMediaPlaylist					= 11,

	VOCHLSSegment						= 12,

	VOCHLSKey							= 13,

	VOCHLSDRM							= 14,


	VOCDASHMainFile						= 20,

	VOCDASHSegment						= 21,


	// deprecated
	VocUnknownFile						= VOCUnknownFile,
	VocMainFile							= VOCMainFile,
	VocThumbFile						= VOCThumbFile,
	VocSubtitleFile						= VOCSubtitleFile,

	VocHLSMainIndex						= VOCHLSMasterFile,
	VocHLSStreamIndex					= VOCHLSMediaPlaylist,
	VocHLSSegment						= VOCHLSSegment,
	VocHLSKey							= VOCHLSKey,
	VocHLSDRM							= VOCHLSDRM,

	VocDASHMainIndex					= VOCDASHMainFile,
	VocDASHSegment						= VOCDASHSegment,
};

/*!
   @brief File group type enumeration.

   @constant VocMainContentType SDK identifies the file as part of the main content.
   @constant VocThumbnailType SDK identifies the file as part of the thumbnail content group.
   @constant VocSubtitleType SDK identifies the file as part of the subtitle content group.
   @constant VocUnsupportedType SDK identifies it as an unsupported content group type.
 */
typedef NS_ENUM(int16_t, VocFileGroupType) {

	VocMainContentType	             = 0,

	VocThumbnailType                 = 1,

	VocSubtitleType                  = 2,

	VocUnsupportedType	             = -1,
};

/*!
   @brief Advertisement server type enumeration.

   @constant VOCAdServerTypeNone SDK identifies it as an unsupported ad server type.
   @constant VOCAdServerTypeIMA SDK identifies it as Google IMA ad type.
   @constant VOCAdServerTypeMillenial SDK identifies it as Millenial Media ad type.
 */
typedef NS_ENUM(NSInteger, VOCAdServerType) {

	VOCAdServerTypeNone			= 0,

	VOCAdServerTypeLiveRailREMOVED	__deprecated_enum_msg("This constant is not used in SDK")	= 1,

	VOCAdServerTypeIMA			= 2,

	VOCAdServerTypeMillenial	= 3
};




#pragma mark -- Config --
/*!
   @brief Item Download Behavior enumeration.

   @discussion The value set on VocItem::downloadBehavior will override VocConfig::itemDownloadBehavior.

   @constant VOCItemDownloadSdkBehavior VocItem::downloadBehavior means, this content item follows VocConfig::itemDownloadBehavior. VocConfig::itemDownloadBehavior should not have this value.
   @constant VOCItemDownloadFullAuto If VocItem::downloadBehavior is VOCItemDownloadFullAuto, SDK downloads all the files of the content item. If VocConfig::itemDownloadBehavior is VOCItemDownloadFullAuto, SDK downloads all the files of the content item that has VocItem::downloadBehavior as VOCItemDownloadSdkBehavior.
   @constant VOCItemDownloadThumbnailOnly If VocItem::downloadBehavior is VOCItemDownloadThumbnailOnly, SDK downloads only the main thumbnail file(not the main content) of the content item. If VocConfig::itemDownloadBehavior is VOCItemDownloadThumbnailOnly, SDK downloads only the main thumbnail file for the content item that has VocItem::downloadBehavior as VOCItemDownloadSdkBehavior.
   @constant VOCItemDownloadNone If VocItem::downloadBehavior is VOCItemDownloadNone, SDK does not download any files associated with the content item. If VocConfig::itemDownloadBehavior is VOCItemDownloadNone, SDK does not download any files for the content item that has VocItem::downloadBehavior as VOCItemDownloadSdkBehavior.
 */
typedef NS_ENUM(NSInteger, VOCItemDownloadBehavior) {

	VOCItemDownloadSdkBehavior			= 0,

	VOCItemDownloadFullAuto				= 1,

	VOCItemDownloadThumbnailOnly		= 2,

	VOCItemDownloadNone					= 3,

	VOCItemDownloadBehaviorCount
};

/*!
   @brief Item Content Quality enumeration.

   @discussion The value set on VocItem::preferredQuality will override VocConfig::preferredQuality.

   @constant VOCQualitySelectionSdkBehavior This value for VocItem::preferredQuality means it follows VocConfig::preferredQuality. VocConfig::preferredQuality shouldnot have this value.
   @constant VOCQualitySelectionLow If VocItem::preferredQuality is VOCQualitySelectionLow, SDK downloads from the url that is close to low quality. If VocConfig::videoQuality is VOCQualitySelectionLow, SDK downloads low quality content files for those items that has VocItem::preferredQuality set as VOCQualitySelectionSdkBehavior.
   @constant VOCQualitySelectionMedium If VocItem::preferredQuality is VOCQualitySelectionMedium, SDK downloads from the url that is close to medium quality. If VocConfig::videoQuality is VOCQualitySelectionMedium, SDK downloads medium quality content files for those items that has VocItem::preferredQuality set as VOCQualitySelectionSdkBehavior.
   @constant VOCQualitySelectionHigh If VocItem::preferredQuality is VOCQualitySelectionHigh, SDK downloads from the url that is close to high quality. If VocConfig::videoQuality is VOCQualitySelectionHigh, SDK downloads high quality content files for those items that has VocItem::preferredQuality set as VOCQualitySelectionSdkBehavior.
 */
typedef NS_ENUM(NSInteger, VOCQualitySelection) {

	VOCQualitySelectionSdkBehavior		= 0,

	VOCQualitySelectionLow				= 1,

	VOCQualitySelectionMedium			= 5,

	VOCQualitySelectionHigh				= 10,
};

/*!
   @brief Current SDK network connection type enumeration.

   @constant VOCConnectionNone There is no network connection.
   @constant VOCConnectionIsCellular There is cellular network connection.
   @constant VOCConnectionIsWiFi There is WiFi network connection.
 */
typedef NS_ENUM(NSInteger, VOCConnectionType) {

	VOCConnectionNone,

	VOCConnectionIsCellular,

	VOCConnectionIsWiFi,
};

/*!
   @brief User content relevance enumeration used mainly for Prediction component.

   @constant VOCContentRelevanceFocused PCD caches more focused content based on user interest.
   @constant VOCContentRelevanceBalanced PCD caches more balanced content.
   @constant VOCContentRelevanceBroad PCD caches broad range of content.
 */
typedef NS_ENUM(NSInteger, VOCContentRelevance) {

	VOCContentRelevanceFocused,

	VOCContentRelevanceBalanced,

	VOCContentRelevanceBroad,
};

/*!
   @brief User's preferred network selection type.

   @constant VOCNetworkSelectionNone SDK should not use any network.
   @constant VOCNetworkSelectionWifiOnly SDK downloads content over Wifi network.
   @constant VOCNetworkSelectionWifiAndCellular SDK downloads content over Wifi network and if Wifi network is not available, SDK downloads content over Cellular network.
 */
typedef NS_ENUM(NSInteger, VOCNetworkSelection) {

	VOCNetworkSelectionInvalid		   = -1,//invalid selection from client end.

	VOCNetworkSelectionNone			   = 0,

	VOCNetworkSelectionWifiOnly        = 100,

	VOCNetworkSelectionWifiAndCellular = 101,
};

/*!
   @enum DownloadQuota

   @brief Download quota enumeration.

   @constant VOCDownloadQuotaUnlimited The value for unlimited download quota.
 */
enum : int64_t {

	VOCDownloadQuotaUnlimited		= INT64_MAX
};

#pragma mark -- MAP --
/*!
   @brief Network Quality enumeration.
 
   @discussion Based on the threshold range that is given by the customer for each network type(say 2g, 3g, 4g etc), SDK calculates the network quality.

   @constant VocNetworkQualityPoor If the network quality is below the lower threshold value.
   @constant VocNetworkQualityGood If the network quality is between lower and higher threshold value.
   @constant VocNetworkQualityExcellent If the network quality is above higher threshold value.
   @constant VocNetworkQualityUnknown If the network quality cannot be determined by SDK.
   @constant VocNetworkQualityNotReady If SDK is not ready yet to determine the network quality.
 */
typedef NS_ENUM(NSInteger, VocNetworkQualityStatus) {
	VocNetworkQualityPoor       = 0,
	VocNetworkQualityGood       = 1,
	VocNetworkQualityExcellent  = 2,
	VocNetworkQualityUnknown    = -1,
	VocNetworkQualityNotReady   = -2,
};

#pragma mark -- Migration --
/*!
   @brief Migration states enumeration.

   @constant VocItemStateNonMigrated The content item is not migrated.
   @constant VocItemStateNewlyMigrated The content item is migrated with minimum information but the content metadata still needs to be accurately updated by PCD Server.
   @constant VocItemStateMigratedAndUpdated Migrated content item got updated by the PCD Server.
 */
typedef NS_ENUM(NSInteger, VOCItemMigrationState) {

	VocItemStateNonMigrated          = 0,

	VocItemStateNewlyMigrated        = 1,

	VocItemStateMigratedAndUpdated   = 2,
};

/*!
   @brief Migrating content status.

   @constant VocMigratingContentPartiallyDownloaded The content did not get cached before migrating to the SDK.
   @constant VocMigratingContentFullyDownloaded The content was cached before migrating to the SDK.
   @constant VocMigratingContentNewlyAdding The content was not previously attempted to download but consumer of the SDK will ingest it locally and want SDK to initiated a server update on the metadata of the item and then start download.
 */
typedef NS_ENUM(NSInteger, VOCMigratingContentStatus) {

	VocMigratingContentPartiallyDownloaded       = 0,

	VocMigratingContentFullyDownloaded           = 1,

	VocMigratingContentNewlyAdding               = 2,
};

/*!
   For migrating a content into sdk, a VocImportInfo is passed into
   VocService::addNewContent::completion:.
 */

@interface VocImportInfo : NSObject

/*! 
 @Discussion This property is required parameter for all migration action
 */
@property (nonatomic, assign) VOCMigratingContentStatus migrationType;

/*!
 @brief This value is the Content Id which client application uses for each content Item
 @Discussion This property is required parameter for all migration action
 */
@property (nonatomic, strong) NSString* contentId;

/*!
 @brief This key expects a NSString value and the value is the provider name for the content,
 which needs to be existing in SDK Database.
 @Discussion This property is required parameter for all migration action
 */
@property (nonatomic, strong) NSString* providerName;

/*!
 @brief This property expects path to the main file.
 ie, For HLS, this will be the location of the StreamIndex manifest file.
     For MP4, this points to the MP4 media file.

 @required
    For downlodStatus::VocMigratingContentFullyDownloaded
 */
@property (nonatomic, strong) NSString* contentPath;
/*!
 @brief This property expects the duration of the media file.
 @required For all migration process.
 */
@property (nonatomic, assign) NSTimeInterval contentDuration;
/*!
 @brief This property expects the size of the media content.
 @required For all migration process.
 */
@property (nonatomic, strong) NSNumber* contentSize;
/*!
 @brief This property expects the type of the media content.
 @required For all migration process.
 */
@property (nonatomic, assign) VOCItemTypeEnum contentType;
/*!
 @brief This property expects the url of the content.
 @optional For all migration process.
 */
@property (nonatomic, strong) NSURL* contentURL;
/*!
 @brief This property expects the timestamp of the content.
 @optional For all migration process.
 */
@property (nonatomic, assign) NSTimeInterval timeStamp;
/*!
 @brief This property expects the expiry date of the content..
 @optional For all migration process.
 */
@property (nonatomic, assign) NSTimeInterval expiryDate;
/*!
 @brief This property expects the title of the content..
 @optional For all migration process.
 */
@property (nonatomic, strong) NSString* contentTitle;
/*!
 @brief This property expects the summary of the content..
 @optional For all migration process.
 */
@property (nonatomic, strong) NSString* contentSummary;
/*!
 @brief This property expects the local path to the thumbnail image of the content..
 @optional For downlodStatus::VocMigratingContentFullyDownloaded.
 */
@property (nonatomic, strong) NSString* thumbfilePath;
/*!
 @brief This property expects the sdkMetadataPassthrough property in the id<VocItem>.
 @optional For all migration process.
 */
@property (nonatomic, strong) NSString* sdkMetadataPassthrough;
/*!
 @brief This property expects the time of download completion of the content.
 @optional For downlodStatus::VocMigratingContentFullyDownloaded.
 */
@property (nonatomic, assign) NSTimeInterval downloadFinishedTime;
/*!
 @brief This property expects whether the content is a Peer to Peer data.
 @optional For all migration process.
 */
@property (nonatomic, assign) BOOL isPToPContent;
/*!
 @brief This property expects the preffered quality for download.
 @required For 
    downlodStatus::VocMigratingContentPartiallyDownloaded.
    downlodStatus::VocMigratingContentNewlyAdding.
 */
@property (nonatomic, assign) NSInteger prefferredQuality;

/*
 @brief This key expects a NSDictionary for 
 setting up the download behaviour of the content.
 
 @required with
    downlodStatus::VocMigratingContentNewlyAdding
 @optional with
    downlodStatus::VocMigratingContentPartiallyDownloaded

 @discussion Example value for downloadOption is
        @{@"videoPartialDownloadLength" : @(0), @"downloadBehavior" : @(VOCItemDownloadFullAuto)}
 */
@property (nonatomic, strong) NSDictionary* downloadOptions;
@end

/*!
 For migrating a media content, an info dictionary is passed into
 VocService::addDownloadedItem:completion:.
 */

/* REQUIRED PARAMETERS */
/*!
   @brief This key expects a NSString value and the value is the Content Id which client application
   uses for each content Item
 */
static NSString* const VocImportFileMetadataContentId = @"contentId";

/*!
   @brief This key expects a NSString value and the value is the provider name for the content,
   which needs to be existing in SDK Database.
 */
static NSString* const VocImportFileMetadataProvider = @"provider";

/*!
   @brief This key expects a NSString value and the value is the local file path for the main file.
   ie, In the case of HLS, this will be the location of the main manifest file.
   In MP4, this points to the MP4 media file.
 */
static NSString* const VocImportFileMetadataFilePath = @"videoFileName";

/*!
   @brief This key expects a NSString value and the value is the duration of the media file.
 */
static NSString* const VocImportFileMetadataDuration = @"duration";

/*!
   @brief This key expects a NSNumber value and the value is the size of the media content.
 */
static NSString* const VocImportFileMetadataSize = @"size";

/*!
   @brief This key expects a NSNumber value and the allowed values are the enums
     VOCItemTypeHLSVideo  - HLS media content
     VOCItemTypeVideo     - MP4 media content
 */
static NSString* const VocImportFileMetadataContentType = @"type";

/*!
   @brief This key expects a NSString value and the value is the url of the content.
 */
static NSString* const VocImportFileMetadataContentUrl = @"Url";


/* OPTIONAL PARAMETERS */
/*!
   @brief This key expects a NSNumber value and the value is the timestamp of the content.
 */
static NSString* const VocImportFileMetadataTimeStamp = @"timestamp";

/*!
   @brief This key expects a NSNumber value and the value is the expiry date of the content..
 */
static NSString* const VocImportFileMetadataExpiryDate = @"expirydate";


/*!
   @brief This key expects a NSString value and the value is the title of the content..
 */
static NSString* const VocImportFileMetadataTitle = @"title";


/*!
   @brief This key expects a NSString value and the value is the summary of the content..
 */
static NSString* const VocImportFileMetadataSummary = @"summary"; //Summary of the content.

/*!
   @brief This key expects a NSString value and the value is the local path of the thumbfile.
 */
static NSString* const VocImportFileMetadataThumbFile = @"thumbfile";

/*!
   @brief This key expects a NSString value and the value is the represented as VocItem::sdkPassthroughMetadata.
 */
static NSString* const VocImportFileMetadataSDKPassthroughInfo = @"sdkPassthroughMetadata";

/*!
   @brief This key expects a NSString value and the value is whether the content is completely
   downloaded OR partially downloaded.

   @discussion The allowed values are
     VocMigratingContentFullyDownloaded         - Completely downloaded content
     VocMigratingContentPartiallyDownloaded     - Partially downloaded content
     VocMigratingContentNewlyAdding             - Adding a new content into sdk.
 */
static NSString* const VocImportFileDownloadStatus = @"downloadStatus";

/*!
   @brief This key expects a NSNumber value and the value is timeStamp of download finished time.
 */
static NSString* const VocImportFileMetadataDownloadFinishedTime = @"downloadFinishedTime";

/*!
   @brief This key expects a BOOL value and the value is whether the content is a Peer to Peer data.
 */
static NSString* const VocImportFileMetadataDownloadP2P = @"x-p2p-P2P";

/*!
   @brief This key expects a NSString value and the value is the url of the content (Only for Newly adding contents).
 */
static NSString* const VocImportFileMetadataPreferredQuality = @"preferedQuality";

/*!
   @brief This key expects a NSDictionary (Only used for Newly adding contents).

   @discussion Example dictionary value is
       @{@"videoPartialDownloadLength" : @(0),
                @"downloadBehavior" : @(VOCItemDownloadFullAuto)}
 */
static NSString* const VocImportFileMetadataDownloadOptions = @"downloadOptions";

#pragma mark -- Errors --
/*!
   @brief Domain for errors coming out of Voc SDK.
 */
VOCSDK_EXPORT NSString * const VOCSDKErrorDomain;

/*!
   @brief Voc service error codes.

   @constant VOCErrInvalidParam An invalid parameter is passed to a call to voc service.
   @constant VOCErrCreateService Creating VocService failed.
   @constant VOCErrAlreadyRegistered SDK is already registered or is in the process of registeration .
   @constant VOCErrNotRegistered SDK is not registered or was logged out, need to register.
   @constant VOCErrRegisterFailedBadCredentials SDK failed to register due to bad credentials.
   @constant VOCErrRegisterFailedOther SDK failed to register for some other reason than bad credentials, network connection might not be available.
   @constant VOCErrDb Database Error.
   @constant VOCErrServerApiError Server API Error.
   @constant VOCErrServerApiErrorUnauthorized Server request from SDK was responded with unauthorized access error.
   @constant VOCErrServerApiErrorRequestFailed Server request from SDK got failed.
   @constant VOCErrServerApiErrorResponseParse Client failed to parse the server response.
   @constant VOCErrServerApiErrorResponseData Server response data is having error.
   @constant VOCErrServerApiErrorNotAllowed The API is not allowed for the registered SDK type.
   @constant VocErrCancelled Operation cancelled (usually carries an underlying error with specific reason).
   @constant VocErrTimeOut Operation was cancelled because it did not finish in the allocated time.
   @constant VocErrBackgroundTimeOver Operation was cancelled because background execution time finished.
   @constant VocErrDownloadOptimization Download operation not started or was cancelled in order to optimize downloads.
   @constant VOCErrDownloadAlreadyInProgress Download operation not started or was cancelled because there is another download operation in progress.
   @constant VOCErrDownloadOutOfPolicy Download operation not started or was cancelled because download policy does not allow downloads at the moment.
   @constant VOCErrDownloadNetworkCongested Download operation not started or was cancelled because network is congested.
   @constant VOCErrDownloadDailyLimit Download operation not started or was cancelled because daily download limit was reached.
   @constant VOCErrDownloadCacheLimit Download operation not started or was cancelled because cache limit was reached.
   @constant VocErrShuttingDown Operation was cancelled because voc service is shutting down.
   @constant VocErrCongestionCheckFailed Congestion check failed for unspecified reason.
   @constant VocErrItemDeletionFailed VocItem deletion failed.
   @constant VocErrItemNotFound VocItem not found either locally or in server.
   @constant VocErrDownloadedItemImportFailed VocItem Local file Import failed.
   @constant VocErrDownloadNetworkError VocItem download was stopped temporarily, sdk will restart the download automatically.
   @constant VocErrDownloadItemCorrupted VocItem download failed, SDK cannot parse and process item.
   @constant VocErrDownloadFailed VocItem download failed.
   @constant VocErrCongestionCheckFailed404 Congestion check failed because of 404 response.
 */
typedef NS_ENUM(NSInteger, VOCSDKError) {

	VOCErrInvalidParam						= -1000,

	VOCErrCreateService						= -1001,

	VOCErrAlreadyRegistered					= -1002,

	VOCErrNotRegistered						= -1003,

	VOCErrRegisterFailedBadCredentials		= -1004,

	VOCErrRegisterFailedOther				= -1005,

	VOCErrDb								= -1006,

	VOCErrServerApiError					= -1010,

	VOCErrServerApiErrorUnauthorized		= -1011,

	VOCErrServerApiErrorRequestFailed		= -1012,

	VOCErrServerApiErrorResponseParse		= -1013,

	VOCErrServerApiErrorResponseData		= -1014,

	VOCErrServerApiErrorNotAllowed			= -1016,

	VocErrCancelled							= -3072, //this is -NSUserCancelledError

	VocErrUserCancelled						= -1100,

	VocErrTimeOut							= -1101,

	VocErrBackgroundTimeOver				= -1102,

	VocErrDownloadOptimization				= -1103,

	VOCErrDownloadAlreadyInProgress			= -1104,

	VOCErrDownloadOutOfPolicy				= -1105,

	VOCErrDownloadNetworkCongested			= -1106,

	VOCErrDownloadDailyLimit				= -1107,

	VOCErrDownloadCacheLimit				= -1108,

	VocErrShuttingDown						= -1109,

	VocErrCongestionCheckFailed             = -1110,

	VocErrItemDeletionFailed				= -1111,

	VocErrItemNotFound						= -1112,

	VocErrDownloadedItemImportFailed		= -1113,

	VocErrDownloadNetworkError				= -1114,

	VocErrDownloadItemCorrupted				= -1115,

	VocErrDownloadFailed					= -1116,

	VocErrCongestionCheckFailed404          = -1117,

	VocErrRegistrationDelayed				= -1118,

	VocErrDownloadHttpError					= -1119,

	VocErrDownloadNoNetworkError			= -1120,

	VOCErrContentIdDoesNotExistInServer     = -1121,

	VOCErrDownloadLaterLimit                = -1122

};

//Deprecated
#if !defined(VOCSDK_DEPRECATED)

#define VOCSDK_DEPRECATED	__attribute__((deprecated))

#endif

#endif //VocSdk_VocSdkBase_h
