//
//  ComplicationController.swift
//  Calculator WatchKit Extension
//
//  Created by Jacob Gantt on 5/12/19.
//  Copyright © 2019 LemurWare LLC. All rights reserved.
//

import ClockKit
import os.log

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward])
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry

        if let template = getTimelineEntry(for: complication){
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
        }else{
            handler(nil)
        }
    }
    
    private func getTimelineEntry(for complication: CLKComplication) -> CLKComplicationTemplate? {
        // Call the handler with the current timeline entry
        switch complication.family{
            
        case .modularSmall:
            return nil
        case .utilitarianSmall:
            return nil
        case .utilitarianSmallFlat:
            return nil
        case .circularSmall:
            return nil
        case .extraLarge:
            return nil
            
        case .graphicCorner:
            guard let image = UIImage(named: "Graphic Corner Circular") else {
                os_log("Could not find image.", log: OSLog.default, type: .error)
                return nil
            }
            let template = CLKComplicationTemplateGraphicCornerCircularImage()
            template.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
            return template
            
        case .graphicCircular:
            guard let image = UIImage(named: "Complication/Graphic Circular") else {
                os_log("Could not find image.", log: OSLog.default, type: .error)
                return nil
            }
            let template = CLKComplicationTemplateGraphicCircularImage()
            template.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
            return template
            
        case .utilitarianLarge: fallthrough
        case .graphicBezel: fallthrough
        case .graphicRectangular: fallthrough
        case .modularLarge: fallthrough
        @unknown default:
            os_log("Unexpected complication.", log: OSLog.default, type: .error)
            return nil
        }
        
    }

    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
    
}
