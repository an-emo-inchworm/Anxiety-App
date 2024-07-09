import SwiftUI

struct habitsView: View {
    @Binding var savedText: [String]
    @Binding var savedText2: [String]

    var body: some View {
        ScrollView{
            VStack {
                Text("Things that make me happy")
                    .font(.largeTitle)
                    .padding()
                
                if !savedText.isEmpty {
                    ForEach(0..<savedText.count, id: \.self) { index in
                        Text(savedText[index])
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.vertical, 2)
                    }
                } else {
                    Text("")
                        .font(.title2)
                        .padding()
                }
                Text("Things that make me sad")
                    .font(.largeTitle)
                    .padding()
                
                if !savedText2.isEmpty {
                    ForEach(0..<savedText2.count, id: \.self) { index in
                        Text(savedText2[index])
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.vertical, 2)
                    }
                } else {
                    Text("")
                        .font(.title2)
                        .padding()
                }
            }
            .padding()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    @State static var savedText: [String] = ["Sample text from SliderView"]
    @State static var savedText2: [String] = ["Sample text evil"]
    static var previews: some View {
        habitsView(savedText: $savedText, savedText2: $savedText2)
    }
}
