import UIKit
import RxSwift
import RxCocoa

class JobListController: UIViewController {

    lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(JobCell.self, forCellReuseIdentifier: "JobCell")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 100
        return view
    }()
    
    private let bag: DisposeBag = DisposeBag()

    private let viewModel: JobListViewModel
        
    init(viewModel: JobListViewModel = JobListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupUI()
        viewModel.fetchJobs(for: "go")
    }
    
    func setupUI() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupBinding() {
        viewModel.jobs
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items) { tableView, index, element in
                let cell: JobCell = tableView.dequeueReusableCell(withIdentifier: "JobCell") as! JobCell
                let viewModel = JobCellViewModel(job: element)
                cell.setup(viewModel)
                return cell
            }
            .disposed(by: bag)
    }
}

