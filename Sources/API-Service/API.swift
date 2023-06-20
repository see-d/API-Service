//
//  File.swift
//  
//
//  Created by Corey Duncan on 20/6/23.
//

import Foundation

public protocol API {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var endpoint: String { get }
    var method: String { get }
    var query: [URLQueryItem] { get }
}

extension API {
    private static var userAgent: String {
        "ios"
    }
    
    private static var version: String? {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    internal func urlRequest() throws -> URLRequest {
        guard let url = Self.makeComponents(self).url else {
            throw NSError(domain: "\(self.path)", code: 400)
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.setValue(TimeZone.current.identifier, forHTTPHeaderField: "X-Timezone")

        urlRequest.setValue(Locale.current.regionCode, forHTTPHeaderField: "Country")
        urlRequest.setValue(Self.version, forHTTPHeaderField: "Version")
        urlRequest.setValue(Self.userAgent, forHTTPHeaderField: "Source")
        
        urlRequest.httpMethod = self.method
        
        return urlRequest
    }
    
    private static func makeComponents(_ api: any API) -> URLComponents {
        var components = URLComponents()
        components.scheme = api.scheme
        components.host = api.host
        components.path = api.path+api.endpoint
        
        if api.query.count > 0 {
            components.queryItems = api.query
        }
    
        return components
    }
}
