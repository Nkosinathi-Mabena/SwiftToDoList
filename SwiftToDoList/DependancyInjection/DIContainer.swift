//
//  DIContainer.swift
//  SwiftToDoList
//
//  Created by Nathi Mabena on 2025/09/21.
//

import Foundation
import Swinject

class DIContainer {
    static let shared = DIContainer()
    
    private let container = Container()
    
    private init() {
        setupDependencies()
    }
    
    private func setupDependencies() {
        // Register Core Data Manager as singleton, so theres only one instance of the data manager through out the app
        container.register(CoreDataManager.self) { _ in
            CoreDataManager.shared
        }.inObjectScope(.container)
        
        container.register(WeatherRepositoryProtocol.self) { _ in
            WeatherRepository()
        }.inObjectScope(.container)
        
        container.register(TaskRepositoryProtocol.self) { _ in
            TaskRepository()
        }.inObjectScope(.container)
        
        container.register(LocationManager.self) { _ in
            LocationManager()
        }.inObjectScope(.container)
        
        container.register(WeatherViewModel.self) { resolver in
            let repository = resolver.resolve(WeatherRepositoryProtocol.self)!
            let locationManager = resolver.resolve(LocationManager.self)!
            return WeatherViewModel(repository: repository, locationManager: locationManager)
        }
        
        container.register(TaskViewModel.self) { resolver in
            let repository = resolver.resolve(TaskRepositoryProtocol.self)!
            return TaskViewModel(repository: repository)
        }
    }
    
    
    func resolve<T>(_ type: T.Type) -> T? {
        return container.resolve(type)
    }
    
    func resolve<T>(_ type: T.Type, name: String?) -> T? {
        return container.resolve(type, name: name)
    }
    
    // Convenience methods still not sure 
    func resolveWeatherViewModel() -> WeatherViewModel {
        return container.resolve(WeatherViewModel.self)!
    }
    
    func resolveTaskViewModel() -> TaskViewModel {
        return container.resolve(TaskViewModel.self)!
    }
}
