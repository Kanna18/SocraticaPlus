//
//  Constants.swift
//  CountriesInfo
//
//  Created by Mounika on 04/04/18.
//

import Foundation
//
//struct ServiceHeaderConst {
//    let apiKey = "x-api-key"
//    let apiValue = "taya@123"
//    let authKey = "Authorization"
//    let authvalue = "Basic YWRtaW46MTIzNA=="
//    
//}

struct ServiceDataConst {
    
    static var kRootURL: String
    {
        return "http://dev.socplusstaging.com/api/"
    }
    static var kParentLogin: String {
        return kRootURL + "token"
    }
    static var kParentRegistration: String {
        return kRootURL + "token/" + "RegisterParent"
    }
    static var kRegistrationConfirmphone: String {
        return kRootURL + "token/" + "confirmphone"
    }
    static var kForgotPassword: String {
        return kRootURL + "token/" + "ForgotPassword"
    }
    static var kVerifyOTPForgotPassword: String {
        return kRootURL + "token/" + "verifyotp"
    }
    static var kChangePasswordPassword: String {
        return kRootURL + "token/" + "changepassword"
    }
    static var kParentProfile: String{
        return kRootURL + "parent/profile/"
    }
    static var kRemoveParentProfile: String{
        return kRootURL + "Register/RemoveParent"
    }
    
//    static var kRegistrationURL: String {
//        return kRootURL + "users_register"
//    }
//    static var kShopsURL: String {
//        return kRootURL + "shops"
//    }
//    static var kShopItemsBycatURL: String {
//         return kRootURL + "ShopItemsBycat"
//        
//    }
//    static var kPromoURL: String {
//         return kRootURL + "Promocode_offers"
//    }
//    static var kUserOrdersURL: String
//    {
//        return kRootURL + "Ordersbyuser"
//    }
//    static var kFavURL: String {
//        return kRootURL + "Favourite"
//    }
//    static var kUpdateFavURL: String {
//        return kRootURL + "UpdateFavourites"
//    }
//    static var kAddressURL: String {
//        return kRootURL + "address"
//    }
//    static var kAddtoCartURL: String {
//        
//        return kRootURL + "Addtocart"
//        
//    }
//    static var kUpdateCartURL: String {
//        return kRootURL + "Update_cart"
//        
//    }
//    static var kReorderURL: String {
//        return kRootURL + "Reorder_addtocar"
//    }
//    static var kDeleteCartURL: String {
//        return kRootURL + "Delete_cart"
//    }
//    
//    static var kCuisin: String {
//        return kRootURL + "Cuisins"
//    }
//    static var krestaurantCategory: String {
//        return kRootURL + "Shopcategories"
//    }
        
}



// static strings for alerts
let alert_action_ok = "OK"
let alert_connectivity_msg = "Please check internet connectivity"
let alert_internet = "No Internet"
let alert_fav = "Favorite"
let alert_fav_msg = "Added as favorite"
let alert_fav_exist_msg = "Already added as favorite"
let savedPhoneNumber = "phonenumber"
let savedPassword = "password"
