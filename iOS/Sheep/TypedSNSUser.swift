//
//  TypedFacebookUser.swift
//  Sheep
//
//  Created by mono on 7/28/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation

class TypedFacebookUser {
    var data: Dictionary<String, AnyObject>
    
    init(data: AnyObject!) {
        self.data = data as Dictionary<String, AnyObject>
    }
    
    var email: String? { get { return getValue("email") } }
    var first_name: String? { get { return getValue("first_name") } }
    var gender: String? { get { return getValue("gender") } }
    var id: String! { get { return getValue("id") } }
    var last_name: String? { get { return getValue("last_name") } }
    var name: String? { get { return getValue("name") } }
    
    var imageURL: String! { get { return NSString(format: "https://graph.facebook.com/%@/picture?type=large", self.id) }}
    
    func getValue(key: String) -> String? {
        if let d: AnyObject = data[key] {
            return d as? String
        }
        return nil
    }
    
    /*
    {
    bio = "Scene(http://scn.jp)\U3068\U3044\U3046\U5199\U771f\U6574\U7406\U30fb\U5171\U6709\U30a2\U30d7\U30ea\U306eiPhone\U7248\U4f5c\U3063\U3066\U3044\U307e\U3059(\U3000\U00b4\Uff65\U203f\Uff65\Uff40)\n\n\n\U25a0\U30e2\U30ce\U30b5\U30fc(\U30c6\U30cb\U30b9\U30b5\U30fc\U30af\U30eb)\U3084\U3063\U3066\U307e\U3059\nhttps://www.facebook.com/groups/229270203845340/\n\n\U25a0\U8da3\U5473\n- \U30b3\U30f3\U30d4\U30e5\U30fc\U30bf\U30fc\U5168\U822c\n- \U30ac\U30b8\U30a7\U30c3\U30c8\U3044\U3058\U308a\n- \U30c6\U30cb\U30b9\n- \U91ce\U7403\n- \U30de\U30e9\U30bd\U30f3(\U30cf\U30fc\U30d51\U6642\U9593\U534a)\n- \U82f1\U8a9e(\U6d0b\U66f8\U306a\U3069)\n\n\U25a0\U73fe\U5728\U306e\U6280\U8853\U5206\U91ce\n\U30fbiOS\U958b\U767a(Swift / Objective-C)\n\U30fbNode.js\n\U30fbWindows 8\n\U30fbWindows Phone\n\U30fbSIlverlight\n\U30fbTFS\n\U30fbASP.NET MVC\n\U30fbMVVM\n\U30fbPowerShell\n\U30fbJavaScript\n\n\U25a0\U4ee5\U524d\U306e\U6280\U8853\U5206\U91ce\n\U30fbJava\n\U30fbRuby on Rails\n\U30fbPython";
    birthday = "09/26/1986";
    email = "mono0926@gmail.com";
    "first_name" = Masayuki;
    gender = male;
    id = 10203261036299915;
    "last_name" = Ono;
    link = "https://www.facebook.com/app_scoped_user_id/10203261036299915/";
    locale = "en_US";
    location =     {
    id = 100563866688613;
    name = "Kawasaki-shi, Kanagawa, Japan";
    };
    name = "Masayuki Ono";
    "relationship_status" = Single;
    timezone = 9;
    "updated_time" = "2014-06-15T02:14:13+0000";
    verified = 1;
    }

*/
}