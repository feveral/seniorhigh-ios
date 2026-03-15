import UIKit

enum Theme {
    static let accent = UIColor(red: 0.99, green: 0.58, blue: 0.24, alpha: 1.0)
    static let backgroundTop = UIColor(red: 15/255, green: 19/255, blue: 36/255, alpha: 1.0)
    static let backgroundBottom = UIColor(red: 5/255, green: 7/255, blue: 13/255, alpha: 1.0)
    static let cardBackground = UIColor(red: 27/255, green: 32/255, blue: 51/255, alpha: 0.96)
    static let mutedText = UIColor(white: 0.78, alpha: 1.0)
    static let shadowColor = UIColor.black.withAlphaComponent(0.35).cgColor

    static func installAppearance() {
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithTransparentBackground()
        navAppearance.backgroundColor = backgroundTop.withAlphaComponent(0.85)
        navAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        navAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 32, weight: .bold)
        ]

        let navigationBar = UINavigationBar.appearance()
        navigationBar.tintColor = accent
        navigationBar.standardAppearance = navAppearance
        navigationBar.scrollEdgeAppearance = navAppearance
        navigationBar.compactAppearance = navAppearance

        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithTransparentBackground()
        tabAppearance.backgroundEffect = nil
        tabAppearance.backgroundColor = cardBackground.withAlphaComponent(0.85)
        tabAppearance.inlineLayoutAppearance.normal.iconColor = mutedText
        tabAppearance.inlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: mutedText]
        tabAppearance.inlineLayoutAppearance.selected.iconColor = accent
        tabAppearance.inlineLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: accent]
        tabAppearance.stackedLayoutAppearance = tabAppearance.inlineLayoutAppearance
        tabAppearance.compactInlineLayoutAppearance = tabAppearance.inlineLayoutAppearance

        let tabBar = UITabBar.appearance()
        tabBar.standardAppearance = tabAppearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tabAppearance
        }
        tabBar.tintColor = accent
        tabBar.unselectedItemTintColor = mutedText
    }

    @discardableResult
    static func addGradientBackground(to view: UIView) -> GradientBackgroundView {
        let gradientView = GradientBackgroundView()
        view.insertSubview(gradientView, at: 0)
        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradientView.topAnchor.constraint(equalTo: view.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        return gradientView
    }

    static func styleTableView(_ tableView: UITableView) {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 32, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 96
        tableView.tableFooterView = UIView(frame: .zero)
    }

    static func styleSegmentedControl(_ control: UISegmentedControl) {
        control.selectedSegmentTintColor = accent.withAlphaComponent(0.2)
        control.setTitleTextAttributes([
            .foregroundColor: mutedText,
            .font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ], for: .normal)
        control.setTitleTextAttributes([
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 15, weight: .semibold)
        ], for: .selected)
        control.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        control.layer.cornerRadius = 12
        control.layer.masksToBounds = true
    }

    static func styleFilterChip(_ button: UIButton, isSelected: Bool) {
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 14, bottom: 6, right: 14)
        button.backgroundColor = isSelected ? accent.withAlphaComponent(0.2) : UIColor.white.withAlphaComponent(0.03)
        button.setTitleColor(isSelected ? UIColor.white : mutedText, for: .normal)
        button.layer.borderColor = (isSelected ? accent.cgColor : UIColor.white.withAlphaComponent(0.08).cgColor)
        button.layer.borderWidth = isSelected ? 1 : 0
    }

    static func styleEmptyStateLabel(_ label: UILabel) {
        label.textColor = mutedText
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
    }

    static func applyCardShadow(to layer: CALayer, cornerRadius: CGFloat, shadowRect: CGRect) {
        layer.shadowColor = shadowColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowRadius = 20
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: shadowRect, cornerRadius: cornerRadius).cgPath
    }
}

final class GradientBackgroundView: UIView {
    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        gradientLayer.colors = [Theme.backgroundTop.cgColor, Theme.backgroundBottom.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
