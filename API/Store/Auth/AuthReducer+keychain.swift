import Foundation

fileprivate let keychainKeyName = "cookies"

extension AuthReducer {
    func restore(state: inout S, keychain: String) {
        state.keychain = keychain
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: keychainKeyName,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecAttrAccessGroup: keychain
        ] as CFDictionary
        
        //get data from keychain
        var raw: AnyObject?
        let status = SecItemCopyMatching(query, &raw)
        guard
            status == errSecSuccess,
            let data = raw as? Data
        else { return }
        
        //restore cookies
        guard let cookies = (try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)) as? [HTTPCookie] else { return }
        for cookie in cookies {
            HTTPCookieStorage.shared.setCookie(cookie)
        }
    }
    
    func persist(state: inout S) {
        guard let keychain = state.keychain else { return }
        
        //get all cookies for Rest API
        let cookies = (HTTPCookieStorage.shared.cookies ?? []).filter {
            $0.domain.contains(Rest.base.root.host()!) ||
            $0.domain.contains(Rest.base.api.host()!)
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
            kSecAttrAccessGroup: keychain
        ] as CFDictionary
        SecItemDelete(query)
        SecItemAdd(query, nil)
    }
}
