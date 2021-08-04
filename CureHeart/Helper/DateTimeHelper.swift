//
//  DateTimeHelper.swift
//  CureHeart
//
//  Created by Dwi RIzki Manggala Putra on 01/08/21.
//

import Foundation

func helper_getCurrentDate(format: String) -> String {
  let today = Date()
  let formatter = DateFormatter()
  formatter.dateFormat = format

  return formatter.string(from: today)
}

func helper_createDate(date: String, inputDateFormat: String = "yyyy-MM-dd HH:mm:ss Z") -> Date{
  let formatter = DateFormatter()
  formatter.dateFormat = inputDateFormat
  let datex = formatter.date(from: date)

  // Detect 12 / 24 format
  if(datex == nil){
      // 12 format
      formatter.dateFormat = "yyyy-MM-dd h:mm:ss a Z"
      return formatter.date(from: date)!
    }else{
      return datex!
    }
}

func helper_formatDate(date: Date, dateFormat: String = "yyyy-MM-dd") -> String{
  let formatter = DateFormatter()
  formatter.dateFormat = dateFormat

  return formatter.string(from: date)
}

func helper_formatDateFromString(date: String, inputDateFormat: String = "yyyy-MM-dd", outputDateFormat: String = "yyyy-MM-dd") -> String{
  let formatter = DateFormatter()
  formatter.dateFormat = inputDateFormat
  let datex = formatter.date(from: date)

  let dateRangeFormatter = DateFormatter()
  dateRangeFormatter.dateFormat = outputDateFormat

  return dateRangeFormatter.string(from: datex!)

}

func helper_formatDateTransactionList(date: Date) -> String{
  let formatter = DateFormatter()
  formatter.dateFormat = "yyyy-MM-dd HH:mm"

  return formatter.string(from: date)
}

func helper_getMonthAndYearBetween(from start: String, to end: String, dateFormat: String = "yyyy-MM-dd") -> [[String:String]] {
    let format = DateFormatter()
    format.dateFormat = dateFormat

    guard let startDate = format.date(from: start),
        let endDate = format.date(from: end) else {
            return []
    }

    let calendar = Calendar(identifier: .gregorian)
    let components = calendar.dateComponents(Set([.month]), from: startDate, to: endDate)

    var allDates: [[String:String]] = []
    let dateRangeFormatter = DateFormatter()
    dateRangeFormatter.dateFormat = "MMMM yyyy"
    let dateRangeFormatterYear = DateFormatter()
    dateRangeFormatterYear.dateFormat = "yyyy"
    let dateRangeFormatterMonth = DateFormatter()
    dateRangeFormatterMonth.dateFormat = "M"

    for i in 0 ... components.month! {
        guard let date = calendar.date(byAdding: .month, value: i, to: startDate) else {
        continue
        }

        let formattedDate = [
          "date": dateRangeFormatter.string(from: date),
          "dateYear": dateRangeFormatterYear.string(from: date),
          "dateMonth": dateRangeFormatterMonth.string(from: date)
        ]
        allDates += [formattedDate]
    }
    return allDates
}

func helper_separateDate(date: Date, inputDateFormat: String = "yyyy-MM-dd") -> [String:String] {
//    let format = DateFormatter()
//    format.dateFormat = inputDateFormat

    let dateRangeFormatterYear = DateFormatter()
    dateRangeFormatterYear.dateFormat = "yyyy"
    let dateRangeFormatterMonth = DateFormatter()
    dateRangeFormatterMonth.dateFormat = "M"
    let dateRangeFormatterTime = DateFormatter()
    dateRangeFormatterTime.dateFormat = "HH:mm"
    let dateRangeFormatterTimeHour = DateFormatter()
    dateRangeFormatterTimeHour.dateFormat = "H"
    let dateRangeFormatterTimeMinute = DateFormatter()
    dateRangeFormatterTimeMinute.dateFormat = "m"

    let formattedDate = [
      "dateYear": dateRangeFormatterYear.string(from: date),
      "dateMonth": dateRangeFormatterMonth.string(from: date),
      "time"      : dateRangeFormatterTime.string(from: date),
      "timeHour"      : dateRangeFormatterTimeHour.string(from: date),
      "timeMinute"      : dateRangeFormatterTimeMinute.string(from: date)
    ]

    return formattedDate
}

func helper_separateDateInt(date: Date, inputDateFormat: String = "yyyy-MM-dd") -> [String:Int] {
//    let format = DateFormatter()
//    format.dateFormat = inputDateFormat

    let dateRangeFormatterYear = DateFormatter()
    dateRangeFormatterYear.dateFormat = "yyyy"
    let dateRangeFormatterMonth = DateFormatter()
    dateRangeFormatterMonth.dateFormat = "M"
    let dateRangeFormatterTime = DateFormatter()
    dateRangeFormatterTime.dateFormat = "HH:mm"


    let formattedDate = [
      "dateYear": Int(dateRangeFormatterYear.string(from: date)) ?? 0,
      "dateMonth": Int(dateRangeFormatterMonth.string(from: date)) ?? 0,
      "time"      : Int(dateRangeFormatterTime.string(from: date)) ?? 0
    ]

    return formattedDate
}
