db.companies.insertMany([
  {
    _id: new ObjectId("6263e1123ca1655ba6a4dd8f"),
    name: "Travellio",
    tours: [
      new ObjectId("5c88fa8cf4afda39709c2955"),
      new ObjectId("5c88fa8cf4afda39709c295d")
    ]
  },
  {
    _id: new ObjectId("6263e1123ca1655ba6a4dd90"),
    name: "Dream holiday",
    tours: [
      new ObjectId("5c88fa8cf4afda39709c295a")
    ]
  }
])
