// To add this student, use: db.insertOne(student1) after pasting the code below
student1 = {
  firstName: "Mateo",
  lastName: "Turner",
  sex: "m",
  email: "mateo@email.com",
  phone: "345345345",
  courses: [
    "Computer Science"
  ],
  subjects: {
    Databases: {
      grades: [5, 4.5, 5]
    },
    Java: {
      grades: [4, 3, 4.5]
    },
    Python: {
      grades: [5, 3.5, 4.5]
    },
  },
}

// To add this student, use: db.insertOne(student2) after pasting the code below
student2 = {
  firstName: "Lucious",
  lastName: "Fisher",
  sex: "m",
  email: "lucious@email.com",
  phone: "123454321",
  courses: [
    "Computer Science",
    "Ceramics"
  ],
  subjects: {
    ASD: {
      "grades": [3, 3, 2]
    },
    Kotlin: {
      "grades": [4, 3, 4.5]
    },
    JavaScript: {
      "grades": [4.5, 3.5, 5]
    },
    Pottery: {
      "grades": [5, 5, 5, 5, 5]
    }
  },
}

// To add these students, use: db.insertMany(students) after pasting the code below
students = [
  {
    firstName: "Eusebio",
    lastName: "Gorczany",
    sex: "m",
    email: "eusebio@email.com",
    phone: "111222111",
    courses: [
      "Robotics"
    ],
    subjects: {
      Programming: {
        grades: [3, 4, 5, 4.5]
      },
      Physics: {
        grades: [3, 3, 3, 4]
      },
      Algebra: {
        grades: [3, 4]
      },
    },
  },
  {
    firstName: "Gracie",
    lastName: "Reichert",
    sex: "f",
    email: "gracie@email.com",
    phone: "909890989",
    courses: [
      "Computer Science"
    ],
    subjects: {
      Databases: {
        grades: [4, 5, 4, 5]
      },
      Cpp: {
        grades: [5, 5, 5, 5]
      }
    },
  },
  {
    firstName: "Elaina",
    lastName: "Wyman",
    sex: "f",
    email: "elaina@email.com",
    phone: "794794794",
    courses: [
      "Geodesy"
    ],
    subjects: {
      SoilScience: {
        grades: [5]
      },
      Mining: {
        grades: [3, 3, 4, 5]
      }
    },
  }
]
