require 'pry'

class Student
  attr_accessor :id, :name, :grade

  @@all_from_db = []

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new  # self.new is the same as running Song.new
    new_student.id = row[0]
    new_student.name =  row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    results = DB[:conn].execute("SELECT * FROM students")
    results.each do |result|
      @@all_from_db << self.new_from_db(result)
    end
    @@all_from_db
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    results = DB[:conn].execute("SELECT * FROM students WHERE students.name = ?", name)
    if results[0][1] == name
      self.new_from_db(results[0])
    end
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.count_all_students_in_grade_9
    results = DB[:conn].execute("SELECT * FROM students WHERE students.grade = 9")
    results
  end

  def self.students_below_12th_grade
    results = DB[:conn].execute("SELECT * FROM students WHERE students.grade < 12")
    results
  end

  def self.first_x_students_in_grade_10(students_x)
    results = DB[:conn].execute("SELECT * FROM students WHERE students.grade = 10 ORDER BY students.id LIMIT ?", students_x)
    results
  end

  def self.first_student_in_grade_10
    results = DB[:conn].execute("SELECT * FROM students WHERE students.grade = 10 LIMIT 1")
    self.new_from_db(results[0])
  end

  def self.all_students_in_grade_X(grade_x)
    results = DB[:conn].execute("SELECT * FROM students WHERE students.grade = ?", grade_x)
    results
  end

end
