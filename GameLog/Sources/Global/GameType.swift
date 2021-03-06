//
//  GameType.swift
//  GameLog
//
//  Created by duckbok on 2021/10/19.
//

enum GameType: String {

    case popular, recommand

    // MARK: - Genres

    case pointAndClick = "Point-and-click"
    case fighting = "Fighting"
    case shooter = "Shooter"
    case music = "Music"
    case platform = "Platform"
    case puzzle = "Puzzle"
    case racing = "Racing"
    case rts = "Real Time Strategy (RTS)"
    case rpg = "Role-playing (RPG)"
    case simulator = "Simulator"
    case sport = "Sport"
    case strategy = "Strategy"
    case tbs = "Turn-based strategy (TBS)"
    case tactical = "Tactical"
    case hackAndSlash = "Hack and slash/Beat 'em up"
    case quizTrivia = "Quiz/Trivia"
    case pinball = "Pinball"
    case adventure = "Adventure"
    case indie = "Indie"
    case arcade = "Arcade"
    case visualNovel = "Visual Novel"
    case cardAndBoardGame = "Card & Board Game"
    case moba = "MOBA"

    // MARK: - Themes

    case action = "Action"
    case fantasy = "Fantasy"
    case scienceFiction = "Science fiction"
    case horror = "Horror"
    case thriller = "Thriller"
    case survival = "Survival"
    case historical = "Historical"
    case stealth = "Stealth"
    case comedy = "Comedy"
    case business = "Business"
    case drama = "Drama"
    case nonFiction = "Non-fiction"
    case sandbox = "Sandbox"
    case educational = "Educational"
    case kids = "Kids"
    case openWorld = "Open world"
    case warfare = "Warfare"
    case party = "Party"
    case fourX = "4X (explore, expand, exploit, and exterminate)"
    case erotic = "Erotic"
    case mystery = "Mystery"
    case romance = "Romance"

    // MARK: - Computed Property

    var category: String? {
        switch self {
        case .pointAndClick, .fighting, .shooter, .music, .platform, .puzzle, .racing, .rts, .rpg, .simulator,
                .sport, .strategy, .tbs, .tactical, .hackAndSlash, .quizTrivia, .pinball, .adventure, .indie, .arcade,
                .visualNovel, .cardAndBoardGame, .moba:
            return "genres"
        case .action, .fantasy, .scienceFiction, .horror, .thriller, .survival, .historical, .stealth, .comedy,
                .business, .drama, .nonFiction, .sandbox, .educational, .kids, .openWorld, .warfare, .party, .fourX,
                .erotic, .mystery, .romance:
            return "themes"
        case .popular, .recommand:
            return nil
        }
    }

    var id: Int? {
        switch self {
        case .pointAndClick: return 2
        case .fighting: return 4
        case .shooter: return 5
        case .music: return 7
        case .platform: return 8
        case .puzzle: return 9
        case .racing: return 10
        case .rts: return 11
        case .rpg: return 12
        case .simulator: return 13
        case .sport: return 14
        case .strategy: return 15
        case .tbs: return 16
        case .tactical: return 24
        case .hackAndSlash: return 25
        case .quizTrivia: return 26
        case .pinball: return 30
        case .adventure: return 31
        case .indie: return 32
        case .arcade: return 33
        case .visualNovel: return 34
        case .cardAndBoardGame: return 35
        case .moba: return 36

        case .action: return 1
        case .fantasy: return 17
        case .scienceFiction: return 18
        case .horror: return 19
        case .thriller: return 20
        case .survival: return 21
        case .historical: return 22
        case .stealth: return 23
        case .comedy: return 27
        case .business: return 28
        case .drama: return 31
        case .nonFiction: return 32
        case .sandbox: return 33
        case .educational: return 34
        case .kids: return 35
        case .openWorld: return 38
        case .warfare: return 39
        case .party: return 40
        case .fourX: return 41
        case .erotic: return 42
        case .mystery: return 43
        case .romance: return 44

        default: return nil
        }
    }

    var name: String {
        switch self {
        case .popular: return "?????? ??????"
        case .recommand: return "?????? ??????"

        case .action: return "??????"
        case .adventure: return "????????????"
        case .arcade: return "????????????"
        case .business: return "??????"
        case .cardAndBoardGame: return "??????/????????????"
        case .comedy: return "?????????"
        case .drama: return "?????????"
        case .educational: return "??????"
        case .erotic: return "19+"
        case .fantasy: return "?????????"
        case .fighting: return "??????"
        case .fourX: return "4X"
        case .hackAndSlash: return "??? ??? ?????????"
        case .historical: return "??????"
        case .horror: return "??????"
        case .indie: return "??????"
        case .kids: return "?????? ?????????"
        case .moba: return "MOBA"
        case .music: return "??????"
        case .mystery: return "????????????"
        case .nonFiction: return "?????????"
        case .openWorld: return "?????? ??????"
        case .party: return "?????? ??????"
        case .pinball: return "??????"
        case .platform: return "????????? ??????"
        case .pointAndClick: return "?????????&??????"
        case .puzzle: return "??????"
        case .quizTrivia: return "?????? ??????"
        case .racing: return "?????????"
        case .romance: return "?????????"
        case .rpg: return "????????????"
        case .rts: return "????????? ??????"
        case .sandbox: return "????????????"
        case .scienceFiction: return "????????????"
        case .shooter: return "??????"
        case .simulator: return "???????????????"
        case .sport: return "?????????"
        case .stealth: return "??????"
        case .strategy: return "??????"
        case .survival: return "??????"
        case .tactical: return "??????"
        case .tbs: return "????????????"
        case .thriller: return "?????????"
        case .visualNovel: return "????????? ??????"
        case .warfare: return "??????"
        }
    }
}
