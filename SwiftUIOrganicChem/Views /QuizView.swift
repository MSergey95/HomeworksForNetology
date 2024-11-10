
import SwiftUI

struct QuizView: View {
    @State private var questions: [QuizQuestion] = []
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: String? = nil
    @State private var score = 0
    @State private var showNextButton = false
    @State private var isQuizCompleted = false
    @State private var hasAnswered = false

    // Функция для инициализации вопросов
    private func initializeQuiz() {
        questions = generateQuestions()
    }

    // Функция для генерации вопросов на основе существующих соединений
    private func generateQuestions() -> [QuizQuestion] {
        let compounds = sampleCompounds.shuffled().prefix(5)
        return compounds.map { compound in
            let correctAnswer = compound.classification
            let options = generateOptions(for: compound)
            return QuizQuestion(question: "К какому классу относится \(compound.name)?", options: options, correctAnswer: correctAnswer)
        }
    }

    // Генерация опций с одним правильным и тремя случайными неправильными ответами
    private func generateOptions(for compound: Compound) -> [String] {
        var options = [compound.classification]
        let wrongAnswers = compoundClasses.filter { $0 != compound.classification }.shuffled().prefix(3)
        options.append(contentsOf: wrongAnswers)
        return options.shuffled()
    }

    // Обработка выбора ответа
    private func handleAnswerSelection(selectedAnswer: String) {
        if hasAnswered { return }

        hasAnswered = true
        self.selectedAnswer = selectedAnswer
        if selectedAnswer == questions[currentQuestionIndex].correctAnswer {
            score += 1
        }

        showNextButton = true
    }

    // Переход к следующему вопросу
    private func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            resetForNextQuestion()
        } else {
            isQuizCompleted = true
        }
    }

    // Сброс состояния для следующего вопроса
    private func resetForNextQuestion() {
        selectedAnswer = nil
        showNextButton = false
        hasAnswered = false
    }

    // Перезапуск квиза
    private func restartQuiz() {
        currentQuestionIndex = 0
        score = 0
        isQuizCompleted = false
        initializeQuiz()
    }

    var body: some View {
        VStack {
            if questions.isEmpty {
                Text("Инициализация квиза...")
                    .onAppear {
                        initializeQuiz()
                    }
            } else if isQuizCompleted {
                VStack {
                    Text("Квиз завершен!")
                        .font(.largeTitle)
                        .padding()
                    Text("Ваш результат: \(score) из \(questions.count)")
                        .font(.title)
                        .padding()
                    Button("Начать заново") {
                        restartQuiz()
                    }
                    .padding()
                }
            } else {
                Text("Вопрос \(currentQuestionIndex + 1) из \(questions.count)")
                    .font(.headline)
                    .padding()

                if currentQuestionIndex < questions.count {
                    Text(questions[currentQuestionIndex].question)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding()

                    ForEach(questions[currentQuestionIndex].options, id: \.self) { option in
                        Button(action: {
                            handleAnswerSelection(selectedAnswer: option)
                        }) {
                            Text(option)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(answerButtonColor(for: option))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(hasAnswered)
                    }

                    if showNextButton {
                        Button("Следующий") {
                            nextQuestion()
                        }
                        .padding()
                    }

                    Text("Результат: \(score)")
                        .font(.headline)
                        .padding(.top, 20)
                } else {
                    Text("Ошибка: Вопрос отсутствует")
                        .foregroundColor(.red)
                        .padding()
                }
            }
        }
        .padding()
        .navigationTitle("Квиз")
    }

    private func answerButtonColor(for option: String) -> Color {
        guard let selectedAnswer = selectedAnswer else { return Color.blue }
        if option == selectedAnswer {
            return option == questions[currentQuestionIndex].correctAnswer ? Color.green : Color.red
        }
        return Color.blue
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
    }
}
