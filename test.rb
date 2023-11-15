require "google_drive"

session = GoogleDrive::Session.from_config("config.json")
spreadsheet = session.spreadsheet_by_key("1rwfAax11xRiqGEoKELU42pneJMoY-8fDmiIlVSXOcH8")
sheet = spreadsheet.worksheets[0]

class Table
  include Enumerable
  attr_reader :sheet
  attr_reader :table

  def initialize(sheet)
    @sheet = sheet
    @table = sheet.rows
  end

  def row(row)
    @table[row]
  end

  def each()
    @table.each do |row|
      row.each do |n|
        yield n
      end
    end
  end

  def [](name)
    idx = @sheet.rows[0].index(name)
    raise "Column not found" unless idx

    Column.new(sheet, idx + 1)
  end

  def method_missing(method_name, *arguments, &block)
    column_name = method_name.to_s.split('_').collect(&:capitalize).join(' ')
    if @sheet.rows[0].include?(column_name)
      define_singleton_method(method_name) do
        Column.new(@sheet, @sheet.rows[0].index(column_name))
      end
      send(method_name)
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    @sheet.rows[0].map { |header| header.downcase.gsub(' ', '_') }.include?(method_name.to_s) || super
  end

    class Column

        def initialize(sheet, idx)
          @sheet = sheet
          @table = sheet.rows
          @idx = idx
        end

        def each
          @table.each do |row|
            yield row[@idx]
          end
        end

        def [](row)
          @sheet[row, @idx]
        end

        def []=(row, value)
          @sheet[row, @idx] = value
          @sheet.save
        end

        def sum
          @table[1..-1].inject(0) { |sum, row| sum + row[@idx].to_f }
        end

        def avg
          sum.to_f / (@table.size - 1)
        end

        def method_missing(method_name, *arguments, &block)
          if method_name.to_s.start_with?('rn')
            student_id = method_name[2..-1]
            @table[1..-1].find { |row| row[@idx] == student_id }
          else
            super
          end
        end

    end
end



table = Table.new(sheet)
# p table.row(1)
# table.each {|k| p k}
# p table["Prva Kolona"][2]
# p table["Prva Kolona"].class
# table["Prva Kolona"][2]= 2556
# p table["Prva Kolona"][2]
table.druga_kolona.each {|k| p k}
