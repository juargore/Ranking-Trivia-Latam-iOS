//
//  GameRepositoryImpl.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import Foundation
import UIKit

struct GameRepositoryImpl: IGameRepository {
    
    private var allQuestions: [Question] = []

    init() {
        allQuestions = questionsLevelI + questionsLevelII + questionsLevelIII +
                       questionsLevelIV + questionsLevelV + questionsLevelVI +
                       questionsLevelVII + questionsLevelVIII + questionsLevelIX +
                       questionsLevelX + questionsLevelXI + questionsLevelXII +
                       questionsLevelXIII
    }
    
    func getNextQuestionLevel(currentLevel: QuestionLevel) -> QuestionLevel? {
        
        switch currentLevel {
            case .I: return .II
            case .II: return .III
            case .III: return .IV
            case .IV: return .V
            case .V: return .VI
            case .VI: return .VII
            case .VII: return .VIII
            case .VIII: return .IX
            case .IX: return .X
            case .X: return .XI
            case .XI: return .XII
            case .XII: return .XIII
            case .XIII: return nil
            }
    }
    
    func getQuestionById(id: Int) -> Question {
        return allQuestions.first { $0.id == id }!
    }
    
    func getQuestionByLevelAndExcludeTheOnesAlreadyPlayed(_ level: QuestionLevel, _ idsAlreadyPlayedByLevel: [Int]) -> Question? {
        let questionsToEvaluate: [Question]

        switch level {
        case .I: questionsToEvaluate = questionsLevelI
        case .II: questionsToEvaluate = questionsLevelII
        case .III: questionsToEvaluate = questionsLevelIII
        case .IV: questionsToEvaluate = questionsLevelIV
        case .V: questionsToEvaluate = questionsLevelV
        case .VI: questionsToEvaluate = questionsLevelVI
        case .VII: questionsToEvaluate = questionsLevelVII
        case .VIII: questionsToEvaluate = questionsLevelVIII
        case .IX: questionsToEvaluate = questionsLevelIX
        case .X: questionsToEvaluate = questionsLevelX
        case .XI: questionsToEvaluate = questionsLevelXI
        case .XII: questionsToEvaluate = questionsLevelXII
        case .XIII: questionsToEvaluate = questionsLevelXIII
        }

        let availableQuestions = questionsToEvaluate.filter { !idsAlreadyPlayedByLevel.contains($0.id) }

        if availableQuestions.isEmpty {
            return nil
        } else {
            var randomQuestion = availableQuestions.randomElement()!
            randomQuestion.gameFlags = randomQuestion.answerFlags.shuffled()
            return randomQuestion
        }
    }
    
    func getTriviaFlagById(flagId: FlagId) -> TriviaFlag {
        return allFlags.first { $0.id == flagId }!
    }
    
    func getAllTriviaFlags() -> [TriviaFlag] {
        return allFlags
    }
    
    func getEmptySpacesByLevel(level: QuestionLevel) -> [EmptySpace] {
        let numberOfSpaces: Int

        switch level {
            case .I: numberOfSpaces = 3
            case .II: numberOfSpaces = 3
            case .III: numberOfSpaces = 3
            case .IV: numberOfSpaces = 4
            case .V: numberOfSpaces = 6
            case .VI: numberOfSpaces = 5
            case .VII: numberOfSpaces = 4
            case .VIII: numberOfSpaces = 3
            case .IX: numberOfSpaces = 3
            case .X: numberOfSpaces = 4
            case .XI: numberOfSpaces = 4
            case .XII: numberOfSpaces = 3
            case .XIII: numberOfSpaces = 3
        }

        return (0..<numberOfSpaces).map { EmptySpace(id: $0) }
    }
    
    
    func verifyIfListIsCorrect(userResponse: [FlagId], question: Question) -> Bool {
        let expectedCount: Int
            
        switch question.level {
            case .I: expectedCount = 3
            case .II: expectedCount = 3
            case .III: expectedCount = 3
            case .IV: expectedCount = 4
            case .V: expectedCount = 6
            case .VI: expectedCount = 5
            case .VII: expectedCount = 4
            case .VIII: expectedCount = 3
            case .IX: expectedCount = 3
            case .X: expectedCount = 4
            case .XI: expectedCount = 4
            case .XII: expectedCount = 3
            case .XIII: expectedCount = 3
        }

        return userResponse == Array(question.answerFlags.prefix(expectedCount))
    }
    
