import UIKit
import CoreData

private let imageCellIdentifier = "imageCell"

class ViewController: UIViewController {
    
    //MARK: - Properties
    
    let dataManager = DataManager.shared
    var fetchingMore = false
    var imageModels: NSFetchedResultsController<ImageModel>!
    
    //MARK: - IBOutlets

    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Life circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupDelegate()
        imageModels = dataManager.fetchResultController
        
        dataManager.addImageModels(count: 4)
        
    }
}

//MARK: - CollectionView stack

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let sectionInfo = imageModels.sections?[section]
        
        print(sectionInfo?.numberOfObjects ?? 0)
        return sectionInfo?.numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let imageModel = imageModels.object(at: indexPath)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellIdentifier, for: indexPath) as! ImageCell
        cell.setup(for: imageModel.image!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let windowWidth = view.frame.width
        return CGSize(width: windowWidth - 5, height: windowWidth - 5)
    }
}

//MARK: - Infinity Scrolling Stack

extension ViewController {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height {
            if !fetchingMore {
                beginBatchFetched()
            }
        }
    }

    func beginBatchFetched() {

        print("Fetching new data")
        fetchingMore = true
        dataManager.addImageModels(count: 4)
        fetchingMore = false
        collectionView.reloadData()
    }
}

//MARK: - CollectionViewHandlerDelegate

extension ViewController: CollectionViewHandlerDelegate {
    
    func setupDelegate() {
        dataManager.collectoinViewHandlerDelegate = self
    }
    
    func insertItems(indexPathArray: [IndexPath]) {
        collectionView.insertItems(at: indexPathArray)
        collectionView.reloadData()
    }
}
