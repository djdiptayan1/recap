//
//  DataFetchmanager.swift
//  recap
//
//  Created by Diptayan Jash on 14/12/24.
//

import FirebaseFirestore
import Foundation

protocol DataFetchProtocol {
    func fetchRapidQuestions(completion: @escaping ([rapiMemory]?, Error?) -> Void)
    func fetchUserProfile(userId: String, completion: @escaping ([String: Any]?, Error?) -> Void)
    func fetchFamilyMembers(userId: String, completion: @escaping ([FamilyMember]?, Error?) -> Void)
    func fetchLastMemoryCheck(userId: String, completion: @escaping (String) -> Void)
    func fetchArticles(completion: @escaping ([Article]?, Error?) -> Void)
}

class DataFetch: DataFetchProtocol {
    private let firestore = Firestore.firestore()

    // Fetch rapid questions
    func fetchRapidQuestions(completion: @escaping ([rapiMemory]?, Error?) -> Void) {
        FirebaseManager.shared.fetchData(DBName: "rapidMemoryQuestions") {
            (data: [rapiMemory]?, error) in
            completion(data, error)
        }
    }

    // Fetch user profile
    func fetchUserProfile(userId: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        firestore.collection("users").document(userId).getDocument { document, error in
            if let error = error {
                print("Error fetching user profile: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            guard let data = document?.data() else {
                completion(
                    nil,
                    NSError(
                        domain: "FirebaseError", code: 404,
                        userInfo: [NSLocalizedDescriptionKey: "User not found"]))
                return
            }
            completion(data, nil)
        }
    }

    // Fetch family members
    func fetchFamilyMembers(userId: String, completion: @escaping ([FamilyMember]?, Error?) -> Void)
    {
        firestore.collection(Constants.FirestoreKeys.usersCollection)
            .document(userId)
            .collection(Constants.FirestoreKeys.familyMembersCollection)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching family members: \(error.localizedDescription)")
                    completion(nil, error)
                    return
                }
                let familyMembers = snapshot?.documents.compactMap { doc -> FamilyMember? in
                    let data = doc.data()
                    return FamilyMember(
                        id: doc.documentID,
                        name: data["name"] as? String ?? "",
                        relationship: data["relationship"] as? String ?? "",
                        phone: data["phone"] as? String ?? "",
                        email: data["email"] as? String ?? "",
                        password: data["password"] as? String ?? "",
                        imageName: data["imageName"] as? String ?? "",
                        imageURL: data["imageURL"] as? String ?? ""
                    )
                }
                completion(familyMembers, nil)
            }
    }

    func fetchLastMemoryCheck(userId: String, completion: @escaping (String) -> Void) {
        FirebaseManager.shared.firestore
            .collection("users").document(userId)
            .collection("memoryCheckReports")
            .order(by: "date", descending: true)
            .limit(to: 1)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching last memory check: \(error)")
                    completion("Never")
                    return
                }

                if let document = snapshot?.documents.first {
                    let data = document.data()
                    let timestamp = data["date"] as? Timestamp
                    let formattedDate =
                        timestamp?.dateValue().formatted(.dateTime.month().day().year()) ?? "Never"
                    completion(formattedDate)
                } else {
                    completion("Never")
                }
            }
    }
    func fetchArticles(completion: @escaping ([Article]?, Error?) -> Void) {
        firestore.collection("Articles").getDocuments { (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            var articles = [Article]()
            let group = DispatchGroup()

            for document in snapshot!.documents {
                let data = document.data()
                if let title = data["title"] as? String,
                    let author = data["author"] as? String,
                    let content = data["content"] as? String,
                    let imageUrl = data["image"] as? String,
                    let link = data["link"] as? String,
                    let source = data["source"] as? String,
                    let citation = data["citation"] as? String
                {
                    group.enter()
                    self.fetchImage(from: imageUrl) { image in
                        let article = Article(
                            title: title,
                            author: author,
                            content: content,
                            image: image ?? UIImage(),
                            link: link,
                            source: source,
                            citation: citation
                        )
                        articles.append(article)
                        group.leave()
                    }
                }
            }

            group.notify(queue: .main) {
                completion(articles, nil)
            }
        }
    }

    private func fetchImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }
        task.resume()
    }
}
