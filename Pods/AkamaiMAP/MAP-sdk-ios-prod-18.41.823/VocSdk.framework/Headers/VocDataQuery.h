//
//  VocDataQuery.h
//  VocSdk
//
//  Created by Tzvetan Todorov on 6/15/17.
//  Copyright © 2017 Akamai Inc. All rights reserved.
//

/*!
 @header VocDataQuery.h

 @brief Header file VocDataQuery API.

 @copyright (c)2015,2016,2017 Akamai Technologies, Inc. All Rights Reserved. Reproduction in whole or in part in any form or medium without express written permission is prohibited.
 */


#ifndef VocSdk_VocDataQuery_h
#define VocSdk_VocDataQuery_h


@protocol VocDataQuery;

@protocol VocItem;
@protocol VocItemCategory;
@protocol VocItemSource;
@protocol VocItemSet;
@protocol VocVideoSet;
@protocol VocCategorySet;
@protocol VocSourceSet;
@protocol VocObjSet;



@class VocItemFilter;
@class VocVideoFilter;
@class VocItemCategoryFilter;
@class VocItemSourceFilter;
@class VocObjFilter;


/*!
 @protocol VocDataQuery

 @brief VocDataQuery provides methods for querying data maintained by voc service.

 @discussion VocDataQuery

 @see VocService
 */
@protocol VocDataQuery <NSObject>

/*!
 @brief Load an item with given uniqueId.

 @discussion This method will load and return an item with the given uniqueId if it is present in the cache. This method is asynchronous and completion block will be invoked on delegate queue. If the item is present, the item parameter will be non nil and error will be nil. If item is not present item will be nil and error will be nil. If there is an error processing this request item will be nil and error will be not nil. This method is safe to be called on any thread. Completion is always called on delegate queue.

 @param uniqueId The uniqueId associated with the item.
 @param completion The completion block that returns the VocItem and the error.

 @see VocItem
 */
- (void)getItemWithId:(nonnull NSString*)uniqueId
		   completion:(nonnull void (^)(NSError * __nullable error, id<VocItem> __nullable item))completion;

/*!
 @brief Load an item with given url.

 @discussion This method will load and return an item with the given url if it is present in the cache. This method is asynchronous and completion block will be invoked on the delegate queue. If the item is present, the item parameter will be non nil and error will be nil. If the item is not present item will be nil and error will be nil. If there is an error processing this request item will be nil and error will be not nil. This method is safe to be called on any thread. Completion is always called on delegate queue.

 @param url The main url associated with the item.
 @param completion The completion block that returns the VocItemSet and the error.

 @see VocItem VocItemSet
 */
- (void)getItemWithURL:(nonnull NSString*)url
			completion:(nonnull void (^)(NSError *   __nullable error, id<VocItem> __nullable item))completion;


/*!
 @brief Load items with given content ids and source.

 @discussion Returns a VocItemSet that contains items that matches the given set of content unique id and source. The SDK searches the item locally and returns VocItemSet with those items. The method also initiates a lookup in PCD Server if not found locally. content_unique_id is the content identifier provided to PCD Server while ingesting a content item and this id can be accessed from VocItem::contentId. content_provider_id is the source identifier provided to PCD Server while ingesting an item and this information can be accessed from VocItem::source. It is the combination of content_unique_id and content_provider_id that makes a VocItem unique. This API method returns an VocItemSet based on the contentId set provided. contentId is unique to a source but multiple source can have same contentId. Eventhough source is marked optional, it is highly recommended to provide source particularly when the client has access to multiple source. All the contentId in the contentIds must belong to same source. This API method will first search the VocItem locally and if not found, it will search in the PCD Server. This method is asynchronous and completion block will be invoked on delegate queue. If items.count < contentIds.count, the completion block will return non nil itemSet.items and non nil error. SDK will return the partial result in this case and provide more information on the items that are not available locally. This method is safe to be called on any thread. Completion is always called on delegate queue.

 @param contentIds is a set of item contentIds (@see VocItem::contentId).
 @param sourceName is the source name which all the item contentId belongs. (@see VocItem::source)
 @param completion The completion block that returns the VocItemSet and the error.

 @see VocItemSet
 */
- (void)getItemsWithContentIds:(nonnull NSSet<NSString *  >*)contentIds
					sourceName:(nullable NSString*  )sourceName
					completion:(nonnull void (^)(NSError *   __nullable error, id<VocItemSet> __nullable itemSet))completion;


/*!
 @brief Load a set of items matching the given filter.

 @discussion This method will load and return a set of items matching the given filter. This method is asynchronous and completion block will be invoked on delegate queue. If there are no items at the moment matching the given filter the item set returned will be empty initially. If there is an error processing this request, set will be nil and error will be not nil. This method is safe to be called on any thread. Completion is always called on delegate queue.

 @param filter The VocItemFilter instance that filters the content items.
 @param completion The completion block that returns the VocItemSet and the error.

 @see VocItemSet VocItemFilter
 */
