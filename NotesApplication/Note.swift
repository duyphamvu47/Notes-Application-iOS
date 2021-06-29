//
//  Note.swift
//  NotesApplication
//
//  Created by Vu Duy on 29/06/2021.
//

import Foundation

var noteList:[Note] = []
let storageKey:String = "data"

struct Note:Codable{
    var title:String
    var note:String
}
