class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

def self.all
	 sql = <<-SQL
	 SELECT *
	 FROM students
    SQL
  DB[:conn].execute(sql).map do |row|
  self.new_from_db(row)
	 end
	end

  def self.find_by_name(name)
   sql = <<-SQL 
   SELECT * FROM students WHERE name = ? 
   LIMIT 1
   SQL
    student_row = DB[:conn].execute(sql, name)[0]
    self.new_from_db(student_row)
  end
  
  def self.all_students_in_grade_9
  sql = "SELECT * FROM students WHERE grade = 9 LIMIT 1"
DB[:conn].execute(sql).collect do |row|
  self.new_from_db(row)
  end
end

 
   
   def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade < 12"
DB[:conn].execute(sql).collect do |row|
  self.new_from_db(row)
    end
  end	  

  
  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT ?
      SQL

      DB[:conn].execute(sql, num).map do |row|
        self.new_from_db(row)
      end
  end

  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT 1"
    first_student_row = DB[:conn].execute(sql)[0]
    self.new_from_db(first_student_row)
  end

  def self.all_students_in_grade_X(x)
    sql = "SELECT * FROM students WHERE grade = ?"
    DB[:conn].execute(sql, x)
    
  end
  
#   	1. class Song
# 	2. def self.find_by_name(name)
# 	3. sql = <<-SQL
# 	4. SELECT *
# 	5. FROM songs
# 	6. WHERE name = ?
# 	7. LIMIT 1
# 	8. SQL
# 	9.  
# 	10. DB[:conn].execute(sql, name).map do |row|
# 	11. self.new_from_db(row)
# 	12. end.first
# 	13. end
# 	14. end

  
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
