//
//  XMLParserManager.swift
//  covidInfo
//
//  Created by Мария Водолазкая on 27.03.2020.
//  Copyright © 2020 Мария Водолазкая. All rights reserved.
//

import Foundation

struct RSS_Item {
    var title: String
    var link: String
    var itemDescription: String
    var author: String
    var category: String
    var comments: String
    var enclosure: String
    var guid: String
    var pubDate: String
    var source: String
    var content: String
}


class XmlParserManager: NSObject, XMLParserDelegate {
    
    var parser = XMLParser()
    
    /*
     var feeds = NSMutableArray()
     var elements = NSMutableDictionary()
     var element = NSString()
     var ftitle = NSMutableString()
     var link = NSMutableString()
     var img:  [AnyObject] = []
     var fdescription = NSMutableString()
     var fdate = NSMutableString()
     */
    
    // initilise parser
    func initWithURL(_ url :URL) -> AnyObject {
        startParse(url)
        return self
    }
    
    var items: [RSS_Item] = []
    var elementName: String = String()
    var title = String()
    var link = String()
    var itemDescription = String()
    var author = String()
    var category = String()
    var comments = String()
    var enclosure = String()
    var guid = String()
    var pubDate = String()
    var source = String()
    var content = String()
    
    func startParse(_ url :URL) {
        items = []
        parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.shouldProcessNamespaces = false
        parser.shouldReportNamespacePrefixes = false
        parser.shouldResolveExternalEntities = false
        parser.parse()
    }
    
    
    func feed() -> [RSS_Item] {
        return items
    }
    
    
    // 1
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "item" {
            title = String()
            link = String()
            itemDescription = String()
            author = String()
            category = String()
            comments = String()
            enclosure = String()
            guid = String()
            pubDate = String()
            source = String()
            content = String()
        }
        
        self.elementName = elementName
    }
    
    // 2
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let item = RSS_Item(title: title, link: link, itemDescription: itemDescription, author: author, category: category, comments: comments, enclosure: enclosure, guid: guid, pubDate: pubDate, source: source, content: content)
            items.append(item)
        }
    }
    
    // 3
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if (!data.isEmpty) {
            switch self.elementName {
            case "title":
                title += data
            case "link":
                link += data
            case "description":
                itemDescription += data
            case "author":
                author += data
            case "category":
                category += data
            case "comments":
                comments += data
            case "enclosure":
                enclosure += data
            case "guid":
                guid += data
            case "pubDate":
                pubDate += data
            case "source":
                source += data
            case "content":
                content += data
            default:
                if (self.elementName == "a10:content") {
                    content += data;
                }
            }
        }
    }
}
