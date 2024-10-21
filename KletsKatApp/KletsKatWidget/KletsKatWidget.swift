import WidgetKit
import SwiftUI

struct KletskatWidgetEntry: TimelineEntry {
    let date: Date
    let catModel: CatModel?
}

struct KletskatWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> KletskatWidgetEntry {
        KletskatWidgetEntry(date: Date(), catModel: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (KletskatWidgetEntry) -> Void) {
        let entry = KletskatWidgetEntry(date: Date(), catModel: CatController.shared.catModel)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<KletskatWidgetEntry>) -> Void) {
        let entry = KletskatWidgetEntry(date: Date(), catModel: CatController.shared.catModel)
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60 * 5))) // Update elke 5 minuten
        completion(timeline)
    }
}

struct KletskatWidgetEntryView: View {
    var entry: KletskatWidgetProvider.Entry

    var body: some View {
        if let catModel = entry.catModel {
            VStack {
                Text("Cat's name: \(catModel.name)")
                    .font(.headline)
                WidgetCatView(catColor: catModel.color, eyeColor: catModel.eyeColor)
                Text("Personality: \(catModel.personality.rawValue)")
                    .font(.subheadline)
            }
            .padding()
        } else {
            Text("No cat data available")
                .padding()
        }
    }
}

struct KletsKatWidget: Widget {
    let kind: String = "KletsKatWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: KletskatWidgetProvider()
        ) { entry in
            KletskatWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("KletsKat Widget")
        .description("Shows your customized cat.")
    }
}
