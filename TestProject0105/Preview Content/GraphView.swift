import SwiftUI
import Charts

struct LineChartView: View {
    let data: [DataPoint]

    var body: some View {
        if #available(iOS 16.0, *) {
            VStack {
                Text("My Progress")
                    .font(.headline)
                    .padding(.bottom, 10)

                Chart(data) { point in
                    LineMark(
                        x: .value("Day", point.day),
                        y: .value("Stress", point.value)
                    )
                    .foregroundStyle(.red)
                    .symbol(Circle().strokeBorder(lineWidth: 2))
                }
                .chartXAxis {
                    
                    AxisMarks(values: .automatic(desiredCount: 5))
                }
                .chartYAxis {
                    AxisMarks(values: .automatic(desiredCount: 5))
                }
                .chartXAxisLabel {
                                    Text("Day")
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                }
                                .chartYAxisLabel {
                                    Text("Stress")
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                }
                .padding()
                .frame(width: 300, height: 500)
            }
            .padding()
        } 
    }
}

struct DataPoint: Identifiable {
    let id = UUID()
    let day: Int
    let value: Double
}

struct LineChartView_Previews: PreviewProvider {
    static var previews: some View {
        LineChartView(data: [
            DataPoint(day: 1, value: 1),
            DataPoint(day: 2, value: 2),
            DataPoint(day: 3, value: 3),
            DataPoint(day: 4, value: 4),
            DataPoint(day: 5, value: 5)
        ])
    }
}
