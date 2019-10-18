//
//  DataManager.swift
//  SQLiteLearn
//
//  Created by Raju Dhumne on 15/09/19.
//  Copyright © 2019 Raju Dhumne. All rights reserved.
//

import Foundation
import SQLite

class DataManager {

    private init() { }
    
    static let shared = DataManager()
    let userTable = Table("users")
    let id = Expression<Int>("id")
    let name = Expression<String>("name")
    let email = Expression<String>("email")
    var userModelArr = [UserModel]()
    
    let database: Connection = {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("User").appendingPathExtension("sqlite3")
            let data = try Connection(fileUrl.path)
            return data
        }catch {
            print(error)
        }
        return try! Connection()
    }()
    
    func createTable() {
        let createTable = userTable.create { (t) in
            t.column(id, primaryKey: true)
            t.column(email, unique: true)
            t.column(name)
        }
        do{
            try database.run(createTable)
            print("Table Created")
        }catch {
            print(error)
        }
    }
    
    
    func inserUser(email: String,name: String) {
        let insertUser = userTable.insert(self.email <- email,self.name <- name)
        do{
           try database.run(insertUser)
            print("Insert User")
        }catch {
            print(error)
        }
    }
    
    func fetchAllUser(completion: @escaping ([UserModel],Error?) -> ()) {
        do {
            let users = try database.prepare(userTable)
            userModelArr.removeAll()
            for usr in users {
                userModelArr.append(UserModel(email: usr[self.email], name: usr[self.name]))
            }
            completion(userModelArr,nil)
        }catch {
            completion([],error)
            print(error)
        }
    }
    
    func deleteUser(email:String) {
        let user = userTable.filter(self.email == email)
        
        let deleteUser = user.delete()
        do {
           try database.run(deleteUser)
        }catch {
            print(error)
        }
    }
    
}