    // ======= Constants section ======= //

    private let allFlags: [TriviaFlag] = [
        TriviaFlag(id: .AR, name: NSLocalizedString("country_name_argentina", comment: ""), image: "flag_argentina", alreadyPlayed: false),
        TriviaFlag(id: .BZ, name: NSLocalizedString("country_name_belize", comment: ""), image: "flag_belize", alreadyPlayed: false),
        TriviaFlag(id: .BO, name: NSLocalizedString("country_name_bolivia", comment: ""), image: "flag_bolivia", alreadyPlayed: false),
        TriviaFlag(id: .BR, name: NSLocalizedString("country_name_brasil", comment: ""), image: "flag_brasil", alreadyPlayed: false),
        TriviaFlag(id: .CL, name: NSLocalizedString("country_name_chile", comment: ""), image: "flag_chile", alreadyPlayed: false),
        TriviaFlag(id: .CO, name: NSLocalizedString("country_name_colombia", comment: ""), image: "flag_colombia", alreadyPlayed: false),
        TriviaFlag(id: .CR, name: NSLocalizedString("country_name_costa_rica", comment: ""), image: "flag_costa_rica", alreadyPlayed: false),
        TriviaFlag(id: .CU, name: NSLocalizedString("country_name_cuba", comment: ""), image: "flag_cuba", alreadyPlayed: false),
        TriviaFlag(id: .EC, name: NSLocalizedString("country_name_ecuador", comment: ""), image: "flag_ecuador", alreadyPlayed: false),
        TriviaFlag(id: .JM, name: NSLocalizedString("country_name_jamaica", comment: ""), image: "flag_jamaica", alreadyPlayed: false),
        TriviaFlag(id: .SV, name: NSLocalizedString("country_name_el_salvador", comment: ""), image: "flag_el_salvador", alreadyPlayed: false),
        TriviaFlag(id: .GP, name: NSLocalizedString("country_name_guadalupe", comment: ""), image: "flag_guadalupe", alreadyPlayed: false),
        TriviaFlag(id: .GT, name: NSLocalizedString("country_name_guatemala", comment: ""), image: "flag_guatemala", alreadyPlayed: false),
        TriviaFlag(id: .GF, name: NSLocalizedString("country_name_guayana_francesa", comment: ""), image: "flag_guayana_francesa", alreadyPlayed: false),
        TriviaFlag(id: .GY, name: NSLocalizedString("country_name_guyana", comment: ""), image: "flag_guyana", alreadyPlayed: false),
        TriviaFlag(id: .HT, name: NSLocalizedString("country_name_haiti", comment: ""), image: "flag_haiti", alreadyPlayed: false),
        TriviaFlag(id: .HN, name: NSLocalizedString("country_name_honduras", comment: ""), image: "flag_honduras", alreadyPlayed: false),
        TriviaFlag(id: .MF, name: NSLocalizedString("country_name_isla_san_martin", comment: ""), image: "flag_isla_san_martin", alreadyPlayed: false),
        TriviaFlag(id: .MQ, name: NSLocalizedString("country_name_martinica", comment: ""), image: "flag_martinica", alreadyPlayed: false),
        TriviaFlag(id: .MX, name: NSLocalizedString("country_name_mexico", comment: ""), image: "flag_mexico", alreadyPlayed: false),
        TriviaFlag(id: .NI, name: NSLocalizedString("country_name_nicaragua", comment: ""), image: "flag_nicaragua", alreadyPlayed: false),
        TriviaFlag(id: .PA, name: NSLocalizedString("country_name_panama", comment: ""), image: "flag_panama", alreadyPlayed: false),
        TriviaFlag(id: .PY, name: NSLocalizedString("country_name_paraguay", comment: ""), image: "flag_paraguay", alreadyPlayed: false),
        TriviaFlag(id: .PE, name: NSLocalizedString("country_name_peru", comment: ""), image: "flag_peru", alreadyPlayed: false),
        TriviaFlag(id: .PR, name: NSLocalizedString("country_name_puerto_rico", comment: ""), image: "flag_puerto_rico", alreadyPlayed: false),
        TriviaFlag(id: .DO, name: NSLocalizedString("country_name_republica_dominicana", comment: ""), image: "flag_republica_dominicana", alreadyPlayed: false),
        TriviaFlag(id: .SR, name: NSLocalizedString("country_name_surinam", comment: ""), image: "flag_surinam", alreadyPlayed: false),
        TriviaFlag(id: .UY, name: NSLocalizedString("country_name_uruguay", comment: ""), image: "flag_uruguay", alreadyPlayed: false),
        TriviaFlag(id: .VE, name: NSLocalizedString("country_name_venezuela", comment: ""), image: "flag_venezuela", alreadyPlayed: false)
    ]
    
    
    let questionsLevelI: [Question] = [
        Question(id: 11, level: .I, description: "¿Qué país ha ganado más MUNDIALES en su historia?", answerFlags: [.BR, .AR, .UY]),
        Question(id: 12, level: .I, description: "¿Quién tiene mayor EXTENSIÓN territorial?", answerFlags: [.BR, .AR, .MX]),
        Question(id: 13, level: .I, description: "¿Qué país tiene mayor POBLACIÓN?", answerFlags: [.BR, .MX, .CO]),
        Question(id: 14, level: .I, description: "¿Quién tiene más VOLCANES ACTIVOS?", answerFlags: [.CL, .MX, .GT]),
        Question(id: 15, level: .I, description: "¿Donde hay mas VENEZOLANOS fuera de VENEZUELA en Latinoamérica?", answerFlags: [.CO, .PE, .BR]),
        Question(id: 16, level: .I, description: "¿Quién tiene más sitios declarados PATRIMONIO de la HUMANIDAD en Centroamérica y el Caribe?", answerFlags: [.CU, .GT, .PA]),
        Question(id: 17, level: .I, description: "¿Dónde hay más fanáticos de Dragon Ball según Bandai?", answerFlags: [.BO, .PE, .MX])
    ]

