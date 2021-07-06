class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new
    student.id, student.name, student.grade = row;
    student
  end

  def self.all
    DB[:conn].execute("SELECT * FROM students").map { |student| self.new_from_db(student) }
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
    SQL
    
    self.new_from_db(DB[:conn].execute(sql, name)[0])
  end

  def self.all_students_in_grade_9
    DB[:conn].execute("SELECT * FROM students WHERE grade = 9").map{ |student| self.new_from_db(student) }
  end

  def self.students_below_12th_grade
    DB[:conn].execute("SELECT * FROM students WHERE grade < 12").map{ |student| self.new_from_db(student) }
  end

  def self.first_X_students_in_grade_10(num)
    DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT ?", num).map{ |student| self.new_from_db(student) }
  end

  def self.first_student_in_grade_10
    self.new_from_db(DB[:conn].execute("SELECT * FROM students WHERE grade = 10")[0])
  end

  def self.all_students_in_grade_X(num)
    DB[:conn].execute("SELECT * FROM students WHERE grade = ?", num).map{ |student| self.new_from_db(student) }
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
end
