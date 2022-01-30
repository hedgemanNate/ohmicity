//
//  Grouped Section.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 1/20/22.
//

import Foundation

struct GroupedSection<SectionItem: Hashable, RowItem> {

    var date: SectionItem
    var showsForDate: [RowItem]

    static func group(array: [RowItem], by criteria: (RowItem) -> SectionItem) -> [GroupedSection<SectionItem, RowItem>] {
        let groups = Dictionary(grouping: array, by: criteria)
        return groups.map(GroupedSection.init(date:showsForDate:))
    }

}
