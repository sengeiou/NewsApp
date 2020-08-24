//
//  ProviderPlain.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/24/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import Foundation
import Moya
import RxSwift

/**
Simple network call which included a network logger already.
*/
class ProviderPlain<Target>: Provider<Target> where Target: Moya.TargetType {
    let provider: MoyaProvider<Target>
    
    init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
         requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
         stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
         session: Session = DefaultAlamofireManager.shared,
         plugins: [PluginType] = [],
         trackInflights: Bool = false) {
        var mutablePlugins: [PluginType] = plugins
        #if DEBUG
        mutablePlugins.append(NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose)))
        #endif
        provider = MoyaProvider(endpointClosure: endpointClosure,
                                requestClosure: requestClosure,
                                stubClosure: stubClosure,
                                session: session,
                                plugins: mutablePlugins,
                                trackInflights: trackInflights)
    }

    override func request(_ token: Target) -> Single<Response> {
        return provider.rx.request(token)
    }
}
