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
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self

        setupObserver()
    }

    func setupObserver() {
        API.shared.getJobs(for: "go")
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                self?.jobs.accept(data)
            })
            .disposed(by: bag)
        
        jobs.asObservable().subscribe(onNext: { [weak self] _ in
            self?.tableView.reloadData()
        })
        .disposed(by: bag)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier:
          "cell", for: indexPath)

        let job = jobs.value[indexPath.row]
        
        cell.textLabel?.text = job.title
        cell.detailTextLabel?.text = job.company

        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
