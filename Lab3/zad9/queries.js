db.tours.aggregate([
  { $match: { ratingsAverage: { $gte: 4.6 } } },
  {
    $group: {
      _id: null,
      noTours: { $sum: 1 },
      noRatings: { $sum: '$ratingsQuantity' },
      avgRating: { $avg: '$ratingsAverage' },
      avgPrice: { $avg: '$price' },
      minPrice: { $min: '$price' },
      maxPrice: { $max: '$price' },
    }
  }
]).pretty()

db.tours.aggregate([
  {
    $match: {
      startDates: {
        $gte: new Date('2022-07-01'),
        $lte: new Date('2022-08-31')
      }
    }
  },
  {
    $project: {
      name: 1,
      startDates: 1
    }
  }
]).pretty()

db.reviews.aggregate([
  {
    $group: {
      _id: "$user",
      count: { $sum: 1 }
    }
  },
  {
    $sort: { count: -1 }
  }
])

