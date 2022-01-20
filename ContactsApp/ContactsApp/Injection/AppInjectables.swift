//
//  AppInjectables.swift
//  ContactsApp
//
//  Created by Sachin Rao on 20/01/22.
//

import Foundation
protocol NetworkConnectivityInjectable { var networkConnectivity: Connectivity { get } }
protocol ViewControllerProviderInjectable { var viewControllerProvider: ViewControllerProvider { get } }