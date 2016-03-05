//
//  STRestConstants.swift
//  SimilarTitles
//
//  Created by Armen Abrahamyan on 1/29/16.
//  Copyright © 2016 Armen Abrahamyan. All rights reserved.
//

import Foundation

/**
* Global constants with tree type structures
*/
struct STRestConstants {
    
    //MARK: Service URL
    static let serverUrl: String = "https://en.wikipedia.org/w/api.php"
    
    //MARK: Request Params separators
    struct STParamsSeparators{
        static let firstParamSeparator = "?"
        static let paramSeparator = "&"
        static let equality = "="
    }
    //MARK: Request Parameters keyes
    struct STParamsKeys {
        // Articles
        static let action: String = "action"
        static let list: String = "list"
        static let gsradius: String = "gsradius"
        static let gscoord: String = "gscoord"
        static let gslimit: String = "gslimit"
        static let format: String = "format"
        // Image Properties
        static let prop: String = "prop"
        static let pageids: String = "pageids"
        static let imageIdSeparator: String = "|"
    }
    
    
}