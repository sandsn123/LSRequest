//
//  Executer.swift
//
//
//  Created by sandsn on 2023/12/9.
//
import Foundation

@attached(member, names: named(executer), named(ExecutorImpl))
public macro Executor<ExecutorImpl: Executor>() = #externalMacro(module: "LSRequestMacros", type: "ExecutorMacro")

@attached(member, names: named(executer), named(ExecutorImpl))
public macro Executor() = #externalMacro(module: "LSRequestMacros", type: "ExecutorMacro")