    let questionsLevelII: [Question] = [
        Question(id: 21, level: .II, description: "¿Quién tiene mayor SUPERFICIE de selva AMAZÓNICA?", answerFlags: [.BR, .PE, .BO, .VE]),
        Question(id: 22, level: .II, description: "¿Qué países tienen la MAYOR tasa de CRÍMENES?", answerFlags: [.CO, .MX, .PY, .EC]),
        Question(id: 23, level: .II, description: "¿Quién tiene los RÍOS más LARGOS de Latinoamérica?", answerFlags: [.BR, .VE, .BO, .PY]),
        Question(id: 24, level: .II, description: "¿Quién produce más PLATA en la región?", answerFlags: [.MX, .PE, .BO, .CL]),
        Question(id: 25, level: .II, description: "¿Quién tiene más medallas olímpicas en ATLETISMO?", answerFlags: [.CU, .JM, .PR, .VE]),
        Question(id: 26, level: .II, description: "¿Quién tiene más hectáreas para el cultivo del CAFÉ en Centroamérica?", answerFlags: [.HN, .GT, .NI, .SV]),
        Question(id: 27, level: .II, description: "¿Quién tiene la mayor cantidad de sitios arqueológicos MAYAS?", answerFlags: [.GT, .MX, .BZ, .HN])
    ]

