//
//  ProviderAPIWithRefreshToken.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/24/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//


import Foundation
import Moya
import RxSwift
import NSObject_Rx

extension Notification.Name {
    static let AutoHandleAPIError: Notification.Name = Notification.Name("AutoHandleAPIError")
    static let AutoHandleNoInternetConnectionError: Notification.Name = Notification.Name("AutoHandleNoInternetConnectionError")
    static let AutoHandleAccessTokenExpired: Notification.Name = Notification.Name("AutoHandleAccessTokenExpired")
}

/**
 Similiar to `ProviderAPIWithRefreshToken` but including refresh token flow
 */
class ProviderAPIWithRefreshToken<Target>: Provider<Target> where Target: Moya.TargetType {
    let provider: MoyaProvider<Target>
    let prefs: PrefsAccessToken & PrefsRefreshToken
    let tokenRefresher: TokenRefresher?
    let autoHandleAccessTokenExpired: Bool
    let autoHandleAPIError: Bool
    let autoHandleNoInternetConnection: Bool

    /**
     Init Provider, similiar to Moya.
     - Parameter prefs: Access token storage
     - Parameter autoHandleAccessTokenExpired: If `true` then errors which caused the app to auto logout will be handled automatically, and will be transformed into `APIError.ignore`
     - Parameter autoHandleAccountSuspendedStop: If `true` then errors which caused the app to auto logout will be handled automatically, and will be transformed into `APIError.ignore`
     - Parameter autoHandleAPIError: If `true` then any error thrown will be handled automatically, and will be transformed into `APIError.ignore`
     */
    init(prefs: PrefsAccessToken & PrefsRefreshToken = PrefsImpl.default,
         autoHandleAccessTokenExpired: Bool = true,
         autoHandleNoInternetConnection: Bool = true,
         autoHandleAPIError: Bool = true,
         tokenRefresher: TokenRefresher? = TokenRefresherImpl.shared,
         endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
         requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
         stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
         session: Session = DefaultAlamofireManager.shared,
         plugins: [PluginType] = [],
         trackInflights: Bool = false) {
        self.prefs = prefs
        self.tokenRefresher = tokenRefresher
        self.autoHandleAccessTokenExpired = autoHandleAccessTokenExpired
        self.autoHandleAPIError = autoHandleAPIError
        self.autoHandleNoInternetConnection = autoHandleNoInternetConnection

        // Set up plugins
        var mutablePlugins: [PluginType] = plugins
        let errorProcessPlugin: APIErrorProcessPlugin = APIErrorProcessPlugin()
        mutablePlugins.append(errorProcessPlugin)
        #if DEBUG
        mutablePlugins.append(NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose)))
        #endif
        let accessTokenPlugin: AccessTokenPlugin = AccessTokenPlugin { (_) -> String in
            return prefs.getAccessToken() ?? ""
        }
        mutablePlugins.append(accessTokenPlugin)

        provider = MoyaProvider(endpointClosure: endpointClosure,
                                requestClosure: requestClosure,
                                stubClosure: stubClosure,
                                session: session,
                                plugins: mutablePlugins,
                                trackInflights: trackInflights)
    }
    
    override func request(_ token: Target) -> Single<Moya.Response> {
        return request(token, accessToken: prefs.getAccessToken())
    }

    private func request(_ token: Target, accessToken: String?) -> Single<Moya.Response> {
        let request = provider.rx.request(token)
        return request
            .catchError({ (error) in
                guard case MoyaError.underlying(let underlyingError, let response) = error,
                    case APIError.serverError(let detail) = underlyingError else { return Single.error(error) }
                let accessTokenExpired: Bool = (detail.code == 401001)
                if accessTokenExpired == true {
                    return Single.error(MoyaError.underlying(APIError.accessTokenExpired(underlyingError), response))
                } else {
                    return Single.error(error)
                }
            })
            .catchError({ (error) in
                // Handle access token expired
                if case MoyaError.underlying(APIError.accessTokenExpired(_), _) = error,
                    self.autoHandleAccessTokenExpired == true {
                    NotificationCenter.default.post(name: .AutoHandleAccessTokenExpired, object: nil)
                    return Single.error(APIError.ignore(error))
                } else {
                    return Single.error(error)
                }
            })
            .catchCommonError(autoHandleNoInternetConnection: autoHandleNoInternetConnection, autoHandleAPIError: autoHandleAPIError)
    }
}
