import SwiftUI

struct SliderView: View {
    @Binding var sliderValues: [Double]
    @Binding var dayCounter: Int
    @Binding var savedText: [String]
    @Binding var savedText2: [String]
    @State private var sliderValue: Double = 50.0
    @State private var displayText: String = ""
    @State private var notes: String = ""
    @State private var canUseSlider: Bool = true

    var body: some View {
        VStack {
            Text("How are you feeling today?")
                .font(.largeTitle)
                .padding()

            Text("Stress Level: \(Int(sliderValue))")
                .font(.title)
                .padding()

            Slider(value: $sliderValue, in: 0...100, step: 1.0)
                .padding()
                .disabled(!canUseSlider)
            
            HStack {
                Text(":D")
                    .font(.body)
                    .foregroundColor(.black)
                    .padding(.leading)
                Spacer()
                Text(":(")
                    .font(.body)
                    .foregroundColor(.black)
                    .padding(.trailing)
            }
            Spacer()

            Button(action: {
                if canUseSlider {
                    sliderValues.append(sliderValue)
                    dayCounter += 1
                    showText(value: sliderValue)
                    saveUsageDate()
                    canUseSlider = false
//                    print("Saved value: \(sliderValue)")
                }
            }) {
                Text("Save Stress Value")
                    .foregroundColor(.white)
                    .padding()

                    .background(canUseSlider ? Color.red : Color.gray)
                    .cornerRadius(10)
            }
            .disabled(!canUseSlider)

            if !displayText.isEmpty {
                Text(displayText)
                    .font(.title2)
                    .padding()
                    .foregroundColor(.blue)
                TextEditor(text: $notes)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding()

                Button(action: {
                    if sliderValue < 30 {
                        if savedText.count > 10 {
                            savedText.remove(at: 0)
                        }
                        savedText.append(notes)
//                        saveData()
                    } else if sliderValue > 60 {
                        if savedText2.count > 10 {
                            savedText2.remove(at: 0)
                        }
                        savedText2.append(notes)
//                        saveData()
                    }
                    print("Saved text: \(savedText)")
                }) {
                    Text("Save")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .onAppear {
                    loadData()
                }
                .onDisappear {
                    saveData()
                }
            }
        }
        .padding()
        .onAppear(perform: checkUsageDate)
    }

    private func showText(value: Double) {
        if value < 30 {
            displayText = "Yay! What made you less stressed today?"
        } else if value > 60 {
            displayText = "Sorry to hear! What made you stressed today?"
        } else {
            displayText = ""
        }
    }

    private func saveUsageDate() {
        let currentDate = Date()
        UserDefaults.standard.set(currentDate, forKey: "lastUsageDate")
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

    private func checkUsageDate() {
        if let lastUsageDate = UserDefaults.standard.object(forKey: "lastUsageDate") as? Date {
            let calendar = Calendar.current
            if calendar.isDateInToday(lastUsageDate) {
//                print("Slider was just used today")
                canUseSlider = false
            }
        }
    }
}

struct SliderView_Previews: PreviewProvider {
    @State static var sliderValues: [Double] = []
    @State static var dayCounter: Int = 1
    @State static var savedText: [String] = []
    @State static var savedText2: [String] = []

    static var previews: some View {
        SliderView(sliderValues: $sliderValues, dayCounter: $dayCounter, savedText: $savedText, savedText2: $savedText2)
    }
}
