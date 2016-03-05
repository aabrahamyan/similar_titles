# Similar Titles

## Similar Titles based on Jaccard algorithm

An application hits the data from Wikipedia. 
 * First recieves 50 articles based on user's current location
https://en.wikipedia.org/w/api.php?action=query&list=geosearch&gsradius=10000&gscoord=latitude|longitude&gslimit=50&format=json
 * Then based on Wikipedia API (By page ID using the pageids parameter, e.g. pageids=123|456|75915), system hits image titles.
 
 * Having collections of system titles, system uses Jaccard's algorithm in order to compare and find similarity between titles.
 
## Jaccard Algorithm
 
Given collections X(1,2,4) and y(2,3,4), find coefficient of how similar those colelctions are? Jaccard coeficent is a ratio of {X,Y} collections intersection and union. Jaccard(X/Y) = 2/4 = 0.5, in this case we have similarity of 0.5.

## Shnigling before giving to Jaccard
 
 Before finding Jaccard coefficient, system does shingling of titles. In this case we are doing 'Word Shingling' i.e given text: "hello cat", after shingling we will have a collection X("hello", "cat"). 
  It is important to mention that the more shingling is detailed the much better results after Jaccard operation we will get. I.e. we can have letter shingling, X('he', 'll', 'o '). But in this application we do a Word shingling for overall simplicity.
  
## Hitting Location
```swift
For hitting user location 
- locationManager.requestLocation() and 
- locationManager.requestWhenInUseAuthorization() 
latest SDK CoreLocation methods are used.
```
  
## Structure

Project contains 2 targets, SimilarTitles and Jaccard (framework). Separation is done in terms of modularity and reusability.

## Requirements
- iOS Deployment Target: 9.1
- XCode 7.0 and later

## Project Notes and TODOs
- Overall Jaccard algorithm can be optimized for faster operations. I.E instead of operating with strings, we can map each shingled item in collection with numbers ('he'->0, 'll'->1 etc..) and finally we can set bits in a nibble and consider working with bitwise operations.
- For now shingling is done per word, you can consider a 'bigram'=1 (which actually just a formality in this case).
- For some reason pageids=123|456|75915 are not always returning image titles for all articles, however in Wikipedia API doc it is mentioned how to send pageIds parameters in GET request - https://www.mediawiki.org/wiki/API:Query, see 'Specifying Pages' part.
- All items that has Jaccard coefficient equal to ZERO are filtered and are not shown in UITableView.

## Similar Image Titles Represented in Self Sized UITableView Cells
![Screenshot1](https://github.com/aabrahamyan/similar_titles/blob/master/SimilarTitles/thumb_IMG_0559_1024.jpg)

 
