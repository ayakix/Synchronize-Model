//
//  ModelChangeable.swift
//  Synchronize-Model
//
//  Created by r_ayaki on 2017/03/30.
//  Copyright © 2017年 Ayakix. All rights reserved.
//

protocol ModelChangeable {
    func updateModel(_ model: Model)
    func deleteModel(_ model: Model)
}
