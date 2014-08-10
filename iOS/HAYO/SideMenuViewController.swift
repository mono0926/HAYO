//
//  SideMenuViewController.swift
//  Sheep
//
//  Created by mono on 8/3/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation

enum SettingRow: Int {
    case HayoList, SearchFrinds, EditHayoMessage, NotificationSound
    
}

func toSettingRow(index: Int) -> SettingRow {
    switch index {
    case 0: return .HayoList
    case 1: return .SearchFrinds
    case 2: return .EditHayoMessage
    case 3: return .NotificationSound
    default: return .HayoList
    }
}

class SideMenuViewController: UITableViewController {
    class func create() -> SideMenuViewController {
        let sb = UIStoryboard(name: "SideMenu", bundle: nil)
        return sb.instantiateInitialViewController() as SideMenuViewController
    }
    
    var selectedBlock: ((type: SettingRow) -> ())?
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let row = toSettingRow(indexPath.row)
        selectedBlock?(type: row)
    }
}