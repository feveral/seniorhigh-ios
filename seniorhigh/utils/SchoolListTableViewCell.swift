import UIKit

final class SchoolListTableViewCell: UITableViewCell {
    private let inset = UIEdgeInsets(top: 6, left: 18, bottom: 6, right: 18)
    private let cornerRadius: CGFloat = 18
    private let minimumContentHeight: CGFloat = 72
    private let cardView = UIView()
    private let titleLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        selectionStyle = .none
        clipsToBounds = false
        contentView.clipsToBounds = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byTruncatingTail
        detailTextLabel?.textColor = Theme.mutedText
        detailTextLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        setupCardView()
    }

    private func setupCardView() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = Theme.cardBackground
        cardView.layer.cornerRadius = cornerRadius
        cardView.layer.masksToBounds = true
        contentView.insertSubview(cardView, at: 0)
        cardView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset.left),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset.right),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset.top),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset.bottom),
            cardView.heightAnchor.constraint(greaterThanOrEqualToConstant: minimumContentHeight),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 18),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -18),
            titleLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        Theme.applyCardShadow(to: layer, cornerRadius: cornerRadius, shadowRect: cardView.frame.insetBy(dx: -2, dy: -2))
    }

    func configure(title: String) {
        titleLabel.text = title
    }
}
