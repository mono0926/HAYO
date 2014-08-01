//
//  TypedFacebookUser.swift
//  Sheep
//
//  Created by mono on 7/28/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation

class TypedUserBase {
    var data: Dictionary<String, AnyObject>
    init(data: NSDictionary) {
        self.data = data as Dictionary<String, AnyObject>
    }
    func getStringValue(key: String) -> String? {
        println("key: \(key), value: \(self.data[key])")
        if let d: AnyObject = data[key] {
            return d as? String
        }
        return nil
    }
    func getBoolValue(key: String) -> Bool? {
        println("key: \(key), value: \(self.data[key])")
        if let d: AnyObject = data[key] {
            return d as? Bool
        }
        return nil
    }
}

protocol SNSUser {
    var name: String! { get }
    var imageURL: String! { get }
    var email: String? { get }
}

class TypedTwitterUser: TypedUserBase, SNSUser {
    
    var name: String! { get { return getStringValue("name") } }
    var imageURL: String! { get { return profileImageUrl }}
    var email: String? { get { return nil } }
    var verified: Bool? { get { return getBoolValue("verified") } }
    var screen_name: String? { get { return getStringValue("screen_name") } }
    // TODO: 末尾を400x400に
    var profileImageUrl: String? { get { return ObjcHelper.replace(getStringValue("profile_image_url"), from: "normal", to: "400x400") } }
    var id: String! { get { return getStringValue("id") } }
    /*
[verified: 0
profile_link_color: 3833D4
screen_name: _mono
name: M Ono
description: t大hrs研 → ぬっそる(Microsoft系研究開発) → R○pplex iOSアプリ開発とかWindowsアプリ開発とかがんばってます( ´･‿･｀) 写真アプリSceneのiOS版作ってます。 http://t.co/LJj8oBnTZi
is_translator: 0
followers_count: 520
statuses_count: 36315
id_str: 35741880
profile_sidebar_border_color: FFFFFF
status: {
contributors = "<null>";
coordinates = "<null>";
"created_at" = "Wed Jul 30 01:34:24 +0000 2014";
entities =     {
hashtags =         (
);
symbols =         (
);
urls =         (
{
"display_url" = "d.hatena.ne.jp/shu223/2014060\U2026";
"expanded_url" = "http://d.hatena.ne.jp/shu223/20140606/1402015233";
indices =                 (
72

94
);
url = "http://t.co/Z97K7ohqpt";
}
);
"user_mentions" =         (
{
id = 69298459;
"id_str" = 69298459;
indices =                 (
0

7
);
name = "Tsutsumi Shuichi";
"screen_name" = shu223;
}
);
};
"favorite_count" = 0;
favorited = 0;
geo = "<null>";
id = 494294910825013249;
"id_str" = 494294910825013249;
"in_reply_to_screen_name" = shu223;
"in_reply_to_status_id" = "<null>";
"in_reply_to_status_id_str" = "<null>";
"in_reply_to_user_id" = 69298459;
"in_reply_to_user_id_str" = 69298459;
lang = ja;
place = "<null>";
"possibly_sensitive" = 0;
"retweet_count" = 0;
retweeted = 0;
source = "<a href=\"http://twitter.com\" rel=\"nofollow\">Twitter Web Client</a>";
text = "@shu223 \U3059\U307f\U307e\U305b\U3093\U3001\U3053\U3061\U3089\U306e\U30b3\U30e1\U30f3\U30c8\U306b\U66f8\U304d\U307e\U3057\U305f\U304c\U3001[More]\U306bExtension\U304c\U51fa\U3066\U304f\U308b\U3088\U3046\U306b\U3059\U308b\U305f\U3081\U306b\U3001\U4f55\U304b\U624b\U9806\U5fc5\U8981\U3067\U3057\U305f\U304b\Uff1f\nhttp://t.co/Z97K7ohqpt";
truncated = 0;
}
profile_background_image_url: http://pbs.twimg.com/profile_background_images/167247113/In_Purple_by_Andry122.jpg
listed_count: 35
profile_background_color: 834AFF
profile_sidebar_fill_color: FBF0FF
profile_text_color: 480885
follow_request_sent: 0
profile_image_url_https: https://pbs.twimg.com/profile_images/476454722593771520/goSBw3js_normal.png
profile_banner_url: https://pbs.twimg.com/profile_banners/35741880/1348920974
location: ホワイトシティー川崎
profile_background_tile: 0
profile_use_background_image: 1
lang: en
profile_image_url: http://pbs.twimg.com/profile_images/476454722593771520/goSBw3js_normal.png
entities: {
description =     {
urls =         (
{
"display_url" = "scn.jp";
"expanded_url" = "http://www.scn.jp/";
indices =                 (
102

124
);
url = "http://t.co/LJj8oBnTZi";
}
);
};
url =     {
urls =         (
{
"display_url" = "mono0926.com";
"expanded_url" = "http://mono0926.com";
indices =                 (
0

22
);
url = "http://t.co/fheadmIScy";
}
);
};
}
geo_enabled: 1
protected: 0
suspended: 0
created_at: Mon Apr 27 13:34:52 +0000 2009
id: 35741880
needs_phone_verification: 0
time_zone: Tokyo
favourites_count: 182
following: 0
utc_offset: 32400
url: http://t.co/fheadmIScy
is_translation_enabled: 0
default_profile: 0
profile_background_image_url_https: https://pbs.twimg.com/profile_background_images/167247113/In_Purple_by_Andry122.jpg
default_profile_image: 0
contributors_enabled: 0
friends_count: 328
notifications: 0]
(lldb)*/
}

class TypedFacebookUser: TypedUserBase, SNSUser {
    
    var name: String! { get { return getStringValue("name") } }
    var email: String? { get { return getStringValue("email") } }
    var imageURL: String! { get { return NSString(format: "https://graph.facebook.com/%@/picture?type=large", self.id) }}
    var first_name: String? { get { return getStringValue("first_name") } }
    var gender: String? { get { return getStringValue("gender") } }
    var id: String! { get { return getStringValue("id") } }
    var last_name: String? { get { return getStringValue("last_name") } }

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