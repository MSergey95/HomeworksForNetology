import SwiftUI

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var titleOn: Bool // Привязка к переменной titleOn

    @State private var notificationsEnabled = true
    @State private var selectedTheme = "Светлая"
    @State private var fontSize: Double = 14.0

    let themes = ["Светлая", "Темная", "Системная"]

    // Явный инициализатор для titleOn
    init(titleOn: Binding<Bool>) {
        self._titleOn = titleOn
    }

    var body: some View {
        Form {
            Section(header: Text("Общие настройки")) {
                Toggle("Включить уведомления", isOn: $notificationsEnabled)
                Picker("Тема", selection: $selectedTheme) {
                    ForEach(themes, id: \.self) { theme in
                        Text(theme)
                    }
                }
            }

            Section(header: Text("Настройки отображения")) {
                Slider(value: $fontSize, in: 10...20, step: 1) {
                    Text("Размер шрифта")
                }
                Text("Текущий размер шрифта: \(Int(fontSize))")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }

            Section {
                Text(colorScheme == .light ? "Light Theme enabled" : "Dark Theme enabled")
            }

            Section {
                // Переключатель для управления заголовком
                Toggle("Показать заголовок", isOn: $titleOn)
                if titleOn {
                    Text("Navigation title enabled")
                }
            }
        }
        .navigationTitle("Настройки")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(titleOn: .constant(true)) // Добавляем .constant для привязки
    }
}
