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
        let entry = KletskatWidgetEntry(date: Date(), catModel: loadCatFromStorage())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<KletskatWidgetEntry>) -> Void) {
        let entry = KletskatWidgetEntry(date: Date(), catModel: loadCatFromStorage())
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }

    private func loadCatFromStorage() -> CatModel? {
        let defaults = UserDefaults(suiteName: "group.RZwinkels.KletsKatApp")
        guard let name = defaults?.string(forKey: "catName"),
              let colorString = defaults?.string(forKey: "catColor"),
              let eyeColorString = defaults?.string(forKey: "catEyeColor"),
              let personalityRaw = defaults?.string(forKey: "catPersonality"),
              let personality = Personality(from: personalityRaw) else {
            return nil
        }

        return CatModel(
            color: CatController.colorFromString(colorString),
            eyeColor: CatController.colorFromString(eyeColorString),
            name: name,
            bond: 0,
            personality: personality
        )
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
