import Foundation

fileprivate let keychainKeyName = "raindrop" //warning: this name can be showed to user in macos!!

extension AuthReducer {
    func restore() {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: keychainKeyName,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecAttrAccessGroup: Constants.keychainGroupName
        ] as [CFString : Any] as CFDictionary
        
        //get data from keychain
        var raw: AnyObject?
        let status = SecItemCopyMatching(query, &raw)
        guard
            status == errSecSuccess,
            let data = raw as? Data
        else { return }
        
        //restore cookies
        guard let cookies = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, HTTPCookie.self], from: data) as? [HTTPCookie] else { return }
        for cookie in cookies {
            HTTPCookieStorage.shared.setCookie(cookie)
        }
    }
    
    func persist() {
        //get all cookies for Rest API
        let cookies = (HTTPCookieStorage.shared.cookies ?? []).filter {
            $0.domain.contains(Rest.base.root.host!) ||
            $0.domain.contains(Rest.base.api.host!)
        }
        guard !cookies.isEmpty else { return }
        
        //archive to data
        let data = try? NSKeyedArchiver.archivedData(withRootObject: cookies, requiringSecureCoding: false)
        guard let data else { return }
        
        //save to keychain
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: keychainKeyName,
            kSecValueData: data,
            kSecAttrAccessGroup: Constants.keychainGroupName
        ] as [CFString : Any] as CFDictionary
        SecItemDelete(query)
        SecItemAdd(query, nil)
    }
}
