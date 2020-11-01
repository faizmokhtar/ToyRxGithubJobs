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
    
    lazy var searchBar: UISearchBar = {
        let view = UISearchBar(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = "Search jobs stacks"
        return view
    }()
    
    private let bag: DisposeBag = DisposeBag()
    private let searchText: BehaviorRelay<String?>
    private let defaultSearch: String
    
    private let viewModel: JobListViewModel
        
    init(
        viewModel: JobListViewModel = JobListViewModel(),
        searchText: BehaviorRelay<String?> = BehaviorRelay(value: nil),
        defaultSearch: String = "go"
    ) {
        self.viewModel = viewModel
        self.searchText = searchText
        self.defaultSearch = defaultSearch
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupUI()
        viewModel.fetchJobs(for: defaultSearch)
    }
    
    func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: view.topAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupBinding() {
        searchBar.rx.text.orEmpty.asDriver()
            .debounce(.seconds(1))
            .drive(searchText)
            .disposed(by: bag)
        
        searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                self?.searchBar.resignFirstResponder()
            })
            .disposed(by: bag)
                
        searchText
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] value in
                guard let self = self,
                      let value = value else { return }
                self.title = "Available \(value.capitalized) Jobs"
                self.viewModel.fetchJobs(for: value)
            })
            .disposed(by: bag)
        
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

