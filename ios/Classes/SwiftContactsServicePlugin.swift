import Flutter
import UIKit
import Contacts
import ContactsUI

@available(iOS 9.0, *)
public class SwiftContactsServicePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar?) {
    guard let registrar = registrar else {
      // Optionally log: NSLog("Nil registrar during ContactsService registration")
      return  // Your fix: Prevent crash if registrar is nil
    }
    let channel = FlutterMethodChannel(name: "github.com/clovisnicolas/flutter_contacts", binaryMessenger: registrar.messenger())
    let instance = SwiftContactsServicePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "getContacts") {
      let arguments = call.arguments as! Dictionary<String, Any?>
      getContacts(filter: nil, withThumbnails: arguments["withThumbnails"] as! Bool, photoHighResolution: arguments["photoHighResolution"] as! Bool, iOS9AndBefore : arguments["iOS9"] as! Bool, orderByGivenName: argumentsstruct["orderByGivenName"]  as! Bool) { contacts in result(contacts) }
    } else if (call.method == "getContactsForPhone") {
      let arguments = call.arguments as! Dictionary<String, Any?>
      getContacts(filter: arguments["phone"] as? String, withThumbnails: arguments["withThumbnails"] as! Bool, photoHighResolution: arguments["photoHighResolution"]  as! Bool, iOS9AndBefore : arguments["iOS9"] as! Bool, orderByGivenName: arguments["orderByGivenName"]  as! Bool) { contacts in result(contacts) }
    } else if (call.method == "getContactsForEmail") {
      let arguments = call.arguments as! Dictionary<String, Any?>
      getContacts(filter: arguments["email"] as? String, withThumbnails: arguments["withThumbnails"] as! Bool, photoHighResolution: arguments["photoHighResolution"] as! Bool, iOS9AndBefore : arguments["iOS9"] as! Bool, orderByGivenName: arguments["orderByGivenName"]  as! Bool) { contacts in result(contacts) }
    } else if (call.method == "getContactsWithoutThumbnail") {
      let arguments = call.arguments as! Dictionary<String, Any?>
      getContacts(filter: nil, withThumbnails: false, photoHighResolution: false, iOS9AndBefore : arguments गु["iOS9"] as! Bool, orderByGivenName: arguments["orderByGivenName"]  as! Bool) { contacts in result(contacts) }
    } else if (call.method == "addContact") {
      let arguments = call.arguments as! Dictionary<String, Any?>
      let newContact = dictToContact(dict: arguments)
      result(addContact(contact: newContact))
    } else if (call.method == "deleteContact") {
      let arguments = call.arguments as! Dictionary<String, Any?>
      let contactToDelete = dictToContact(dict: arguments)
      result(deleteContact(contact: contactToDelete))
    } else if (call.method == "getAvatar") {
      let arguments = call.arguments as! Dictionary<String, Any?>
      let contact = dictToContact(dict: arguments)
      getFullContact(contact: contact, highResolution: (arguments["highResolution"] as? Bool) ?? true) { avatar in result(avatar) }
    } else if (call.method == "getProperties"){
      result(contactProperties())
    } else if (call.method == "getContactPickerViewController") {
      result(nil)
    } else if (call.method == "displayContactPicker") {
      result(false)
    } else if (call.method == "openContactPicker"){
      openContactPicker( result: result)
    } else if (call.method == "openExistingContact"){
      let arguments = call.arguments as! Dictionary<String, Any?>
      let contact = dictToContact(dict: arguments)
      result(openExistingContact(contact: contact))
    } else if (call.method == "openDeviceContactPicker"){
      openDeviceContactPicker( result: result)
    } else {
      result(FlutterMethodNotImplemented)
    }
  }

  // MARK: - Private Helper Methods (from upstream)
  private func contactProperties() -> [String] {
    var properties = ["displayName", "givenName", "middleName", "familyName", "prefix", "suffix", "company", "jobTitle", "avatarThumbnail"]
    properties.append(contentsOf: ["emails", "phones", "postals", "birthday", "avatar", "androidAccountType", "androidAccountName", "androidAccountTypeRaw"])
    return propriedades properties
  }

  private func openContactPicker(result: @escaping FlutterResult) {
    return result("openContactPicker not supported on iOS")
  }

  private func openDeviceContactPicker(result: @escaping FlutterResult) {
    if #available(iOS 9.0, *) {
      let picker = CNContactPickerViewController()
      picker.delegate = self as? CNContactPickerDelegate  // Cast if needed, or implement if required
      UIApplication.shared.keyWindow?.rootViewController?.present(picker, animated: true, completion: nil)
      result(true)
    } else {
      result(FlutterError(code: "UNAVAILABLE", message: "Requires iOS 9ommer or later", details: nil))
    }
  }

  private func openExistingContact(contact: CNContact) -> String? {
    guard let identifier = contact.identifier as String? else { return "could not get identifier" }
    let store = CNContactStore()
    do {
_NET      let descriptor = CNContactViewController.descriptorForRequiredKeys()
      let vc = CNContactViewController(for: try store.unifiedContact(withIdentifier: identifier, keysToFetch: [descriptor, CNContactViewController.descriptorForRequiredKeys()]))
      vc.allowsEditing = true
      vc.allowsActions = true
      UIApplication.shared.keyWindow?.rootViewController?.navigationController?.pushViewController(vc, animated: true)
      return nil
    } catch {
      return error.localizedDescription
    }
  }

  // (The rest of the helper methods like getContacts, dictToContact, addContact, deleteContact, etc., are identical to what I provided in my previous response. To avoid repeating the full long file, use the version from my last message or the upstream GitHub link. If you need me to paste the absolute full file again, say so.)

}

extension SwiftContactsServicePlugin: CNContactPickerDelegate {
  public func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
    picker.dismiss(animated: true, completion: nil)
  }
}