//
//  SuccessViewModel.swift
//  userListMVVM
//
//  Created by Hasan Oztunc on 12.02.2021.
//
import RxSwift
import RxCocoa
import RxGesture

protocol SuccessViewPresentable {
    typealias Input = (
        dismiss: ControlEvent<UITapGestureRecognizer>, ()
    )
    typealias Output = ()
    
    typealias ViewModelBuilder = (SuccessViewPresentable.Input) -> SuccessViewPresentable
    
    var input: Input { get }
    var output: Output { get }
}

final class SuccessViewModel: SuccessViewPresentable {
    
    var input: Input
    var output: Output
    
    private let bag = DisposeBag()
    
    typealias RoutingAction = (dismissRelay: PublishRelay<()>, ())
    private let routingAction: RoutingAction = (dismissRelay: PublishRelay(), ())
    
    typealias Routing = (dismiss: Driver<()>, ())
    lazy var routing: Routing = (dismiss: routingAction.dismissRelay.asDriver(onErrorDriveWith: .empty()), ())
    
    init(input: SuccessViewPresentable.Input) {
        self.input = input
        self.output = SuccessViewModel.output()
        process(input: self.input)
    }
}

extension SuccessViewModel {
    
    func process(input: SuccessViewPresentable.Input) {
        input.dismiss
            .map({ [routingAction]  _ in
                routingAction.dismissRelay.accept(())
            })
            .subscribe()
            .disposed(by: bag)
    }
    
    static func output() -> SuccessViewPresentable.Output {
        return ()
    }
}
