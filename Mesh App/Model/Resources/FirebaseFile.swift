//
//  FirebaseFile.swift
//  Mesh App
//
//  Created by Mac admin on 12/10/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class FirebaseFile: NSObject
{
    /// Singleton instance
    static let shared: FirebaseFile = FirebaseFile()
    
    /// Path
    let kFirFileStorageRef = Storage.storage().reference().child("userProfileImages")
    
    /// Current uploading task
    var currentUploadTask: StorageUploadTask?
    
    func upload(data: Data,
                withName fileName: String,
                block: @escaping (_ url: String?) -> Void) {
        
        // Create a reference to the file you want to upload
        let fileRef = kFirFileStorageRef.child(fileName)
        
        /// Start uploading
        upload(data: data, withName: fileName, atPath: fileRef) { (url) in
            block(url)
        }
    }
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.75) else { return }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {
                
                storageRef.downloadURL { url, error in
                    completion(url)
                    // success!
                }
            } else {
                // failed
                completion(nil)
            }
        }
    }
            
    
    func upload(data: Data, withName fileName: String, atPath path:StorageReference,
                block: @escaping (_ url: String?) -> Void) {
        
        // Upload the file to the path
        self.currentUploadTask = path.putData(data, metadata: nil, completion: { (metaData, error) in
            
            guard let metaData = metaData else {
                print(error!)
                return
            }
            //let size = metaData.size
            //metaData.contentType = size
            
            // You can also access to download URL after upload.
            path.downloadURL { (url, error) in
                guard url != nil else {
                    // Uh-oh, an error occurred!
                    return
                }
            }
        })
    }
    
    func cancel() {
        self.currentUploadTask?.cancel()
    }
}