    let questionsLevelIII: [Question] = [
        Question(id: 31, level: .III, description: "¿Qué países buscan más anime en los últimos años en internet?", answerFlags: [.BO, .SV, .PE, .CR, .PA]),
        Question(id: 32, level: .III, description: "¿Quién tiene mayor producción de RON en el CARIBE?", answerFlags: [.DO, .CU, .PR, .JM, .MQ]),
        Question(id: 33, level: .III, description: "¿Quién tiene mayor densidad poblacional (PAÍSES PEQUEÑOS)?", answerFlags: [.MF, .HT, .PR, .SV, .JM]),
        Question(id: 34, level: .III, description: "¿Quién tiene mayor porcentaje de ÁREAS PROTEGIDAS en relación con su tamaño?", answerFlags: [.CR, .SR, .EC, .PA, .NI]),
        Question(id: 35, level: .III, description: "¿Quién tiene más TURISMO internacional en el caribe?", answerFlags: [.DO, .CU, .PR, .JM, .MQ]),
        Question(id: 36, level: .III, description: "¿Quién mayor BIODIVERSIDAD marina en el Caribe y Centroamérica?", answerFlags: [.SR, .MQ, .DO, .BZ, .JM]),
        Question(id: 37, level: .III, description: "¿Quién tiene más ISLAS como parte de su territorio?", answerFlags: [.CL, .VE, .CU, .DO, .PA])
    ]

    let questionsLevelIV: [Question] = [
        Question(id: 41, level: .IV, description: "¿A dónde han emigrado mas ECUATORIANOS desde 2021 en Latinoamérica?", answerFlags: [.CO, .PE, .PA, .MX, .AR]),
        Question(id: 42, level: .IV, description: "¿Qué países han ganado más Premios Goya a la Mejor Película Iberoamericana?", answerFlags: [.AR, .CL, .CU, .MX, .UY, .CO]),
        Question(id: 43, level: .IV, description: "¿Qué países han tenido más directores galardonados internacionalmente?", answerFlags: [.MX, .AR, .BR, .CL, .CU, .CO]),
        Question(id: 44, level: .IV, description: "¿Qué países tienen mayor extensión de costa en Centroamérica y el Caribe?", answerFlags: [.CU, .PA, .CR, .DO, .JM, .NI]),
        Question(id: 45, level: .IV, description: "¿Qué países han clasificado más veces a la Copa Mundial de la FIFA?", answerFlags: [.BR, .AR, .MX, .UY, .CL, .PY]),
        Question(id: 46, level: .IV, description: "¿Quién EXPORTA más FRUTAS tropicales?", answerFlags: [.EC, .CR, .CO, .MX, .PE, .HN]),
        Question(id: 47, level: .IV, description: "¿Donde hay mas CHILENOS fuera de CHILE en Latinoamérica?", answerFlags: [.AR, .BR, .VE, .PE, .EC])
    ]

    let questionsLevelV: [Question] = [
        Question(id: 51, level: .V, description: "¿Quién tiene la ECONOMÍA más grande según su PIB?", answerFlags: [.BR, .MX, .AR, .CL, .PE, .CO]),
        Question(id: 52, level: .V, description: "¿Quién tiene la mayor producción de PETRÓLEO?", answerFlags: [.VE, .BR, .MX, .AR, .CO, .EC]),
        Question(id: 53, level: .V, description: "¿Donde hay mas PARAGUAYOS fuera de PARAGUAY?", answerFlags: [.AR, .BR, .CL, .BO, .UY, .PE]),
        Question(id: 54, level: .V, description: "¿Qué países tuvieron más casos de COVID?", answerFlags: [.BR, .AR, .MX, .CO, .CL, .PE]),
        Question(id: 55, level: .V, description: "¿En qué países de la región es más popular el anime One Piece?", answerFlags: [.MX, .AR, .BR, .CL, .PE, .CO]),
        Question(id: 56, level: .V, description: "¿Quién tiene mayor cantidad de Patrimonios de la Humanidad según la UNESCO?", answerFlags: [.MX, .BR, .PE, .AR, .CL, .CU]),
        Question(id: 57, level: .V, description: "¿Quién tiene mayor cobertura de INTERNET?", answerFlags: [.UY, .CL, .AR, .CR, .BR, .MX]),
        Question(id: 58, level: .V, description: "¿Qué países han ganado más veces la COPA AMÉRICA?", answerFlags: [.AR, .UY, .BR, .PE, .PY, .CL])
    ]
    
