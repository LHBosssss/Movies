//
//  CategoryManager.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/14/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//
import Foundation

class CategoryManager {
    
    let mainMenu: [Dictionary<String, String>] = [
        [
            "title" : "Phim Hot" ,
            "genre" : "hot",
        ],
        [
            "title" : "Xem Nhiều" ,
            "genre" : "trending",
        ],
        [
            "title" : "Phim Mới",
            "genre" : "phim",
        ],
        [
            "title" : "Movie Feed" ,
            "genre" : "hot",
        ],
        [
            "title" : "Thuyết Minh",
            "genre" : "thuyet-minh-tieng-viet",
        ],
        [
            "title" : "Phim Lẻ",
            "genre" : "phim-le",
            "sub" : "phim-le",
        ],
        [
            "title" : "Phim Bộ",
            "genre" : "series",
            "sub" : "series",
        ],
    ]
    
    let phimleMenu: [Dictionary<String, String>] = [
            [
                "title" : "Hành Động",
                "genre" : "action",
            ],
            [
                "title" : "Viễn Tưởng",
                "genre" : "sci-fi",
            ],
            [
                "title" : "Kinh Dị" ,
                "genre" : "horror",
            ],
            [
                "title" : "Võ Thuật" ,
                "genre" : "vo-thuat-phim-2",
            ],
            [
                "title" : "Hài",
                "genre" : "comedy",
            ],
            [
                "title" : "Chiến Tranh",
                "genre" : "war",
            ],
            [
                "title" : "Cổ Trang",
                "genre" : "co-trang-phim",
            ],
            [
                "title" : "Hình Sự",
                "genre" : "crime"
            ],
            [
                "title" : "Tình Cảm",
                "genre" : "tinh-cam",
            ],
            [
                "title" : "Hoạt Hình",
                "genre" : "animation",
            ],
            [
                "title" : "Hồng Kông" ,
                "genre" : "hongkong",
            ],
            [
                "title" : "Tài Liệu",
                "genre" : "documentary",
            ],
            [
                "title" : "Trung Quốc",
                "genre" : "trung-quoc-series",
            ],
            [
                "title" : "Hàn Quốc",
                "genre" : "korean",
            ],
            [
                "title" : "Ấn Độ",
                "genre" : "india",
            ]
        ]
    
    let phimboMenu: [Dictionary<String, String>] = [
            [
                "title" : "Hàn Quốc",
                "genre" : "korean-series",
            ],
            [
                "title" : "Trung Quốc",
                "genre" : "phim-bo-trung-quoc",
            ],
            [
                "title" : "Đài Loan",
                "genre" : "phim-bo-dai-loan",
            ],
            [
                "title" : "Mỹ",
                "genre" : "us-tv-series",
            ],
            [
                "title" : "Hồng Kông",
                "genre" : "hongkong-series",
            ],
            [
                "title" : "Ấn Độ",
                "genre" : "phim-bo-an-do",
            ],
            [
                "title" : "Thái Lan",
                "genre" : "phim-bo-thai-lan",
            ]
        ]
}
