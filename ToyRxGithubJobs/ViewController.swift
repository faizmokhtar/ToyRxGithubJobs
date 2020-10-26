//
//  ViewController.swift
//  ToyRxGithubJobs
//
//  Created by AD0502 on 24/10/2020.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    let bag = DisposeBag()
    let jobs = BehaviorRelay<[Job]>(value: [])
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupObserver()
        setupUIBinding()
    }

    func setupObserver() {
        API.shared.getJobs(for: "go")
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .subscribe(onNext: { [weak self] data in
                self?.jobs.accept(data)
            })
            .disposed(by: bag)
    }
    
    func setupUIBinding() {
        jobs.bind(to: tableView.rx.items) { tableView, index, element in
            let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.text = element.title
            cell.detailTextLabel?.text = element.company
            return cell
        }
        .disposed(by: bag)
        
        tableView.rx.modelSelected(Job.self)
            .subscribe(onNext: { job in
                print("job \(job.title) is selected")
            })
            .disposed(by: bag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] itemSelected in
                self?.tableView.deselectRow(at: itemSelected, animated: true)
            })
            .disposed(by: bag)
    }
}
