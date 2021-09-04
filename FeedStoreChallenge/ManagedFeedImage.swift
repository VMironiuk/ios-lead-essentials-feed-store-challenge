//
//  ManagedFeedImage.swift
//  FeedStoreChallenge
//
//  Created by Vladimir Mironiuk on 04.09.2021.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import CoreData

@objc(ManagedFeedImage)
class ManagedFeedImage: NSManagedObject {
	@NSManaged var id: UUID
	@NSManaged var imageDescription: String?
	@NSManaged var location: String?
	@NSManaged var url: URL
	@NSManaged var cache: ManagedCache
}

extension ManagedFeedImage {
	static func images(from localFeed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
		NSOrderedSet(array: localFeed.map { localFeedImage in
			let managedFeedImage = ManagedFeedImage(context: context)
			managedFeedImage.id = localFeedImage.id
			managedFeedImage.imageDescription = localFeedImage.description
			managedFeedImage.location = localFeedImage.location
			managedFeedImage.url = localFeedImage.url
			return managedFeedImage
		})
	}
}