    private let questionsLevelVI: [Question] = [
        Question(id: 61, level: .VI, description: "¿Quién tiene las FUERZAS MILITARES más grandes según el número de efectivos?", answerFlags: [.BR, .MX, .CL, .AR, .VE, .PE]),
        Question(id: 62, level: .VI, description: "¿Quién tiene mayor EXTENSIÓN DE COSTA en Latinoamérica?", answerFlags: [.CL, .BR, .AR, .MX, .PE, .CL]),
        Question(id: 63, level: .VI, description: "¿Quién produce más AZÚCAR en Latinoamérica?", answerFlags: [.BR, .MX, .CO, .AR, .GT, .CU]),
        Question(id: 64, level: .VI, description: "Según Taste Atlas, quiénes tienen la MEJOR gastronomía de la región?", answerFlags: [.MX, .PE, .BR, .AR, .CL, .CO]),
        Question(id: 65, level: .VI, description: "¿Quién genera más ENERGÍA HIDROELÉCTRICA?", answerFlags: [.BR, .VE, .PY, .AR, .CO, .CR]),
        Question(id: 66, level: .VI, description: "¿Donde hay mas COLOMBIANOS fuera de COLOMBIA en Latinoamérica?", answerFlags: [.VE, .CL, .EC, .PA, .MX]),
        Question(id: 67, level: .VI, description: "¿Quién PRODUCE más FLORES en la región?", answerFlags: [.CL, .EC, .MX, .BR, .CR, .GT])
    ]

    private let questionsLevelVII: [Question] = [
        Question(id: 71, level: .VII, description: "¿Qué países han ganado más veces el Premio Ariel a la Mejor Película Iberoamericana?", answerFlags: [.AR, .CL, .BR, .PE, .CO, .UY]),
        Question(id: 72, level: .VII, description: "¿Qué países reciben más turistas internacionales en Centroamérica y el Caribe?", answerFlags: [.DO, .CU, .PR, .CR, .PA, .JM]),
        Question(id: 73, level: .VII, description: "¿Qué países tienen la mayor producción de café en Centroamérica y el Caribe?", answerFlags: [.HN, .GT, .NI, .CR, .SV, .DO]),
        Question(id: 74, level: .VII, description: "¿Donde hay mas MEXICANOS fuera de MÉXICO en Latinoamérica?", answerFlags: [.GT, .BO, .CL, .AR, .PA]),
        Question(id: 75, level: .VII, description: "¿Qué países han producido más películas de comedia exitosas en Latinoamérica?", answerFlags: [.MX, .AR, .BR, .CL, .CO, .PE]),
        Question(id: 76, level: .VII, description: "¿Qué países han tenido más películas seleccionadas en el Festival de Cine de Berlín?", answerFlags: [.AR, .BR, .CL, .MX, .CO, .VE]),
        Question(id: 77, level: .VII, description: "Según Taste Atlas, ¿cómo ordenó los países según su PLATO PRINCIPAL (no su gastronomía general)?", answerFlags: [.AR, .BR, .CO, .CL, .MX, .PR])
    ]

    private let questionsLevelVIII: [Question] = [
        Question(id: 81, level: .VIII, description: "¿Donde hay mas URUGUAYOS fuera de URUGUAY en Latinoamérica?", answerFlags: [.AR, .BR, .CL, .VE, .MX]),
        Question(id: 82, level: .VIII, description: "¿Qué países han tenido más nominaciones al Óscar en la categoría de Mejor Película Internacional?", answerFlags: [.AR, .MX, .BR, .CL, .UY, .PE]),
        Question(id: 83, level: .VIII, description: "¿Qué países tienen más festivales de cine internacionales reconocidos?", answerFlags: [.AR, .BR, .MX, .CL, .UY, .CO]),
        Question(id: 84, level: .VIII, description: "¿Quién tiene las economías más grandes en Centroamérica y el Caribe según su PIB?", answerFlags: [.DO, .GT, .CR, .PA, .SV, .HN]),
        Question(id: 85, level: .VIII, description: "¿Qué países han ganado más Premios Platino del Cine Iberoamericano?", answerFlags: [.AR, .CL, .BR, .MX, .UY, .PE]),
        Question(id: 86, level: .VIII, description: "¿Qué países han producido más películas con nominaciones a festivales internacionales?", answerFlags: [.AR, .BR, .CL, .MX, .UY, .CU]),
        Question(id: 87, level: .VIII, description: "¿Qué países han tenido más actores nominados al Óscar?", answerFlags: [.MX, .AR, .BR, .CL, .CU, .CO])
    ]

