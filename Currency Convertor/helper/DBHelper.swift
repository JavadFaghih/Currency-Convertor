//
//  DBHelper.swift
//  Currency Convertor
//
//  Created by Javad on 12/20/1400 AP.
//

import RealmSwift

final class DBManager {
    
    static let instance = DBManager()
    private var realm: Realm!
    
    
    private init() {
        realm = try! Realm()
    }
    
    func save<T: Object>(object: T) {
        
        do {
            try realm.write {
                realm.add(object, update: .modified)
                print("a new object saved successfuly...")
            }
        } catch {
            print("some thing went wrong when save a new data...")
        }
        
    }
    
    func read<T: Object>(object: T) -> Results<T> {
       
        let  data =  realm.objects(T.self)
          
            return data
    }
    
    func updata<T: Object>(object: T) {
        do {
            try realm.write {
                
            }
        } catch {
            
        }
    }
}
