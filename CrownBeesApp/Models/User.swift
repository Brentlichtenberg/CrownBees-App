import Foundation

// NOTE: For this proof-of-concept, credentials are stored in plain text in UserDefaults.
// In production, use Keychain for secure credential storage and a proper auth backend.
struct User: Codable {
    var email: String
    var password: String
    var zipCode: String
}
