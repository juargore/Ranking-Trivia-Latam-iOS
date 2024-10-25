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
        allQuestions = questionsLevelI + questionsLevelII + questionsLevelIII + questionsLevelIV +
            questionsLevelV + questionsLevelVI + questionsLevelVII + questionsLevelVIII + questionsLevelIX +
            questionsLevelX + questionsLevelXI + questionsLevelXII + questionsLevelXIII
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
        Question(id: 11, level: .I, description: NSLocalizedString("question_i_11", comment: ""), answerFlags: [.BR, .AR, .UY]),
        Question(id: 12, level: .I, description: NSLocalizedString("question_i_12", comment: ""), answerFlags: [.BR, .AR, .MX]),
        Question(id: 13, level: .I, description: NSLocalizedString("question_i_13", comment: ""), answerFlags: [.BR, .MX, .CO]),
        Question(id: 14, level: .I, description: NSLocalizedString("question_i_14", comment: ""), answerFlags: [.CL, .MX, .GT]),
        Question(id: 15, level: .I, description: NSLocalizedString("question_i_15", comment: ""), answerFlags: [.CO, .PE, .BR]),
        Question(id: 16, level: .I, description: NSLocalizedString("question_i_16", comment: ""), answerFlags: [.CU, .GT, .PA]),
        Question(id: 17, level: .I, description: NSLocalizedString("question_i_17", comment: ""), answerFlags: [.BO, .PE, .MX])
    ]

    let questionsLevelII: [Question] = [
        Question(id: 21, level: .II, description: NSLocalizedString("question_ii_21", comment: ""), answerFlags: [.BR, .PE, .BO, .VE]),
        Question(id: 22, level: .II, description: NSLocalizedString("question_ii_22", comment: ""), answerFlags: [.CO, .MX, .PY, .EC]),
        Question(id: 23, level: .II, description: NSLocalizedString("question_ii_23", comment: ""), answerFlags: [.BR, .VE, .BO, .PY]),
        Question(id: 24, level: .II, description: NSLocalizedString("question_ii_24", comment: ""), answerFlags: [.MX, .PE, .BO, .CL]),
        Question(id: 25, level: .II, description: NSLocalizedString("question_ii_25", comment: ""), answerFlags: [.CU, .JM, .PR, .VE]),
        Question(id: 26, level: .II, description: NSLocalizedString("question_ii_26", comment: ""), answerFlags: [.HN, .GT, .NI, .SV]),
        Question(id: 27, level: .II, description: NSLocalizedString("question_ii_27", comment: ""), answerFlags: [.GT, .MX, .BZ, .HN])
    ]

    let questionsLevelIII: [Question] = [
        Question(id: 31, level: .III, description: NSLocalizedString("question_iii_31", comment: ""), answerFlags: [.BO, .SV, .PE, .CR, .PA]),
        Question(id: 32, level: .III, description: NSLocalizedString("question_iii_32", comment: ""), answerFlags: [.DO, .CU, .PR, .JM, .MQ]),
        Question(id: 33, level: .III, description: NSLocalizedString("question_iii_33", comment: ""), answerFlags: [.MF, .HT, .PR, .SV, .JM]),
        Question(id: 34, level: .III, description: NSLocalizedString("question_iii_34", comment: ""), answerFlags: [.CR, .SR, .EC, .PA, .NI]),
        Question(id: 35, level: .III, description: NSLocalizedString("question_iii_35", comment: ""), answerFlags: [.DO, .CU, .PR, .JM, .MQ]),
        Question(id: 36, level: .III, description: NSLocalizedString("question_iii_36", comment: ""), answerFlags: [.SR, .MQ, .DO, .BZ, .JM]),
        Question(id: 37, level: .III, description: NSLocalizedString("question_iii_37", comment: ""), answerFlags: [.CL, .VE, .CU, .DO, .PA])
    ]

    let questionsLevelIV: [Question] = [
        Question(id: 41, level: .IV, description: NSLocalizedString("question_iv_41", comment: ""), answerFlags: [.CO, .PE, .PA, .MX, .AR, .BR]),
        Question(id: 42, level: .IV, description: NSLocalizedString("question_iv_42", comment: ""), answerFlags: [.AR, .CL, .CU, .MX, .UY, .CO]),
        Question(id: 43, level: .IV, description: NSLocalizedString("question_iv_43", comment: ""), answerFlags: [.MX, .AR, .BR, .CL, .CU, .CO]),
        Question(id: 44, level: .IV, description: NSLocalizedString("question_iv_44", comment: ""), answerFlags: [.CU, .PA, .CR, .DO, .JM, .NI]),
        Question(id: 45, level: .IV, description: NSLocalizedString("question_iv_45", comment: ""), answerFlags: [.BR, .AR, .MX, .UY, .CL, .PY]),
        Question(id: 46, level: .IV, description: NSLocalizedString("question_iv_46", comment: ""), answerFlags: [.EC, .CR, .CO, .MX, .PE, .HN]),
        Question(id: 47, level: .IV, description: NSLocalizedString("question_iv_47", comment: ""), answerFlags: [.AR, .BR, .VE, .PE, .EC, .MX])
    ]

    let questionsLevelV: [Question] = [
        Question(id: 51, level: .V, description: NSLocalizedString("question_v_51", comment: ""), answerFlags: [.BR, .MX, .AR, .CL, .PE, .CO]),
        Question(id: 52, level: .V, description: NSLocalizedString("question_v_52", comment: ""), answerFlags: [.VE, .BR, .MX, .AR, .CO, .EC]),
        Question(id: 53, level: .V, description: NSLocalizedString("question_v_53", comment: ""), answerFlags: [.AR, .BR, .CL, .BO, .UY, .PE]),
        Question(id: 54, level: .V, description: NSLocalizedString("question_v_54", comment: ""), answerFlags: [.BR, .AR, .MX, .CO, .CL, .PE]),
        Question(id: 55, level: .V, description: NSLocalizedString("question_v_55", comment: ""), answerFlags: [.MX, .AR, .BR, .CL, .PE, .CO]),
        Question(id: 56, level: .V, description: NSLocalizedString("question_v_56", comment: ""), answerFlags: [.MX, .BR, .PE, .AR, .CL, .CU]),
        Question(id: 57, level: .V, description: NSLocalizedString("question_v_57", comment: ""), answerFlags: [.UY, .CL, .AR, .CR, .BR, .MX]),
        Question(id: 58, level: .V, description: NSLocalizedString("question_v_58", comment: ""), answerFlags: [.AR, .UY, .BR, .PE, .PY, .CL])
    ]
    
    private let questionsLevelVI: [Question] = [
        Question(id: 61, level: .VI, description: NSLocalizedString("question_vi_61", comment: ""), answerFlags: [.BR, .MX, .CL, .AR, .VE, .PE]),
        Question(id: 62, level: .VI, description: NSLocalizedString("question_vi_62", comment: ""), answerFlags: [.CL, .BR, .AR, .MX, .PE, .CL]),
        Question(id: 63, level: .VI, description: NSLocalizedString("question_vi_63", comment: ""), answerFlags: [.BR, .MX, .CO, .AR, .GT, .CU]),
        Question(id: 64, level: .VI, description: NSLocalizedString("question_vi_64", comment: ""), answerFlags: [.MX, .PE, .BR, .AR, .CL, .CO]),
        Question(id: 65, level: .VI, description: NSLocalizedString("question_vi_65", comment: ""), answerFlags: [.BR, .VE, .PY, .AR, .CO, .CR]),
        Question(id: 66, level: .VI, description: NSLocalizedString("question_vi_66", comment: ""), answerFlags: [.VE, .CL, .EC, .PA, .MX, .AR]),
        Question(id: 67, level: .VI, description: NSLocalizedString("question_vi_67", comment: ""), answerFlags: [.CL, .EC, .MX, .BR, .CR, .GT])
    ]

    private let questionsLevelVII: [Question] = [
        Question(id: 71, level: .VII, description: NSLocalizedString("question_vii_71", comment: ""), answerFlags: [.AR, .CL, .BR, .PE, .CO, .UY]),
        Question(id: 72, level: .VII, description: NSLocalizedString("question_vii_72", comment: ""), answerFlags: [.DO, .CU, .PR, .CR, .PA, .JM]),
        Question(id: 73, level: .VII, description: NSLocalizedString("question_vii_73", comment: ""), answerFlags: [.HN, .GT, .NI, .CR, .SV, .DO]),
        Question(id: 74, level: .VII, description: NSLocalizedString("question_vii_74", comment: ""), answerFlags: [.GT, .BO, .CL, .AR, .PA, .HN]),
        Question(id: 75, level: .VII, description: NSLocalizedString("question_vii_75", comment: ""), answerFlags: [.MX, .AR, .BR, .CL, .CO, .PE]),
        Question(id: 76, level: .VII, description: NSLocalizedString("question_vii_76", comment: ""), answerFlags: [.AR, .BR, .CL, .MX, .CO, .VE]),
        Question(id: 77, level: .VII, description: NSLocalizedString("question_vii_77", comment: ""), answerFlags: [.AR, .BR, .CO, .CL, .MX, .PR])
    ]

    private let questionsLevelVIII: [Question] = [
        Question(id: 81, level: .VIII, description: NSLocalizedString("question_viii_81", comment: ""), answerFlags: [.AR, .BR, .CL, .VE, .MX, .CO]),
        Question(id: 82, level: .VIII, description: NSLocalizedString("question_viii_82", comment: ""), answerFlags: [.AR, .MX, .BR, .CL, .UY, .PE]),
        Question(id: 83, level: .VIII, description: NSLocalizedString("question_viii_83", comment: ""), answerFlags: [.AR, .BR, .MX, .CL, .UY, .CO]),
        Question(id: 84, level: .VIII, description: NSLocalizedString("question_viii_84", comment: ""), answerFlags: [.DO, .GT, .CR, .PA, .SV, .HN]),
        Question(id: 85, level: .VIII, description: NSLocalizedString("question_viii_85", comment: ""), answerFlags: [.AR, .CL, .BR, .MX, .UY, .PE]),
        Question(id: 86, level: .VIII, description: NSLocalizedString("question_viii_86", comment: ""), answerFlags: [.AR, .BR, .CL, .MX, .UY, .CU]),
        Question(id: 87, level: .VIII, description: NSLocalizedString("question_viii_87", comment: ""), answerFlags: [.MX, .AR, .BR, .CL, .CU, .CO])
    ]

    // TODO: Blur flags here!!! V2

    private let questionsLevelIX = [
        Question(id: 91, level: .IX, description: NSLocalizedString("question_ix_91", comment: ""), answerFlags: [.BR, .AR, .CL, .MX, .UY, .CO]),
        Question(id: 92, level: .IX, description: NSLocalizedString("question_ix_92", comment: ""), answerFlags: [.BR, .AR, .MX, .CL, .PE, .UY]),
        Question(id: 93, level: .IX, description: NSLocalizedString("question_ix_93", comment: ""), answerFlags: [.AR, .BR, .CL, .MX, .CO, .PE]),
        Question(id: 94, level: .IX, description: NSLocalizedString("question_ix_94", comment: ""), answerFlags: [.AR, .BR, .CL, .MX, .CO, .PE]), // todo
        Question(id: 95, level: .IX, description: NSLocalizedString("question_ix_95", comment: ""), answerFlags: [.CO, .BR, .AR, .MX, .CL, .VE]), // todo
        Question(id: 96, level: .IX, description: NSLocalizedString("question_ix_96", comment: ""), answerFlags: [.AR, .BR, .CL, .MX, .CU, .PE]), // todo
        Question(id: 97, level: .IX, description: NSLocalizedString("question_ix_97", comment: ""), answerFlags: [.AR, .BR, .MX, .UY, .CL, .PY]),
        Question(id: 98, level: .IX, description: NSLocalizedString("question_ix_98", comment: ""), answerFlags: [.PA, .AR, .BO, .CL, .PE, .MX])
    ]

    private let questionsLevelX = [
        Question(id: 101, level: .X, description: NSLocalizedString("question_x_101", comment: ""), answerFlags: [.MX, .AR, .BR, .CL, .CO, .PE]), // todo
        Question(id: 102, level: .X, description: NSLocalizedString("question_x_102", comment: ""), answerFlags: [.AR, .BR, .CL, .MX, .CO, .PE]), // todo
        Question(id: 103, level: .X, description: NSLocalizedString("question_x_103", comment: ""), answerFlags: [.CU, .NI, .HN, .GT, .PA, .CR]), // todo
        Question(id: 104, level: .X, description: NSLocalizedString("question_x_104", comment: ""), answerFlags: [.AR, .BR, .CL, .MX, .CO, .BO]), // todo
        Question(id: 105, level: .X, description: NSLocalizedString("question_x_105", comment: ""), answerFlags: [.CL, .PY, .BO, .BR, .UY, .MX]),
        Question(id: 106, level: .X, description: NSLocalizedString("question_x_106", comment: ""), answerFlags: [.AR, .BR, .MX, .CL, .CO, .UY]),
        Question(id: 107, level: .X, description: NSLocalizedString("question_x_107", comment: ""), answerFlags: [.GT, .CU, .DO, .HN, .SV, .CR])
    ]
    
    private let questionsLevelXI: [Question] = [
        Question(id: 111, level: .XI, description: NSLocalizedString("question_xi_111", comment: ""), answerFlags: [.BR, .AR, .MX, .UY, .PY, .CO]),
        Question(id: 112, level: .XI, description: NSLocalizedString("question_xi_112", comment: ""), answerFlags: [.BR, .PE, .CO, .VE, .BO, .EC]),
        Question(id: 113, level: .XI, description: NSLocalizedString("question_xi_113", comment: ""), answerFlags: [.CR, .CL, .UY, .AR, .PA, .MX]),
        Question(id: 114, level: .XI, description: NSLocalizedString("question_xi_114", comment: ""), answerFlags: [.MX, .SV, .CR, .NI, .GT, .HN]),
        Question(id: 115, level: .XI, description: NSLocalizedString("question_xi_115", comment: ""), answerFlags: [.AR, .CL, .BR, .UY, .PE, .BO]),
        Question(id: 116, level: .XI, description: NSLocalizedString("question_xi_116", comment: ""), answerFlags: [.BR, .AR, .MX, .PY, .CO, .VE]),
        Question(id: 117, level: .XI, description: NSLocalizedString("question_xi_117", comment: ""), answerFlags: [.CL, .PE, .BR, .EC, .VE, .BO])
    ]

    private let questionsLevelXII: [Question] = [
        Question(id: 121, level: .XII, description: NSLocalizedString("question_xii_121", comment: ""), answerFlags: [.EC, .CR, .GT, .CO, .HN, .DO]),
        Question(id: 122, level: .XII, description: NSLocalizedString("question_xii_122", comment: ""), answerFlags: [.PY, .UY, .CR, .BR, .CL, .NI]),
        Question(id: 123, level: .XII, description: NSLocalizedString("question_xii_123", comment: ""), answerFlags: [.BR, .AR, .MX, .UY, .CO, .CL]),
        Question(id: 124, level: .XII, description: NSLocalizedString("question_xii_124", comment: ""), answerFlags: [.BR, .MX, .CO, .CL, .VE, .PE]),
        Question(id: 125, level: .XII, description: NSLocalizedString("question_xii_125", comment: ""), answerFlags: [.MX, .BR, .CL, .VE, .AR, .PE]),
        Question(id: 126, level: .XII, description: NSLocalizedString("question_xii_126", comment: ""), answerFlags: [.BR, .CO, .VE, .AR, .CL, .PE]),
        Question(id: 127, level: .XII, description: NSLocalizedString("question_xii_127", comment: ""), answerFlags: [.BR, .CO, .VE, .PE, .BO, .EC]),
        Question(id: 128, level: .XII, description: NSLocalizedString("question_xii_128", comment: ""), answerFlags: [.AR, .BR, .UY, .CO, .PY, .CL])
    ]

    private let questionsLevelXIII: [Question] = [
        Question(id: 131, level: .XIII, description: NSLocalizedString("question_xiii_131", comment: ""), answerFlags: [.BR, .PA, .MX, .CL, .CO, .AR]),
        Question(id: 132, level: .XIII, description: NSLocalizedString("question_xiii_132", comment: ""), answerFlags: [.EC, .MX, .VE, .BR, .CO, .HN]),
        Question(id: 133, level: .XIII, description: NSLocalizedString("question_xiii_133", comment: ""), answerFlags: [.CU, .UY, .CL, .AR, .CR, .PA]),
        Question(id: 134, level: .XIII, description: NSLocalizedString("question_xiii_134", comment: ""), answerFlags: [.EC, .BR, .PE, .CO, .VE, .DO]),
        Question(id: 135, level: .XIII, description: NSLocalizedString("question_xiii_135", comment: ""), answerFlags: [.MX, .PE, .CL, .BO, .AR, .GT]),
        Question(id: 136, level: .XIII, description: NSLocalizedString("question_xiii_136", comment: ""), answerFlags: [.CR, .HN, .GT, .SV, .NI, .PY]),
        Question(id: 137, level: .XIII, description: NSLocalizedString("question_xiii_137", comment: ""), answerFlags: [.BR, .MX, .AR, .PY, .PE, .VE]),
        Question(id: 138, level: .XIII, description: NSLocalizedString("question_xiii_138", comment: ""), answerFlags: [.AR, .BR, .EC, .CO, .CL, .MX])
    ]
}
