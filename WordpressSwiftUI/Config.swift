//
//  Config.swift
//  WordpressSwiftUI
//
//  Created by berk birkan on 27.06.2020.
//  Copyright © 2020 berk birkan. All rights reserved.
//

import Foundation
//Admob

let IS_AD_ENABLE = false
let ADMOB_BANNER_ID = "ca-app-pub-3940256099942544/2934735716"
let ADMOB_INTERSTİTİAL_ID = "ca-app-pub-3940256099942544/4411468910"

//Wordpress
let WORDPRESS_URL = "https://usluer.net/"

let HOME_URL = WORDPRESS_URL + "/wp-json/wp/v2/posts?_embed&status=publish"
let CATEGORY_URL = WORDPRESS_URL + "/wp-json/wp/v2/categories"
let PAGE_URL = WORDPRESS_URL + "/wp-json/wp/v2/pages?status=publish"
let TAGS_URL = WORDPRESS_URL + "/wp-json/wp/v2/tags?per_page=100"
let FEATURED_MEDIA_URL = WORDPRESS_URL + "/wp-json/wp/v2/media/"
let COMMENTS = WORDPRESS_URL + "/wp-json/wp/v2/comments?post="
let AUTHOR_PAGE = WORDPRESS_URL + "/wp-json/wp/v2/users/"

//SLİDE
var isSlide = true
var slideCategory = "9"

//PUSH NOTİFİCATİON

let ONESIGNAL_APP_ID = ""
