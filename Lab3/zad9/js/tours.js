db.tours.insertMany([
  {
    _id: new ObjectId("5c88fa8cf4afda39709c2955"),
    company: new ObjectId("6263e1123ca1655ba6a4dd8f"),
    name: "Mountains Hiking",
    duration: 4,
    maxGroupSize: 10,
    difficulty: "difficult",
    ratingsAverage: 4.83,
    ratingsQuantity: 6,
    price: 999,
    summary: "Extreme mountain climbing with magnificent views and loads of adrenaline",
    description: "Lorem ipsum dolor sit amet consectetur adipisicing elit. Dolorem qui dolore earum sed quo obcaecati enim unde tenetur, odio dolor dignissimos vitae labore et iste dolores nesciunt debitis aperiam assumenda aut voluptatem reprehenderit blanditiis libero? Veritatis, ullam. Dolorem facere nobis cupiditate, eveniet voluptatum voluptates minus libero iusto placeat, reiciendis odio!",
    createdAt: ISODate("2022-01-29T01:03:28.180Z"),
    startDates: [
      ISODate("2022-12-12T12:35:03.795Z"),
      ISODate("2022-12-28T05:52:32.724Z")
    ],
    locations: [
      {
        description: "Aspen Highlands",
        day: 1
      },
      {
        description: "Beaver Creek",
        day: 3
      }
    ],
    guides: [
      new ObjectId("5c8a22c62f8fb814b56fa18b"),
      new ObjectId("5c8a1f4e2f8fb814b56fa185")
    ]
  },

  {
    _id: new ObjectId("5c88fa8cf4afda39709c295a"),
    company: new ObjectId("6263e1123ca1655ba6a4dd90"),
    name: "Pleasurable Sunbathing",
    duration: 10,
    maxGroupSize: 30,
    difficulty: "easy",
    ratingsAverage: 4.5,
    ratingsQuantity: 6,
    price: 499,
    summary: "Have a rest in the sunlight",
    description: "Lorem ipsum dolor sit amet consectetur adipisicing elit. Dolorem qui dolore earum sed quo obcaecati enim unde tenetur, odio dolor dignissimos vitae labore et iste dolores nesciunt debitis aperiam assumenda aut voluptatem reprehenderit blanditiis libero? Veritatis, ullam. Dolorem facere nobis cupiditate, eveniet voluptatum voluptates minus libero iusto placeat, reiciendis odio!",
    createdAt: ISODate("2022-02-24T01:03:28.180Z"),
    startDates: [
      ISODate("2022-06-11T12:35:03.795Z"),
      ISODate("2022-07-21T05:52:32.724Z")
    ],
    locations: [
      {
        description: "Lummus Park Beach",
        day: 1
      },
      {
        description: "Islamorada",
        day: 2
      },
      {
        description: "Sombrero Beach",
        day: 3
      },
      {
        description: "West Key",
        day: 5
      }
    ],
    guides: [
      new ObjectId("5c8a21d02f8fb814b56fa189")
    ]
  },

  {
    _id: new ObjectId("5c88fa8cf4afda39709c295d"),
    company: new ObjectId("6263e1123ca1655ba6a4dd8f"),
    name: "Under the sea",
    duration: 3,
    maxGroupSize: 8,
    difficulty: "medium",
    ratingsAverage: 4.6,
    ratingsQuantity: 5,
    price: 1499,
    summary: "An underwater adventure full of attractions such as swimming in the azure water between a coral reef and marine life",
    description: "Lorem ipsum dolor sit amet consectetur adipisicing elit. Dolorem qui dolore earum sed quo obcaecati enim unde tenetur, odio dolor dignissimos vitae labore et iste dolores nesciunt debitis aperiam assumenda aut voluptatem reprehenderit blanditiis libero? Veritatis, ullam. Dolorem facere nobis cupiditate, eveniet voluptatum voluptates minus libero iusto placeat, reiciendis odio!",
    createdAt: ISODate("2022-03-11T11:03:28.180Z"),
    startDates: [
      ISODate("2022-05-14T12:35:03.795Z"),
      ISODate("2022-07-18T05:52:32.724Z")
    ],
    locations: [
      {
        description: "Islamorada",
        day: 2
      },
      {
        description: "Sombrero Beach",
        day: 3
      }
    ],
    guides: [
      new ObjectId("5c8a21d02f8fb814b56fa189"),
      new ObjectId("5c8a23412f8fb814b56fa18c")
    ]
  }
])
