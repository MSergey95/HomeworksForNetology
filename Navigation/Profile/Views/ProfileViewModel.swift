//
//  ProfileViewModel.swift
//  Navigation
//
//  Created by Сергей Минеев on 8/16/24.
//

import Foundation

class ProfileViewModel {

    private var userProfile: UserProfile
    private var posts: [Post]

    init(userProfile: UserProfile) {
        self.userProfile = userProfile
        self.posts = [
            Post(author: "Ciri", description: "Cirilla Fiona Elen Riannon, also known as Ciri, is the adopted daughter of Geralt. She possesses Elder Blood, which gives her unique abilities.", image: "post1", likes: 220, views: 340),
            Post(author: "Yennefer of Vengerberg", description: "A powerful sorceress, Yennefer is known for her beauty, intelligence, and complex relationship with Geralt.", image: "post2", likes: 180, views: 290),
            Post(author: "Geralt of Rivia", description: "The White Wolf, a renowned Witcher known for his skill with the sword and his ability to slay monsters.", image: "post3", likes: 150, views: 200),
            Post(author: "Pixar", description: "Cat of Konensberg", image: "post4", likes: 130, views: 170)
        ]
    }

    func getUserName() -> String {
        return userProfile.name
    }

    func getPostsCount() -> Int {
        return posts.count
    }

    func getPost(at index: Int) -> Post {
        return posts[index]
    }

    func incrementViewsCounterForPost(at index: Int) {
        posts[index].views += 1
    }
}
