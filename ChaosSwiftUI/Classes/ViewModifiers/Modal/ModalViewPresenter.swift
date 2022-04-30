//
//  ModalViewController.swift
//  SwiftUIExamples
//
//  Created by Fu Lam Diep on 02.03.22.
//

import SwiftUI

public struct ModalViewPresenter<Content: View>: UIViewControllerRepresentable {

    // MARK: Nested Types

    public class Coordinator: NSObject {

        public let presenter: ModalViewPresenter<Content>

        public init(presenter: ModalViewPresenter) {
            self.presenter = presenter
        }

        @objc func didTapBackground(sender: UIView) {
            if presenter.dismissesByBackground {
                presenter.isPresented = false
            }
        }
    }

    // MARK: Properties

    @Binding var isPresented: Bool

    private let dismissesByBackground: Bool

    private let hostingController: UIHostingController<Content>


    // MARK: Intialization

    public init(isPresented: Binding<Bool>,
                dismissesByBackground: Bool,
                color: Color,
                content: () -> Content) {
        self._isPresented = isPresented
        self.dismissesByBackground = dismissesByBackground

        hostingController = UIHostingController(rootView: content())
        hostingController.view.backgroundColor = UIColor(color)
        hostingController.modalTransitionStyle = .crossDissolve
        hostingController.modalPresentationStyle = .overFullScreen
    }


    // MARK: UIViewControllerRepresentable Implmenetation
    
    public func makeUIViewController(context: Context) -> UIViewController {
        let tapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator,
                                                          action: #selector(context.coordinator.didTapBackground(sender:)))
        hostingController.view.addGestureRecognizer(tapGestureRecognizer)

        let viewController = UIViewController()
        viewController.view.backgroundColor = .clear
        return viewController
    }

    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented {
            uiViewController.present(hostingController, animated: true)
        } else if uiViewController.presentedViewController != nil {
            uiViewController.dismiss(animated: true)
        }
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(presenter: self)
    }
}
