
import Foundation

struct QuizQuestion {
    let question: String               // Текст вопроса
    let options: [String]              // Варианты ответов (включает правильный и случайные неправильные)
    let correctAnswer: String          // Правильный ответ
}
