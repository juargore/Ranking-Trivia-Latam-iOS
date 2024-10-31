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
        TriviaFlag(id: .AR, name: "country_name_argentina".loc, image: "flag_argentina", alreadyPlayed: false),
        TriviaFlag(id: .BZ, name: "country_name_belize".loc, image: "flag_belize", alreadyPlayed: false),
        TriviaFlag(id: .BO, name: "country_name_bolivia".loc, image: "flag_bolivia", alreadyPlayed: false),
        TriviaFlag(id: .BR, name: "country_name_brasil".loc, image: "flag_brasil", alreadyPlayed: false),
        TriviaFlag(id: .CL, name: "country_name_chile".loc, image: "flag_chile", alreadyPlayed: false),
        TriviaFlag(id: .CO, name: "country_name_colombia".loc, image: "flag_colombia", alreadyPlayed: false),
        TriviaFlag(id: .CR, name: "country_name_costa_rica".loc, image: "flag_costa_rica", alreadyPlayed: false),
        TriviaFlag(id: .CU, name: "country_name_cuba".loc, image: "flag_cuba", alreadyPlayed: false),
        TriviaFlag(id: .EC, name: "country_name_ecuador".loc, image: "flag_ecuador", alreadyPlayed: false),
        TriviaFlag(id: .JM, name: "country_name_jamaica".loc, image: "flag_jamaica", alreadyPlayed: false),
        TriviaFlag(id: .SV, name: "country_name_el_salvador".loc, image: "flag_el_salvador", alreadyPlayed: false),
        TriviaFlag(id: .GP, name: "country_name_guadalupe".loc, image: "flag_guadalupe", alreadyPlayed: false),
        TriviaFlag(id: .GT, name: "country_name_guatemala".loc, image: "flag_guatemala", alreadyPlayed: false),
        TriviaFlag(id: .GF, name: "country_name_guayana_francesa".loc, image: "flag_guayana_francesa", alreadyPlayed: false),
        TriviaFlag(id: .GY, name: "country_name_guyana".loc, image: "flag_guyana", alreadyPlayed: false),
        TriviaFlag(id: .HT, name: "country_name_haiti".loc, image: "flag_haiti", alreadyPlayed: false),
        TriviaFlag(id: .HN, name: "country_name_honduras".loc, image: "flag_honduras", alreadyPlayed: false),
        TriviaFlag(id: .MF, name: "country_name_isla_san_martin".loc, image: "flag_isla_san_martin", alreadyPlayed: false),
        TriviaFlag(id: .MQ, name: "country_name_martinica".loc, image: "flag_martinica", alreadyPlayed: false),
        TriviaFlag(id: .MX, name: "country_name_mexico".loc, image: "flag_mexico", alreadyPlayed: false),
        TriviaFlag(id: .NI, name: "country_name_nicaragua".loc, image: "flag_nicaragua", alreadyPlayed: false),
        TriviaFlag(id: .PA, name: "country_name_panama".loc, image: "flag_panama", alreadyPlayed: false),
        TriviaFlag(id: .PY, name: "country_name_paraguay".loc, image: "flag_paraguay", alreadyPlayed: false),
        TriviaFlag(id: .PE, name: "country_name_peru".loc, image: "flag_peru", alreadyPlayed: false),
        TriviaFlag(id: .PR, name: "country_name_puerto_rico".loc, image: "flag_puerto_rico", alreadyPlayed: false),
        TriviaFlag(id: .DO, name: "country_name_republica_dominicana".loc, image: "flag_republica_dominicana", alreadyPlayed: false),
        TriviaFlag(id: .SR, name: "country_name_surinam".loc, image: "flag_surinam", alreadyPlayed: false),
        TriviaFlag(id: .UY, name: "country_name_uruguay".loc, image: "flag_uruguay", alreadyPlayed: false),
        TriviaFlag(id: .VE, name: "country_name_venezuela".loc, image: "flag_venezuela", alreadyPlayed: false)
    ]
    
    
    let questionsLevelI: [Question] = [
        Question(id: 11, level: .I, description: "question_i_11".loc, answerFlags: [.BR, .AR, .UY], info: "info_i_11".loc),
        Question(id: 12, level: .I, description: "question_i_12".loc, answerFlags: [.BR, .AR, .MX], info: "info_i_12".loc),
        Question(id: 13, level: .I, description: "question_i_13".loc, answerFlags: [.BR, .MX, .CO], info: "info_i_13".loc),
        Question(id: 14, level: .I, description: "question_i_14".loc, answerFlags: [.CL, .MX, .GT], info: "info_i_14".loc),
        Question(id: 15, level: .I, description: "question_i_15".loc, answerFlags: [.CO, .PE, .BR], info: "info_i_15".loc),
        Question(id: 16, level: .I, description: "question_i_16".loc, answerFlags: [.CU, .GT, .PA], info: "info_i_16".loc),
        Question(id: 17, level: .I, description: "question_i_17".loc, answerFlags: [.BO, .PE, .MX], info: "info_i_17".loc)
    ]

    let questionsLevelII: [Question] = [
        Question(id: 21, level: .II, description: "question_ii_21".loc, answerFlags: [.BR, .PE, .BO, .VE], info: "info_ii_21".loc),
        Question(id: 22, level: .II, description: "question_ii_22".loc, answerFlags: [.CO, .MX, .PY, .EC], info: "info_ii_22".loc),
        Question(id: 23, level: .II, description: "question_ii_23".loc, answerFlags: [.BR, .VE, .BO, .PY], info: "info_ii_23".loc),
        Question(id: 24, level: .II, description: "question_ii_24".loc, answerFlags: [.MX, .PE, .BO, .CL], info: "info_ii_24".loc),
        Question(id: 25, level: .II, description: "question_ii_25".loc, answerFlags: [.CU, .JM, .PR, .VE], info: "info_ii_25".loc),
        Question(id: 26, level: .II, description: "question_ii_26".loc, answerFlags: [.HN, .GT, .NI, .SV], info: "info_ii_26".loc),
        Question(id: 27, level: .II, description: "question_ii_27".loc, answerFlags: [.GT, .MX, .BZ, .HN], info: "info_ii_27".loc)
    ]

    let questionsLevelIII: [Question] = [
        Question(id: 31, level: .III, description: "question_iii_31".loc, answerFlags: [.BO, .SV, .PE, .CR, .PA], info: "info_iii_31".loc),
        Question(id: 32, level: .III, description: "question_iii_32".loc, answerFlags: [.DO, .CU, .PR, .JM, .MQ], info: "info_iii_32".loc),
        Question(id: 33, level: .III, description: "question_iii_33".loc, answerFlags: [.MF, .HT, .PR, .SV, .JM], info: "info_iii_33".loc),
        Question(id: 34, level: .III, description: "question_iii_34".loc, answerFlags: [.CR, .SR, .EC, .PA, .NI], info: "info_iii_34".loc),
        Question(id: 35, level: .III, description: "question_iii_35".loc, answerFlags: [.DO, .CU, .PR, .JM, .MQ], info: "info_iii_35".loc),
        Question(id: 36, level: .III, description: "question_iii_36".loc, answerFlags: [.SR, .MQ, .DO, .BZ, .JM], info: "info_iii_36".loc),
        Question(id: 37, level: .III, description: "question_iii_37".loc, answerFlags: [.CL, .VE, .CU, .DO, .PA], info: "info_iii_37".loc)
    ]

    let questionsLevelIV: [Question] = [
        Question(id: 41, level: .IV, description: "question_iv_41".loc, answerFlags: [.CO, .PE, .PA, .MX, .AR, .BR], info: "info_iv_41".loc),
        Question(id: 42, level: .IV, description: "question_iv_42".loc, answerFlags: [.AR, .CL, .CU, .MX, .UY, .CO], info: "info_iv_42".loc),
        Question(id: 43, level: .IV, description: "question_iv_43".loc, answerFlags: [.MX, .AR, .BR, .CL, .CU, .CO], info: "info_iv_43".loc),
        Question(id: 44, level: .IV, description: "question_iv_44".loc, answerFlags: [.CU, .PA, .CR, .DO, .JM, .NI], info: "info_iv_44".loc),
        Question(id: 45, level: .IV, description: "question_iv_45".loc, answerFlags: [.BR, .AR, .MX, .UY, .CL, .PY], info: "info_iv_45".loc),
        Question(id: 46, level: .IV, description: "question_iv_46".loc, answerFlags: [.EC, .CR, .CO, .MX, .PE, .HN], info: "info_iv_46".loc),
        Question(id: 47, level: .IV, description: "question_iv_47".loc, answerFlags: [.AR, .BR, .VE, .PE, .EC, .MX], info: "info_iv_47".loc)
    ]

    let questionsLevelV: [Question] = [
        Question(id: 51, level: .V, description: "question_v_51".loc, answerFlags: [.BR, .MX, .AR, .CL, .PE, .CO], info: "info_v_51".loc),
        Question(id: 52, level: .V, description: "question_v_52".loc, answerFlags: [.VE, .BR, .MX, .AR, .CO, .EC], info: "info_v_52".loc),
        Question(id: 53, level: .V, description: "question_v_53".loc, answerFlags: [.AR, .BR, .CL, .BO, .UY, .PE], info: "info_v_53".loc),
        Question(id: 54, level: .V, description: "question_v_54".loc, answerFlags: [.BR, .AR, .MX, .CO, .CL, .PE], info: "info_v_54".loc),
        Question(id: 55, level: .V, description: "question_v_55".loc, answerFlags: [.MX, .AR, .BR, .CL, .PE, .CO], info: "info_v_55".loc),
        Question(id: 56, level: .V, description: "question_v_56".loc, answerFlags: [.MX, .BR, .PE, .AR, .CL, .CU], info: "info_v_56".loc),
        Question(id: 57, level: .V, description: "question_v_57".loc, answerFlags: [.UY, .CL, .AR, .CR, .BR, .MX], info: "info_v_57".loc),
        Question(id: 58, level: .V, description: "question_v_58".loc, answerFlags: [.AR, .UY, .BR, .PE, .PY, .CL], info: "info_v_58".loc)
    ]
    
    private let questionsLevelVI: [Question] = [
        Question(id: 61, level: .VI, description: "question_vi_61".loc, answerFlags: [.BR, .MX, .CL, .AR, .VE, .PE], info: "info_vi_61".loc),
        Question(id: 62, level: .VI, description: "question_vi_62".loc, answerFlags: [.CL, .BR, .AR, .MX, .PE, .CL], info: "info_vi_62".loc),
        Question(id: 63, level: .VI, description: "question_vi_63".loc, answerFlags: [.BR, .MX, .CO, .AR, .GT, .CU], info: "info_vi_63".loc),
        Question(id: 64, level: .VI, description: "question_vi_64".loc, answerFlags: [.MX, .PE, .BR, .AR, .CL, .CO], info: "info_vi_64".loc),
        Question(id: 65, level: .VI, description: "question_vi_65".loc, answerFlags: [.BR, .VE, .PY, .AR, .CO, .CR], info: "info_vi_65".loc),
        Question(id: 66, level: .VI, description: "question_vi_66".loc, answerFlags: [.VE, .CL, .EC, .PA, .MX, .AR], info: "info_vi_66".loc),
        Question(id: 67, level: .VI, description: "question_vi_67".loc, answerFlags: [.CL, .EC, .MX, .BR, .CR, .GT], info: "info_vi_67".loc)
    ]

    private let questionsLevelVII: [Question] = [
        Question(id: 71, level: .VII, description: "question_vii_71".loc, answerFlags: [.AR, .CL, .BR, .PE, .CO, .UY], info: "info_vii_71".loc),
        Question(id: 72, level: .VII, description: "question_vii_72".loc, answerFlags: [.DO, .CU, .PR, .CR, .PA, .JM], info: "info_vii_72".loc),
        Question(id: 73, level: .VII, description: "question_vii_73".loc, answerFlags: [.HN, .GT, .NI, .CR, .SV, .DO], info: "info_vii_73".loc),
        Question(id: 74, level: .VII, description: "question_vii_74".loc, answerFlags: [.GT, .BO, .CL, .AR, .PA, .HN], info: "info_vii_74".loc),
        Question(id: 75, level: .VII, description: "question_vii_75".loc, answerFlags: [.MX, .AR, .BR, .CL, .CO, .PE], info: "info_vii_75".loc),
        Question(id: 76, level: .VII, description: "question_vii_76".loc, answerFlags: [.AR, .BR, .CL, .MX, .CO, .VE], info: "info_vii_76".loc),
        Question(id: 77, level: .VII, description: "question_vii_77".loc, answerFlags: [.AR, .BR, .CO, .CL, .MX, .PR], info: "info_vii_77".loc)
    ]

    private let questionsLevelVIII: [Question] = [
        Question(id: 81, level: .VIII, description: "question_viii_81".loc, answerFlags: [.AR, .BR, .CL, .VE, .MX, .CO], info: "info_viii_81".loc),
        Question(id: 82, level: .VIII, description: "question_viii_82".loc, answerFlags: [.AR, .MX, .BR, .CL, .UY, .PE], info: "info_viii_82".loc),
        Question(id: 83, level: .VIII, description: "question_viii_83".loc, answerFlags: [.AR, .BR, .MX, .CL, .UY, .CO], info: "info_viii_83".loc),
        Question(id: 84, level: .VIII, description: "question_viii_84".loc, answerFlags: [.DO, .GT, .CR, .PA, .SV, .HN], info: "info_viii_84".loc),
        Question(id: 85, level: .VIII, description: "question_viii_85".loc, answerFlags: [.AR, .CL, .BR, .MX, .UY, .PE], info: "info_viii_85".loc),
        Question(id: 86, level: .VIII, description: "question_viii_86".loc, answerFlags: [.AR, .BR, .CL, .MX, .UY, .CU], info: "info_viii_86".loc),
        Question(id: 87, level: .VIII, description: "question_viii_87".loc, answerFlags: [.MX, .AR, .BR, .CL, .CU, .CO], info: "info_viii_87".loc)
    ]

    // TODO: Blur flags here!!! V2

    private let questionsLevelIX = [
        Question(id: 91, level: .IX, description: "question_ix_91".loc, answerFlags: [.BR, .AR, .CL, .MX, .UY, .CO], info: "info_ix_91".loc),
        Question(id: 92, level: .IX, description: "question_ix_92".loc, answerFlags: [.BR, .AR, .MX, .CL, .PE, .UY], info: "info_ix_92".loc),
        Question(id: 93, level: .IX, description: "question_ix_93".loc, answerFlags: [.AR, .BR, .CL, .MX, .CO, .PE], info: "info_ix_93".loc),
        Question(id: 94, level: .IX, description: "question_ix_94".loc, answerFlags: [.AR, .BR, .CL, .MX, .CO, .PE], info: "info_ix_94".loc),
        Question(id: 95, level: .IX, description: "question_ix_95".loc, answerFlags: [.CO, .BR, .AR, .MX, .CL, .VE], info: "info_ix_95".loc),
        Question(id: 96, level: .IX, description: "question_ix_96".loc, answerFlags: [.AR, .BR, .CL, .MX, .CU, .PE], info: "info_ix_96".loc),
        Question(id: 97, level: .IX, description: "question_ix_97".loc, answerFlags: [.AR, .BR, .MX, .UY, .CL, .PY], info: "info_ix_97".loc),
        Question(id: 98, level: .IX, description: "question_ix_98".loc, answerFlags: [.PA, .AR, .BO, .CL, .PE, .MX], info: "info_ix_98".loc)
    ]

    private let questionsLevelX = [
        Question(id: 101, level: .X, description: "question_x_101".loc, answerFlags: [.MX, .AR, .BR, .CL, .CO, .PE], info: "info_x_101".loc),
        Question(id: 102, level: .X, description: "question_x_102".loc, answerFlags: [.AR, .BR, .CL, .MX, .CO, .PE], info: "info_x_102".loc),
        Question(id: 103, level: .X, description: "question_x_103".loc, answerFlags: [.CU, .NI, .HN, .GT, .PA, .CR], info: "info_x_103".loc),
        Question(id: 104, level: .X, description: "question_x_104".loc, answerFlags: [.AR, .BR, .CL, .MX, .CO, .BO], info: "info_x_104".loc),
        Question(id: 105, level: .X, description: "question_x_105".loc, answerFlags: [.CL, .PY, .BO, .BR, .UY, .MX], info: "info_x_105".loc),
        Question(id: 106, level: .X, description: "question_x_106".loc, answerFlags: [.AR, .BR, .MX, .CL, .CO, .UY], info: "info_x_106".loc),
        Question(id: 107, level: .X, description: "question_x_107".loc, answerFlags: [.GT, .CU, .DO, .HN, .SV, .CR], info: "info_x_107".loc)
    ]
    
    private let questionsLevelXI: [Question] = [
        Question(id: 111, level: .XI, description: "question_xi_111".loc, answerFlags: [.BR, .AR, .MX, .UY, .PY, .CO], info: "info_xi_111".loc),
        Question(id: 112, level: .XI, description: "question_xi_112".loc, answerFlags: [.BR, .PE, .CO, .VE, .BO, .EC], info: "info_xi_112".loc),
        Question(id: 113, level: .XI, description: "question_xi_113".loc, answerFlags: [.CR, .CL, .UY, .AR, .PA, .MX], info: "info_xi_113".loc),
        Question(id: 114, level: .XI, description: "question_xi_114".loc, answerFlags: [.MX, .SV, .CR, .NI, .GT, .HN], info: "info_xi_114".loc),
        Question(id: 115, level: .XI, description: "question_xi_115".loc, answerFlags: [.AR, .CL, .BR, .UY, .PE, .BO], info: "info_xi_115".loc),
        Question(id: 116, level: .XI, description: "question_xi_116".loc, answerFlags: [.BR, .AR, .MX, .PY, .CO, .VE], info: "info_xi_116".loc),
        Question(id: 117, level: .XI, description: "question_xi_117".loc, answerFlags: [.CL, .PE, .BR, .EC, .VE, .BO], info: "info_xi_117".loc)
    ]

    private let questionsLevelXII: [Question] = [
        Question(id: 121, level: .XII, description: "question_xii_121".loc, answerFlags: [.EC, .CR, .GT, .CO, .HN, .DO], info: "info_xii_121".loc),
        Question(id: 122, level: .XII, description: "question_xii_122".loc, answerFlags: [.PY, .UY, .CR, .BR, .CL, .NI], info: "info_xii_122".loc),
        Question(id: 123, level: .XII, description: "question_xii_123".loc, answerFlags: [.BR, .AR, .MX, .UY, .CO, .CL], info: "info_xii_123".loc),
        Question(id: 124, level: .XII, description: "question_xii_124".loc, answerFlags: [.BR, .MX, .CO, .CL, .VE, .PE], info: "info_xii_124".loc),
        Question(id: 125, level: .XII, description: "question_xii_125".loc, answerFlags: [.MX, .BR, .CL, .VE, .AR, .PE], info: "info_xii_125".loc),
        Question(id: 126, level: .XII, description: "question_xii_126".loc, answerFlags: [.BR, .CO, .VE, .AR, .CL, .PE], info: "info_xii_126".loc),
        Question(id: 127, level: .XII, description: "question_xii_127".loc, answerFlags: [.BR, .CO, .VE, .PE, .BO, .EC], info: "info_xii_127".loc),
        Question(id: 128, level: .XII, description: "question_xii_128".loc, answerFlags: [.AR, .BR, .UY, .CO, .PY, .CL], info: "info_xii_128".loc)
    ]

    private let questionsLevelXIII: [Question] = [
        Question(id: 131, level: .XIII, description: "question_xiii_131".loc, answerFlags: [.BR, .PA, .MX, .CL, .CO, .AR], info: "info_xiii_131".loc),
        Question(id: 132, level: .XIII, description: "question_xiii_132".loc, answerFlags: [.EC, .MX, .VE, .BR, .CO, .HN], info: "info_xiii_132".loc),
        Question(id: 133, level: .XIII, description: "question_xiii_133".loc, answerFlags: [.CU, .UY, .CL, .AR, .CR, .PA], info: "info_xiii_133".loc),
        Question(id: 134, level: .XIII, description: "question_xiii_134".loc, answerFlags: [.EC, .BR, .PE, .CO, .VE, .DO], info: "info_xiii_134".loc),
        Question(id: 135, level: .XIII, description: "question_xiii_135".loc, answerFlags: [.MX, .PE, .CL, .BO, .AR, .GT], info: "info_xiii_135".loc),
        Question(id: 136, level: .XIII, description: "question_xiii_136".loc, answerFlags: [.CR, .HN, .GT, .SV, .NI, .PY], info: "info_xiii_136".loc),
        Question(id: 137, level: .XIII, description: "question_xiii_137".loc, answerFlags: [.BR, .MX, .AR, .PY, .PE, .VE], info: "info_xiii_137".loc),
        Question(id: 138, level: .XIII, description: "question_xiii_138".loc, answerFlags: [.AR, .BR, .EC, .CO, .CL, .MX], info: "info_xiii_138".loc)
    ]
}
