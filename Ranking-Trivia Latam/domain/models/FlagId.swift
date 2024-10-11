//
//  FlagId.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import Foundation

enum FlagId: String, Codable, Hashable {
    case AR // Argentina
    case BZ // Belize
    case BO // Bolivia
    case BR // Brazil
    case CL // Chile
    case CO // Colombia
    case CR // Costa Rica
    case CU // Cuba
    case EC // Ecuador
    case JM // Jamaica
    case SV // El Salvador
    case GP // Guadeloupe
    case GT // Guatemala
    case GF // French Guiana
    case GY // Guyana
    case HT // Haiti
    case HN // Honduras
    case MF // Saint Martin
    case MQ // Martinique
    case MX // Mexico
    case NI // Nicaragua
    case PA // Panama
    case PY // Paraguay
    case PE // Peru
    case PR // Puerto Rico
    case DO // Dominican Republic
    case SR // Suriname
    case UY // Uruguay
    case VE // Venezuela
}

func getFlagId(flagCode: String) -> FlagId? {
    return FlagId(rawValue: flagCode)
}
