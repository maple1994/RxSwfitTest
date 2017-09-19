//
//  TableViewWithEditingCommandViewController.swift
//  MyRx
//
//  Created by Maple on 2017/9/19.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

struct TableViewWithEditingCommandsViewModel {
    let favoriteUsers: [User]
    let users: [User]
    
    static func excuteCommand(_ state: TableViewWithEditingCommandsViewModel, _ command: TableViewEditingCommand) -> TableViewWithEditingCommandsViewModel {
        switch command {
        case let .setUsers(users):
            return TableViewWithEditingCommandsViewModel(favoriteUsers: state.favoriteUsers, users: users)
        case let .setFavoriteUser(favoriteUsers):
            return TableViewWithEditingCommandsViewModel(favoriteUsers: favoriteUsers, users: state.users)
        case let .deleteUser(indexPath):
            var all = [state.favoriteUsers, state.users]
            all[indexPath.section].remove(at: indexPath.row)
            return TableViewWithEditingCommandsViewModel(favoriteUsers: all[0], users: all[1])
        case let .moveUser(from, to):
            var all = [state.favoriteUsers, state.users]
            let user = all[from.section][from.row]
            all[from.section].remove(at: from.row)
            all[to.section].insert(user, at: to.row)
            return TableViewWithEditingCommandsViewModel(favoriteUsers: all[0], users: all[1])
        }
    }
}


enum TableViewEditingCommand {
    case setUsers(users: [User])
    case setFavoriteUser(favoriteUsers: [User])
    case deleteUser(indexPath: IndexPath)
    case moveUser(from: IndexPath, to: IndexPath)
}


class TableViewWithEditingCommandViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    let dataSource = TableViewWithEditingCommandViewController.configureDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = editButtonItem
        
        let superMan =  User(
            firstName: "Super",
            lastName: "Man",
            imageURL: "http://nerdreactor.com/wp-content/uploads/2015/02/Superman1.jpg"
        )
        
        let watMan = User(firstName: "Wat",
                          lastName: "Man",
                          imageURL: "http://www.iri.upc.edu/files/project/98/main.GIF"
        )
        
        
        let loadFavoriteUsers = RandomUserAPI.shared
        .getExampleUserResultSet()
        .map(TableViewEditingCommand.setUsers)
        .catchErrorJustReturn(TableViewEditingCommand.setUsers(users: []))
        
        let initialLoadCommand = Observable.just(TableViewEditingCommand.setFavoriteUser(favoriteUsers: [superMan, watMan]))
        .concat(loadFavoriteUsers)
        .observeOn(MainScheduler.instance)

        let deleteUserCommand = tableView.rx.itemDeleted.map(TableViewEditingCommand.deleteUser)
        let moveUserCommand = tableView.rx.itemMoved.map(TableViewEditingCommand.moveUser)

        let initialState = TableViewWithEditingCommandsViewModel(favoriteUsers: [], users: [])
        
        let viewModel =  Observable.system(
            initialState,
            accumulator: TableViewWithEditingCommandsViewModel.excuteCommand,
            scheduler: MainScheduler.instance,
            feedback: { _ in initialLoadCommand }, { _ in deleteUserCommand }, { _ in moveUserCommand })
            .shareReplay(1)
        
        viewModel
            .map {
                [
                SectionModel(model: "Favorite Users", items: $0.favoriteUsers),
                SectionModel(model: "Normal Users", items: $0.users)
                ]
        }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withLatestFrom(viewModel) { i, viewModel in
                let all = [viewModel.favoriteUsers, viewModel.users]
                return all[i.section][i.row]
            }
            .subscribe(onNext: { [weak self] user in
                self?.showDetailsForUser(user)
            })
            .disposed(by: disposeBag)
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func showDetailsForUser(_ user: User) {
        let vc = DetailsViewController()
        vc.user = user
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func configureDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<String, User>> {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, User>>()
        
        dataSource.configureCell = { (_, tv, ip, user: User) in
            var cell = tv.dequeueReusableCell(withIdentifier: "Cell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            }
            cell?.textLabel?.text = user.firstName + " " + user.lastName
            return cell!
        }
        
        dataSource.titleForHeaderInSection = { dataSource, sectionIndex in
            return dataSource[sectionIndex].model
        }
        
        dataSource.canEditRowAtIndexPath = { (ds, ip) in
            return true
        }
        
        dataSource.canMoveRowAtIndexPath = { (_, _) in
            return true
        }
        
        return dataSource
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = dataSource[section]
        
        let label = UILabel(frame: CGRect.zero)
        // hacky I know :)
        label.text = "  \(title)"
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.darkGray
        label.alpha = 0.9
        
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}









