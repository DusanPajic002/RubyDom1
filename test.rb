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
    Column.new(sheet, idx)
  end


  def method_missing(name, *args)
    str = name.to_s.downcase.gsub(/\s+/, "")
    @table[0].each_with_index do |n, idx|
      head = n.to_s.downcase.gsub(/\s+/, "")
      if str == head
        return Column.new(@sheet, idx)
      end
    end
    super
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

        def method_missing(name, *args, &block)
          niz = []
          self.each {|k| niz << k}
          niz.each_with_index do |n , row_idx|
            if name.to_s == n
              return @table[row_idx]
            end
          end
            super
        end

        def sum
          @table.map { |row| row[@idx].to_i }.reduce(0, :+)
        end

        def avg
          sum / (@table.size - 1)
        end
    end
end



table = Table.new(sheet)
#  p table.row(1)
#  table.each {|k| p k}
# p table["Prva Kolona"][2]
#  p table["Prva Kolona"].class
# table["Prva Kolona"][2]= 2556
#  table.index.each {|k| p k}
#  p table.prvaKolona.avg
# p table.index.rn10722
