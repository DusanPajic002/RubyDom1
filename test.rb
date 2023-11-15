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

        def [](row)
          @sheet[row + 1, @idx + 1]
        end

        def []=(row, value)
          @sheet[row + 1, @idx + 1] = value
          @sheet.save
        end

        def map(&block)
          @table.each_with_index do |row, row_index|
            next if row_index.zero?

            cell_value = row[@idx]
            new_value = yield(cell_value)
            @sheet[row_index + 1, @idx + 1] = new_value
          end
          @sheet.save
        end

        def select
          sel = []
          @table.drop(1).each do |row|
            sel << row[@idx] if yield(row[@idx])
          end
          sel
        end

        def reduce(ini)
          acc = ini
          @tabela.drop(1).each do |row|
            acc = yield(acc, row[@idx])
          end
        end

        def each
          @table.each do |row|
            yield row[@idx]
          end
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
# p table.row(1)
p "--------------"
# table.each {|k| p k}
p "--------------"
# p table["Prva Kolona"][1]
p "--------------"
p table["Prva Kolona"].class
p "--------------"
table["Prva Kolona"][2]= 2556
p "--------------"
table.index.each {|k| p k}
p "--------------"
p table.prvaKolona.avg
p "--------------"
p table.index.rn10722
p "--------------"
# p table.prvaKolona.map { |cell| cell.to_i + 1 }
p "--------------"
# p table.prvaKolona[2]
p "--------------"
# p table.prvaKolona.select { |value| value.to_i > 10 }
