// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum About {
    /// MVCSwift App developed by David Seca
    internal static let content = L10n.tr("Localizable", "About.content")
  }

  internal enum Date {
    /// MM/dd/yyyy
    internal static let format = L10n.tr("Localizable", "Date.format")
  }

  internal enum Tabbar {
    /// Info
    internal static let about = L10n.tr("Localizable", "Tabbar.about")
    /// Transactions
    internal static let transactions = L10n.tr("Localizable", "Tabbar.transactions")
  }

  internal enum Transaction {
    internal enum Reference {
      /// Reference
      internal static let title = L10n.tr("Localizable", "Transaction.Reference.title")
    }
  }

  internal enum Transactions {
    internal enum Empty {
      /// No transactions
      internal static let title = L10n.tr("Localizable", "Transactions.empty.title")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
