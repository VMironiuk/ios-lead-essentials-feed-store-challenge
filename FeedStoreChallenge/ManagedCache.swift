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
	static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
		let fetchRequest: NSFetchRequest<ManagedCache> = fetchRequest()
		fetchRequest.returnsObjectsAsFaults = false
		return try context.fetch(fetchRequest).first
	}

	private static func fetchRequest() -> NSFetchRequest<ManagedCache> {
		NSFetchRequest(entityName: "ManagedCache")
	}
}
