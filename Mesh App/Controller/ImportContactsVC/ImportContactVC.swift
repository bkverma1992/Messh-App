//
//  ImportContactVC.swift
//  Mesh App
//
//  Created by Mac admin on 26/09/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit
import Contacts
import CoreTelephony

class ImportContactVC: UIViewController
{
    var contactStore = CNContactStore()
    var contactsArray = NSMutableArray()
    @IBOutlet weak var btnImport: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.btnImport.layer.cornerRadius = 4.0
        self.displayAlContacts()
        DefaultsValues.setBooleanValueToUserDefaults(false, forKey: kImportContactFirstTime)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnImport_Click(_ sender: Any)
    {
        //DefaultsValues.setStringValueToUserDefaults("NO", forKey: "plus_clicked")
        let objContactListVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idContactListVC") as! ContactListVC
        self.navigationController?.pushViewController(objContactListVC, animated: true)
    }
    
    @IBAction func btnSkipInvite_Click(_ sender: Any)
    {
        let objAddGroupSubjectVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idAddGroupSubjectVC") as! AddGroupSubjectVC
        objAddGroupSubjectVC.strIsClickedSkipAndInvite = "true"
        //        objAddGroupSubjectVC.arrParticipantsData = self.arrSelectedData.mutableCopy() as! NSMutableArray
        self.navigationController?.pushViewController(objAddGroupSubjectVC, animated: true)
    }
    
    //MARK: - Display Phone Contacts
    
    func displayAlContacts()
    {
        var contacts = [CNContact]()
        //        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
        //        let request = CNContactFetchRequest(keysToFetch: keys)
        
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        
        do {
            try self.contactStore.enumerateContacts(with: request) {
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                contacts.append(contact)
                
                let infoDict = NSMutableDictionary()
                
                let phoneNumber = contact.phoneNumbers.first?.value.stringValue
                
                let components =
                    phoneNumber!.components(separatedBy: CharacterSet.decimalDigits.inverted)
                let phone = components.joined()
                print("phone: ", phone)
                
                infoDict.setValue(String(format: "%@", phone), forKey: "Number")
                infoDict.setValue(contact.givenName, forKey: "Name")
                infoDict.setValue("No", forKey: "isExist")
                
                let valueeee = infoDict.value(forKey: "Number")
                if (valueeee != nil)
                {
                    self.contactsArray.add(infoDict)
                }
            }
        }
        catch
        {
            print("unable to fetch contacts")
        }
        print(self.contactsArray)
        if self.contactsArray.count != 0
        {
            let defaults = UserDefaults.standard
            defaults.set(self.contactsArray, forKey: "phone_contacts")
            SaveAndFetchCoreData.savePhoneContactList(arrayContacts: self.contactsArray, strIsLogin: "0")
            let arrData = SaveAndFetchCoreData.getContactList()
            print("arrData: ", arrData)
            defaults.synchronize()
        }
    }
}
