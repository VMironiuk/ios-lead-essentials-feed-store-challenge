//
//  ManagedCache.swift
//  FeedStoreChallenge
//
//  Created by Vladimir Mironiuk on 04.09.2021.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import CoreData

@objc(ManagedCache)
class ManagedCache: NSManagedObject {
	@NSManaged var timestamp: Date
	@NSManaged var feed: NSOrderedSet
}

extension ManagedCache {
	var localFeed: [LocalFeedImage] {
		feed.compactMap { ($0 as? ManagedFeedImage)?.local }
	}

	static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
		let fetchRequest: NSFetchRequest<ManagedCache> = fetchRequest()
		fetchRequest.returnsObjectsAsFaults = false
		return try context.fetch(fetchRequest).first
	}

	static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedCache {
		try find(in: context).map(context.delete)
		return ManagedCache(context: context)
	}

	private static func fetchRequest() -> NSFetchRequest<ManagedCache> {
		NSFetchRequest(entityName: "ManagedCache")
	}
}
