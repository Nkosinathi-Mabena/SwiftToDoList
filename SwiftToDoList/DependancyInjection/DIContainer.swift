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
        // Register Core Data Manager as singleton
        container.register(CoreDataManager.self) { _ in
            CoreDataManager.shared
        }.inObjectScope(.container)
        
        // Register Repositories
        container.register(WeatherRepositoryProtocol.self) { _ in
            WeatherRepository()
        }.inObjectScope(.container) // Singleton scope for repositories
        
        container.register(TaskRepositoryProtocol.self) { _ in
            TaskRepository()
        }.inObjectScope(.container)
        
        // Register Services
        container.register(LocationManager.self) { _ in
            LocationManager()
        }.inObjectScope(.container) // Singleton scope
        
        // Register ViewModels
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
    
    // Convenience method for ViewModels that are commonly used
    func resolveWeatherViewModel() -> WeatherViewModel {
        return container.resolve(WeatherViewModel.self)!
    }
    
    func resolveTaskViewModel() -> TaskViewModel {
        return container.resolve(TaskViewModel.self)!
    }
}
