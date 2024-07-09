import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .faceid
    @State private var sliderValues: [Double] = []
    @State private var dayCounter: Int = 1
    @State private var savedText: [String] = []
    @State private var savedText2: [String] = []

    var body: some View {
        VStack {
            Spacer()
            switch selectedTab {
            case .faceid:
                SliderView(sliderValues: $sliderValues, dayCounter: $dayCounter, savedText: $savedText, savedText2: $savedText2)
            case .star:
                CollectionViewRepresentable()
            case .scroll:
                NotesView()
            case .chart:
                LineChartView(data: sliderValues.enumerated().map { DataPoint(day: $0.offset, value: $0.element) })
            case .pencil:
                habitsView(savedText: $savedText, savedText2: $savedText2)
            }

            Spacer()

            CustomTabBar(selectedTab: $selectedTab)
                .frame(height: 60)
                .background(Color.white.shadow(radius: 2))
        }
        .onAppear {
            loadData()
        }
        .onDisappear {
            saveData()
        }
    }

    private func saveData() {
        UserDefaults.standard.set(sliderValues, forKey: "sliderValues")
        UserDefaults.standard.set(savedText, forKey: "savedText")
        UserDefaults.standard.set(savedText2, forKey: "savedText2")
    }

    private func loadData() {
        if let savedSliderValues = UserDefaults.standard.array(forKey: "sliderValues") as? [Double] {
            sliderValues = savedSliderValues
        }
        if let saved = UserDefaults.standard.array(forKey: "savedText") as? [String] {
            savedText = saved
        }
        if let saved2 = UserDefaults.standard.array(forKey: "savedText2") as? [String] {
            savedText2 = saved2
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
