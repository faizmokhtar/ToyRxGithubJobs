import Foundation
import RxSwift
import RxCocoa

class JobListViewModel {
    
    let jobs: BehaviorRelay<[Job]>
        
    private let bag = DisposeBag()

    init(jobs: BehaviorRelay<[Job]> = BehaviorRelay(value: [])) {
        self.jobs = jobs
    }

    func fetchJobs(for jobType: String) {
        API.shared.getJobs(for: jobType)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.jobs.accept($0)
            })
            .disposed(by: bag)
    }
}
