//
//  DBManager.swift
//  DBExample
//
//  Created by Shivaji Tanpure on 22/05/18.
//  Copyright © 2018 Shivaji Tanpure. All rights reserved.
//

import SQLite3
import UIKit

class User:NSObject {
    var name:String = String()
}

class DBManager: NSObject {
    
    
    var db: OpaquePointer?
    func createDatabase(){
        //the database file
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("UserDatabase.sqlite")
        print("path:\(fileURL)")
        
        //opening the database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        //creating table
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS User (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, password TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
    }
    
    func insert(name:String, password:String) {
        let insertStatementString = "INSERT INTO User (username, password) VALUES (?, ?);"

        var insertStatement: OpaquePointer? = nil
        
        // 1
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            let name:NSString = name as NSString
            let password:NSString = password as NSString
            print("Name:\(name) Password:\(password)")
            
            // 2
            sqlite3_bind_text(insertStatement, 1, name.utf8String, -1, nil)
            // 3
            sqlite3_bind_text(insertStatement, 2, password.utf8String, -1, nil)
            
            // 4
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        // 5
        sqlite3_finalize(insertStatement)
    }
    
    func saveData(name:String, password:String) {
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        print("Name:\(name) Password:\(password)")
        
        //creating a statement
        var stmt: OpaquePointer?
        
        //the insert query
        let queryString = "INSERT INTO User (username, password) VALUES (?,?);"
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, String(utf8String: name.cString(using: .utf8)!), -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 2, String(utf8String: password.cString(using: .utf8)!), -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding password: \(errmsg)")
            return
        }
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        }
        
        //displaying a success message
        print("User saved successfully")
    }
    
    func readData(){
    
        //this is our select query
        let queryString = "SELECT * FROM User"
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let password = String(cString: sqlite3_column_text(stmt, 2))
            
            print("id:\(id) User Name:\(name) Password:\(password)")
        }
        
    }

}