    // TODO: Blur flags here!!! V2

    private let questionsLevelIX = [
        Question(id: 91, level: .IX, description: "¿Qué países tienen más producciones animadas reconocidas internacionalmente?", answerFlags: [.BR, .AR, .CL, .MX, .UY, .CO]),
        Question(id: 92, level: .IX, description: "¿Qué países han tenido más películas seleccionadas en el Festival de Cannes?", answerFlags: [.BR, .AR, .MX, .CL, .PE, .UY]),
        Question(id: 93, level: .IX, description: "¿Qué países han producido más documentales premiados a nivel internacional?", answerFlags: [.AR, .BR, .CL, .MX, .CO, .PE]),
        Question(id: 94, level: .IX, description: "¿Qué países tienen más producciones de cine independiente reconocidas?", answerFlags: [.AR, .BR, .CL, .MX, .CO, .PE]), // todo
        Question(id: 95, level: .IX, description: "¿Qué países han sido sede del Festival de Cine de Cartagena?", answerFlags: [.CO, .BR, .AR, .MX, .CL, .VE]), // todo
        Question(id: 96, level: .IX, description: "¿Qué países tienen más películas basadas en hechos históricos reconocidas internacionalmente?", answerFlags: [.AR, .BR, .CL, .MX, .CU, .PE]), // todo
        Question(id: 97, level: .IX, description: "¿Qué países han ganado más premios en el Festival de Cine de Mar del Plata?", answerFlags: [.AR, .BR, .MX, .UY, .CL, .PY]),
        Question(id: 98, level: .IX, description: "¿A dónde han emigrado más BRASILEÑOS desde 2022 en Latinoamérica?", answerFlags: [.PA, .AR, .BO, .CL, .PE])
    ]

    private let questionsLevelX = [
        Question(id: 101, level: .X, description: "¿Qué países han producido más películas de cine negro?", answerFlags: [.MX, .AR, .BR, .CL, .CO, .PE]), // todo
        Question(id: 102, level: .X, description: "¿Qué países han tenido más películas presentadas en el Festival de San Sebastián?", answerFlags: [.AR, .BR, .CL, .MX, .CO, .PE]), // todo
        Question(id: 103, level: .X, description: "¿Qué países tienen mayor cantidad de manglares en Centroamérica y el Caribe?", answerFlags: [.CU, .NI, .HN, .GT, .PA, .CR]), // todo
        Question(id: 104, level: .X, description: "¿Qué países han producido más películas sobre conflictos sociales en Latinoamérica?", answerFlags: [.AR, .BR, .CL, .MX, .CO, .BO]), // todo
        Question(id: 105, level: .X, description: "¿A dónde han emigrado más ARGENTINOS desde 2021 en Latinoamérica?", answerFlags: [.CL, .PY, .BO, .BR, .UY]),
        Question(id: 106, level: .X, description: "¿Qué países tienen más películas de animación infantil reconocidas?", answerFlags: [.AR, .BR, .MX, .CL, .CO, .UY]),
        Question(id: 107, level: .X, description: "¿Qué países producen más caña de azúcar en Centroamérica y el Caribe?", answerFlags: [.GT, .CU, .DO, .HN, .SV, .CR])
    ]
    
