//
//  STWikipediaDataProvider.swift
//  SimilarTitles
//
//  Created by Armen Abrahamyan on 1/29/16.
//  Copyright © 2016 Armen Abrahamyan. All rights reserved.
//

import Foundation
import CoreLocation
import Jaccard

class STWikipediaDataProvider {

    /**
    * Getting data to analyze from 'Wikipedia'
    */
    class func getNearByTitles(paramsDictionary: [String: String],
        completionHandler:(response: [String:AnyObject]?, error: NSError?) -> Void) {

            var pageIds = [String]()
            // Construct request params string
            let requestString = constructParamsString(paramsDictionary)
            // Send request
            STRestManager.sendGETRequest(requestString) { (response: [String:AnyObject]?, error: NSError?) -> Void in
            
                if error == nil {
                    let query = response!["query"] as? [String:AnyObject]
                    if let queryResult = query {
                        let geoSearchResult = queryResult["geosearch"] as? Array<AnyObject>
                        if let geos = geoSearchResult {
                            for article in geos {
                                let pageId = article["pageid"] as! Int                                
                                pageIds.append(String(pageId))
                            }
                            
                            // Start hitting for Image Titles
                            getImageTitles(pageIds, completionHandler: completionHandler)
                        }
                    }
                }
        }

    }
    
    /**
     * Get imagees data from Wikipedia
     */
    class func getImageTitles(let pageIds: Array<String>, completionHandler:(response: [String:AnyObject]?, error: NSError?) -> Void) {
        
        let pageIdsRequestString = constructIdSetString(pageIds)
        let requestString = constructParamsString([STRestConstants.STParamsKeys.action: "query",
            STRestConstants.STParamsKeys.prop: "images",
            STRestConstants.STParamsKeys.pageids: pageIdsRequestString,
            STRestConstants.STParamsKeys.format: "json"])
        
        STRestManager.sendGETRequest(requestString) { (response: Dictionary<String, AnyObject>?, error: NSError?) -> Void in
        
            var similars: Dictionary<String,AnyObject> = Dictionary<String, AnyObject>()
            if error == nil {
                let query = response!["query"] as? [String:AnyObject]
                if query != nil {
                    let pages = query!["pages"] as? [String:AnyObject]
                    if (pages != nil) {
                        for (key, value) in pages! {
                            let imagesArray = value["images"] as? Array<[String:AnyObject]>
                            if imagesArray != nil {
                                let currentSimilarSet = enumerateImageTitles(imagesArray!)
                                similars[String(key)] = currentSimilarSet
                            }
                        }
                    }
                    
                    completionHandler(response: similars, error: nil)
                }
            } else {
                completionHandler(response: nil, error: error)
            }
        }
    }

    
    /**
    * Responsible for constructing generic request params string
    */
    class func constructParamsString(paramsDictionary: [String: String]) -> String {
        var requestString = "\(STRestConstants.serverUrl)\(STRestConstants.STParamsSeparators.firstParamSeparator)"
        var index: Int = 0
        
        for (key, value) in paramsDictionary {
            
            // Params block
            requestString += key
            requestString += STRestConstants.STParamsSeparators.equality
            requestString += value

            if index != paramsDictionary.count - 1 {
                requestString += STRestConstants.STParamsSeparators.paramSeparator
            }
            
            index++
        }
        
        return requestString
    }
    
    /**
    * Analyze and get Similar titles
    */
    private class func enumerateImageTitles (let titleObjects: Array<[String:AnyObject]>) ->Set<String> {
        var similars: Set = Set<String>()
        for var upperIndex = 0; upperIndex < titleObjects.count; upperIndex++ {
            let currentTopLevelElem = titleObjects[upperIndex]
            for var innerIndex = upperIndex + 1; innerIndex < titleObjects.count; innerIndex++ {
                let nextElement = titleObjects[innerIndex]
                let str1Comparable = currentTopLevelElem["title"] as! String
                let str2Comparable = nextElement["title"] as! String
                
                let compareResult = Jaccard.similarity(currentTopLevelElem["title"] as! String, str2: nextElement["title"] as! String, bigram: 1)
                
                let jaccardIndex = compareResult[str1Comparable]

                if jaccardIndex > 0 {
                    if !similars.contains(str1Comparable) {
                        similars.insert(str1Comparable)
                    }
                    
                    if !similars.contains(str2Comparable) {
                        similars.insert(str2Comparable)
                    }
                }
            }
        }
        
        
        return similars
    }
    
    
    /**
    * A helper method to create images requests request
    */
    class func constructIdSetString(let ids: Array<String>) -> String {
        var pageIdsString = ""
        var index = 0
        for currentId: String in ids {
        
            pageIdsString += currentId
            if index != ids.count - 1 {
                pageIdsString += STRestConstants.STParamsKeys.imageIdSeparator
            }
            
            index++
            
        }
        return pageIdsString
    }
}







