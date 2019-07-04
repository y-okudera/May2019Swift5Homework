//
//  NetworkReachability.swift
//  ResultTypeDemo
//
//  Created by YukiOkudera on 2019/07/07.
//  Copyright © 2019 YukiOkudera. All rights reserved.
//

import SystemConfiguration

struct NetworkReachability {

    static func checkReachability(hostName: String?) -> Bool {
        guard let hostName = hostName else {
            print("hostName is nil.")
            return false
        }
        let reachability = SCNetworkReachabilityCreateWithName(nil, hostName)!
        var flags = SCNetworkReachabilityFlags.connectionAutomatic
        if !SCNetworkReachabilityGetFlags(reachability, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return isReachable && !needsConnection
    }
}