    private let questionsLevelXI: [Question] = [
        Question(id: 111, level: .XI, description: "¿Quién tiene la mayor producción de carne vacuna?", answerFlags: [.BR, .AR, .MX, .UY, .PY, .CO]),
        Question(id: 112, level: .XI, description: "¿Quién tiene mayor extensión de selva tropical?", answerFlags: [.BR, .PE, .CO, .VE, .BO, .EC]),
        Question(id: 113, level: .XI, description: "¿Quién tiene los salarios mínimos más altos?", answerFlags: [.CR, .CL, .UY, .AR, .PA, .MX]),
        Question(id: 114, level: .XI, description: "¿Quién tiene mayor producción de energía geotérmica?", answerFlags: [.MX, .SV, .CR, .NI, .GT, .HN]),
        Question(id: 115, level: .XI, description: "¿Quién PRODUCE más vino en Latinoamérica?", answerFlags: [.AR, .CL, .BR, .UY, .PE, .BO]),
        Question(id: 116, level: .XI, description: "¿Quién tiene mayor superficie de tierras agrícolas?", answerFlags: [.BR, .AR, .MX, .PY, .CO, .VE]),
        Question(id: 117, level: .XI, description: "¿Quién tiene más variedad de especies de aves?", answerFlags: [.CL, .PE, .BR, .EC, .VE, .BO])
    ]

    private let questionsLevelXII: [Question] = [
        Question(id: 121, level: .XII, description: "¿Quién tiene la mayor producción de banano?", answerFlags: [.EC, .CR, .GT, .CO, .HN, .DO]),
        Question(id: 122, level: .XII, description: "¿Quién genera más electricidad a partir de fuentes renovables?", answerFlags: [.PY, .UY, .CR, .BR, .CL, .NI]),
        Question(id: 123, level: .XII, description: "¿Quién tiene la mayor producción de productos lácteos?", answerFlags: [.BR, .AR, .MX, .UY, .CO, .CL]),
        Question(id: 124, level: .XII, description: "¿Quién tiene la mayor biodiversidad marina?", answerFlags: [.BR, .MX, .CO, .CL, .VE, .PE]),
        Question(id: 125, level: .XII, description: "¿Quién tiene más líneas de metro?", answerFlags: [.MX, .BR, .CL, .VE, .AR, .PE]),
        Question(id: 126, level: .XII, description: "¿Quién tiene mayor superficie de áreas protegidas?", answerFlags: [.BR, .CO, .VE, .AR, .CL, .PE]),
        Question(id: 127, level: .XII, description: "¿Quién tiene más selvas tropicales protegidas?", answerFlags: [.BR, .CO, .VE, .PE, .BO, .EC]),
        Question(id: 128, level: .XII, description: "¿Qué países han tenido más equipos ganadores de la Copa Libertadores?", answerFlags: [.AR, .BR, .UY, .CO, .PY, .CL])
    ]

    private let questionsLevelXIII: [Question] = [
        Question(id: 131, level: .XIII, description: "¿Quién tiene los puertos marítimos más grandes?", answerFlags: [.BR, .PA, .MX, .CL, .CO, .AR]),
        Question(id: 132, level: .XIII, description: "¿Quién tiene la mayor cantidad de producción de camarones?", answerFlags: [.EC, .MX, .VE, .BR, .CO, .HN]),
        Question(id: 133, level: .XIII, description: "¿Quién tiene las tasas de alfabetización más altas?", answerFlags: [.CU, .UY, .CL, .AR, .CR, .PA]),
        Question(id: 134, level: .XIII, description: "¿Quién tiene la mayor producción de cacao?", answerFlags: [.EC, .BR, .PE, .CO, .VE, .DO]),
        Question(id: 135, level: .XIII, description: "¿Quién tiene mayor producción de plata?", answerFlags: [.MX, .PE, .CL, .BO, .AR, .GT]),
        Question(id: 136, level: .XIII, description: "Según Taste Atlas, quiénes tienen la PEOR gastronomía de la región?", answerFlags: [.CR, .HN, .GT, .SV, .NI, .PY]),
        Question(id: 137, level: .XIII, description: "¿Quién tiene mayor producción de maíz?", answerFlags: [.BR, .MX, .AR, .PY, .PE, .VE]),
        Question(id: 138, level: .XIII, description: "¿Qué países tienen más títulos de la Copa Sudamericana?", answerFlags: [.AR, .BR, .EC, .CO, .CL, .MX])
    ]

}