- (void)getItemsWithFilter:(nonnull VocItemFilter*  )filter
				completion:(nonnull void (^)(NSError *   __nullable error, id<VocItemSet> __nullable set))completion;

/*!
 @brief Load a set of videos matching the given filter.

 @discussion This method will load and return a set of videos matching the given filter. This method is asynchronous and completion block will be invoked on delegate queue. If there are no videos at the moment matching the given filter the video set returned will be empty initially. If there is an error processing this request, set will be nil and error will be not nil. This method is safe to be called on any thread. Completion is always called on delegate queue.

 @param filter The VocVideoFilter instance that filters the content items.
 @param completion The completion block that returns the VocVideoSet and the error.

 @see VocVideoSet VocVideoFilter
 */
- (void)getVideosWithFilter:(nonnull VocVideoFilter*  )filter
				 completion:(nonnull void (^)(NSError *   __nullable error, id<VocVideoSet> __nullable set))completion;

/*!
 @brief Load a category with given name.

 @discussion This method will load and return a category with the given name if it is present. This method is asynchronous and completion block will be invoked on delegate queue. If category is present the category parameter will be non nil and error will be nil. If category is not present category will be nil and error will be nil. If there is an error processing this request, category will be nil and error will be not nil. This method is safe to be called on any thread. Completion is always called on delegate queue.

 @param name The category name.
 @param completion The completion block that returns the category and the error.

 @see VocItemCategory
 */
- (void)getCategoryWithName:(nonnull NSString*)name
				 completion:(nonnull void (^)(NSError *   __nullable error, id<VocItemCategory> __nullable category))completion;

/*!
 @brief Load a set of categories matching the given filter.

 @discussion This method will load and return a set of categories matching the given filter. This method is asynchronous and completion block will be invoked on delegate queue. If there are no catgories at the moment matching the given filter the category set returned will be empty initially. If there is an error processing this request, set will be nil and error will be not nil. This method is safe to be called on any thread. Completion is always called on delegate queue.

 @param filter The VocItemCategoryFilter instance that filters the category items.
 @param completion The completion block that returns the VocCategorySet and the error.

 @see VocCategorySet VocItemCategoryFilter
 */
- (void)getCategoriesWithFilter:(nonnull VocItemCategoryFilter*  )filter
					 completion:(nonnull void (^)(NSError *   __nullable error, id<VocCategorySet> __nullable set))completion;


/*!
 @brief Load a source with given name.

 @discussion This method will load and return a source with the given name if it is present. This method is asynchronous and completion block will be invoked on delegate queue. If source is present the source parameter will be non nil and error will be nil. If source is not present source will be nil and error will be nil. If there is an error processing this request source will be nil and error will be not nil. This method is safe to be called on any thread. Completion is always called on delegate queue.

 @param name The source name.
 @param completion The completion block that returns the VocItemSource and the error.

 @see VocItemSource
 */
- (void)getSourceWithName:(nonnull NSString*)name
			   completion:(nonnull void (^)(NSError *   __nullable error, id<VocItemSource> __nullable source))completion;


/*!
 @brief Load a set of sources matching the given filter.

 @discussion This method will load and return a set of sources matching the given filter. This method is asynchronous and completion block will be invoked on delegate queue. If there are no sources at the moment matching the given filter the source set returned will be empty initially. If there is an error processing this request set will be nil and error will be not nil. This method is safe to be called on any thread. Completion is always called on delegate queue.

 @param filter The VocItemSourceFilter instance that filters the source items.
 @param completion The completion block that returns the VocSourceSet and the error.

 @see VocSourceSet VocItemSourceFilter
 */
- (void)getSourcesWithFilter:(nonnull VocItemSourceFilter*  )filter
				  completion:(nonnull void (^)(NSError *   __nullable error, id<VocSourceSet> __nullable set))completion;

/*!
 @brief Load a set of objects (items, categories or sources) matching the given filter.

 @discussion This method will load and return a set of objects (items, categories or sources) matching the given filter. This method is asynchronous and completion block will be invoked on delegate queue. If there are no objects at the moment matching the given filter the object set returned will be empty initially. If there is an error processing this request set will be nil and error will be not nil. This method is safe to be called on any thread. Completion is always called on delegate queue.

 @param filter The VocObjFilter instance that filters the VocObj items.
 @param completion The completion block that returns the VocObjSet and the error.

 @see VocObj VocObjSet VocObjFilter
 */
- (void)getObjSetWithFilter:(nonnull VocObjFilter*  )filter
				 completion:(nonnull void (^)(NSError *   __nullable error, id<VocObjSet> __nullable set))completion;


@end


#endif //VocSdk_VocDataQuery_h
