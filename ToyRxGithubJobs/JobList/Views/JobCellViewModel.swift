import Foundation

class JobCellViewModel {
    
    let title: String
    let company: String
    
    init(job: Job) {
        self.title = job.title
        self.company = job.company
    }
}
