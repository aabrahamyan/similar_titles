//
//  Jaccard.swift
//  SimilarTitles
//
//  Created by Armen Abrahamyan on 1/30/16.
//  Copyright © 2016 Armen Abrahamyan. All rights reserved.
//

import Foundation

/**
* Simple class to find similarity Based on Jaccard algorithm
* TODO: We probably can optimize algorithm by shingling not with words but with letters and adding int mapping to each subsequence of letter
* that way we won't operate with strings directly, but with Ints and will do a bit shifting instead of slicing
*/
public class Jaccard {
    
    /**
    * Create word shingles, for word shingling bigram='1' 
    * is the most optimal solution
    */
    public class func shingle(let string: String, let bigram: Int) -> Set<String> {
        var shingles: Set = Set<String>()
        var splitArray: [String] = string.componentsSeparatedByString(" ")

        if splitArray.count == 1 {
            shingles.insert(splitArray[0])
        } else {
            for var i = 0; i < (splitArray.count - bigram) + 1; i++ {
                let slice = splitArray[i..<(i + bigram)]
                let slicedArray: [String] = [String](slice)
                shingles = shingles.exclusiveOr(slicedArray)
            }
        }
        
        return shingles
    }
    
    /**
    * Check for similarity of two strings
    */
    public class func similarity(let str1: String, let str2: String, let bigram: Int) -> [String:Float] {
        
        let firstCollection = shingle(str1, bigram: bigram)
        let secondCollection = shingle(str2, bigram: bigram)
        
        // Jaccard value
        let jaccardCoeficent = Float(firstCollection.intersect(secondCollection).count) / Float(firstCollection.union(secondCollection).count)
        
        return [str1: jaccardCoeficent, str2: jaccardCoeficent]
    }
    
}