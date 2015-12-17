/**
 * @name            Repository.swift
 * @partof          GitHubSpy
 * @description
 * @author	 		Vasco Mouta
 * @created			17/12/15
 *
 * Copyright (c) 2015 zucred AG All rights reserved.
 * This material, including documentation and any related
 * computer programs, is protected by copyright controlled by
 * zucred AG. All rights are reserved. Copying,
 * including reproducing, storing, adapting or translating, any
 * or all of this material requires the prior written consent of
 * zucred AG. This material also contains confidential
 * information which may not be disclosed to others without the
 * prior written consent of zucred AG.
 */

import Foundation
import RealmSwift

class Repository: Object {
    
    static let GitHubFork = "fork"
    static let GitHubName = "name"
    static let GitHubCreated = "created_at"
    static let GitHubDescription = "description"
    
    dynamic var name: String = ""
    dynamic var desc: String = ""
    dynamic var created_at: String = ""
    dynamic var fork: Bool = false
    
    var isFork: Bool {
        return self.fork
    }
    
    var details: String {
        var details: String = self.created_at
        if !self.desc.isEmpty {
            details +=  " - \(self.desc)"
        }
        return details
    }
    
    convenience init(jsonDictionary: NSDictionary) {
        self.init(value: jsonDictionary)
        if let description = jsonDictionary.valueForKey(Repository.GitHubDescription) as? String {
            desc = description
        }
    }
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["isFork", "details"]
    }
}