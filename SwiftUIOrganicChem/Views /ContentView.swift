import SwiftUI

struct ContentView: View {
    @AppStorage("titleOn") private var titleOn = true // Замена @State на @AppStorage

    var body: some View {
        TabView {
            InfoView(titleOn: titleOn)
                .tabItem {
                    Label("База знаний", systemImage: "book.closed")
                }

            QuizView()
                .tabItem {
                    Label("Quiz", systemImage: "questionmark.circle")
                }

            SettingsView(titleOn: $titleOn)
                .tabItem {
                    Label("Настройки", systemImage: "gearshape")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
