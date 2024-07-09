import SwiftUI

struct NotesView: View {
    @State private var notes: String = ""

    var body: some View {
        VStack {
            Text("Burn Note")
                .font(.largeTitle)
                .padding()

            Text("Feel free to vent on this note. Noone else will be able to see it again, not even you.")
                .font(.body)
                .foregroundColor(.gray)
                .padding()
            TextEditor(text: $notes)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding()

            Button(action: {
                notes = ""
            }) {
                Text("Erase Note")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()
        }
        .padding()
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView()
    }
}
