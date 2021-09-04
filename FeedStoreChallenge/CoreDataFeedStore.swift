//
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import CoreData

public final class CoreDataFeedStore: FeedStore {
	private static let modelName = "FeedStore"
	private static let model = NSManagedObjectModel(name: modelName, in: Bundle(for: CoreDataFeedStore.self))

	private let container: NSPersistentContainer
	private let context: NSManagedObjectContext

	struct ModelNotFound: Error {
		let modelName: String
	}

	public init(storeURL: URL) throws {
		guard let model = CoreDataFeedStore.model else {
			throw ModelNotFound(modelName: CoreDataFeedStore.modelName)
		}

		container = try NSPersistentContainer.load(
			name: CoreDataFeedStore.modelName,
			model: model,
			url: storeURL
		)
		context = container.newBackgroundContext()
	}

	public func retrieve(completion: @escaping RetrievalCompletion) {
		let context = context
		context.perform {
			do {
				if let cache = try ManagedCache.find(in: context) {
					completion(.found(feed: cache.feed.compactMap {
							if let managedFeedImage = $0 as? ManagedFeedImage {
								return LocalFeedImage(id: managedFeedImage.id,
								                      description: managedFeedImage.imageDescription,
								                      location: managedFeedImage.location,
								                      url: managedFeedImage.url)
							}
							return nil
						},
						timestamp: cache.timestamp))
				} else {
					completion(.empty)
				}
			} catch {
				completion(.failure(error))
			}
		}
	}

	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
		let context = context
		context.perform {
			do {
				let cache = ManagedCache(context: context)
				cache.timestamp = timestamp
				cache.feed = ManagedFeedImage.images(from: feed, in: context)
				try context.save()
				completion(nil)
			} catch {
				completion(error)
			}
		}
	}

	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
		fatalError("Must be implemented")
	}
}
