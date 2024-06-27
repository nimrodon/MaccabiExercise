//
//  ProductsCoreDateCacheService.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 27/06/2024.
//

import Foundation
import CoreData

class ProductsCoreDataCacheService: ProductsCacheServiceProtocol {
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext

    init() {
        container = NSPersistentContainer(name: "ProductsApp")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        context = container.viewContext
    }

    func cacheProducts(products: [Product]) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ProductEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()

            for product in products {
                let productEntity = ProductEntity(context: context)
                productEntity.id = Int64(product.id)
                productEntity.title = product.title
                productEntity.category = product.category
                productEntity.thumbnail = product.thumbnail
                productEntity.images = product.images as NSObject
                productEntity.price = product.price
                productEntity.stock = Int64(product.stock)
            }

            let metadataFetchRequest: NSFetchRequest<NSFetchRequestResult> = CacheMetadata.fetchRequest()
            let metadataDeleteRequest = NSBatchDeleteRequest(fetchRequest: metadataFetchRequest)
            try context.execute(metadataDeleteRequest)

            let cacheMetadata = CacheMetadata(context: context)
            cacheMetadata.lastUpdated = Date()

            try context.save()
        } catch {
            print("Failed to cache products: \(error)")
        }
    }

    func getCachedProducts() -> [Product]? {
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true) // or any other attribute you want to sort by
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let productEntities = try context.fetch(fetchRequest)
            let products: [Product] = productEntities.map { entity in
                let id = Int(entity.id)
                let title = entity.title ?? ""
                let category = entity.category ?? ""
                let thumbnail = entity.thumbnail ?? ""
                let images = entity.images as? [String] ?? []
                let price = entity.price
                let stock = Int(entity.stock)
                return Product(id: id, title: title, category: category, thumbnail: thumbnail, images: images, price: price, stock: stock)
            }
            return products
        } catch {
            print("Failed to fetch cached products: \(error)")
            return nil
        }
    }


    func getLastCachingTime() -> Date? {
        let fetchRequest: NSFetchRequest<CacheMetadata> = CacheMetadata.fetchRequest()
        fetchRequest.fetchLimit = 1

        do {
            let metadata = try context.fetch(fetchRequest).first
            return metadata?.lastUpdated
        } catch {
            print("Failed to fetch last caching time: \(error)")
            return nil
        }
    }
}

