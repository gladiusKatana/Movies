


struct Movie: Decodable {
    let posterPath: String
    //let adult: Bool
    let overview: String
    let releaseDate: String
    let id: Int
    //let originalTitle: String
    //let originalLanguage: String
    let title: String
    let backdropPath: String
    //let popularity: Double
    //let voteCount: Int
    let voteAverage: Double
}

struct Genre: Decodable {
    let id: Int
    let name: String
}

struct Review: Decodable {
    //let rating: Double        /// do not implement unless in mock data or if changed url construction
    let author: String
    //let authorDetails: ...    /// (are these authors ever noteworthy people? e.g. the late Roger Ebert?)
    let content: String
    let createdAt: String
    let id: String
    let updatedAt: String
    let url: String
}
