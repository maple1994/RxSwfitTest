//
//  CLLocationManager+Rx.swift
//  MyRx
//
//  Created by Maple on 2017/8/30.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa

extension Reactive where Base: CLLocationManager {
    /**
     Reactive wrapper for `delegate`.
     
     For more information take a look at `DelegateProxyType` protocol documentation.
     */
    public var delegate: DelegateProxy {
        return RxCLLocationManagerDelegateProxy.proxyForObject(base)
    }
    
    // MARK: Responding to Authorization Changes
    
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didChangeAuthorizationStatus: Observable<CLAuthorizationStatus> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didChangeAuthorization:)))
            .map { a in
                let number = try castOrThrow(NSNumber.self, a[1])
                return CLAuthorizationStatus( rawValue: Int32(number.intValue)) ?? .notDetermined
        }
    }
    
    // MARK: Responding to Location Events
    
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didUpdateLocations: Observable<[CLLocation]> {
        return (delegate as! RxCLLocationManagerDelegateProxy).didUpdateLocationsSubject.asObservable()
    }
    
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didFailWithError: Observable<Error> {
        return (delegate as! RxCLLocationManagerDelegateProxy).didFailWithErrorSubject.asObservable()
    }
}

fileprivate func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    
    return returnValue
}
