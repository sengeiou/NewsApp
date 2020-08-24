//
//  Provider.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/24/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//


import Foundation
import RxSwift
import Moya
import Alamofire

/**
 Base class for api provider. Do not use this class directly but has to through subclass.
 */
class Provider<Target> where Target: Moya.TargetType {
    func request(_ token: Target) -> Single<Moya.Response> {
        fatalError("This class is used directly which is forbidden")
    }
}

extension PrimitiveSequence where Trait == SingleTrait {
    func handleCommonError(_ error: Error, autoHandleNoInternetConnection: Bool, autoHandleAPIError: Bool) -> PrimitiveSequence<Trait, Element> {
        guard case MoyaError.underlying(let underlyingError, _) = error else {
            return Single<Element>.error(error)
        }
        // Handle no internet connection automatically if needed
        if case AFError.sessionTaskFailed(error: let sessionError) = underlyingError,
            let urlError = sessionError as? URLError,
            urlError.code == URLError.Code.notConnectedToInternet ||
            urlError.code == URLError.Code.timedOut {
            if autoHandleNoInternetConnection == true {
                NotificationCenter.default.post(name: .AutoHandleNoInternetConnectionError, object: error)
                return Single<Element>.error(APIError.ignore(error))
            } else {
                return Single<Element>.error(error)
            }
        }
        // Handle api error automatically if needed
        else if autoHandleAPIError == true {
            NotificationCenter.default.post(name: .AutoHandleAPIError, object: error)
            return Single<Element>.error(APIError.ignore(error))
        } else {
            return Single<Element>.error(error)
        }
    }
    
    func catchCommonError(autoHandleNoInternetConnection: Bool, autoHandleAPIError: Bool) -> PrimitiveSequence<Trait, Element> {
        return catchError {(error) in
            let catched = self.handleCommonError(error, autoHandleNoInternetConnection: autoHandleNoInternetConnection, autoHandleAPIError: autoHandleAPIError)
            return catched
        }
    }
}
