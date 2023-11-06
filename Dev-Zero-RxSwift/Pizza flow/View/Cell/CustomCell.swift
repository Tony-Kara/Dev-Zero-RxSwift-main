//
//  CustomCell.swift
//  Dev-Zero-RxSwift
//
//  Created by Eniola Anthony on 11/6/23.
//
import UIKit

class CustomCell: UICollectionViewCell {
    static let reuseIdentifier = "CustomCell"

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .blue
        imageView.image = UIImage(systemName: "star.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Private Function
    
    private func setUpSubviews() {
        contentView.addSubview(imageView)
        setupInitialLayout()
    }

    private func setupInitialLayout() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
