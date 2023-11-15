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
  def index
      p 12321321321
  end

  def method_missing(name, *args)
    column_name = name.to_s.gsub(/(.)([A-Z])/, '\1 \2').split.map(&:capitalize).join(' ')
    if @sheet.rows.first.include?(column_name)
      self[column_name]
    else
      super
    end
  end

  def index
    Indexer.new(@table)
  end


    class Indexer
      def initialize(data)
        @data = data
      end

      def method_missing(method_name, *arguments, &block)
        search_value = method_name.to_s # Pretvara ime metode u string
        @data.find { |row| row.any? { |cell| cell.to_s.include?(search_value) } }
      end
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
          @table.map { |row| row[@idx].to_i }.reduce(0, :+)
        end

        def avg
          sum / (@table.size - 1)
        end

    end
end



table = Table.new(sheet)
# p table.row(1)
#  table.each {|k| p k}
# p table["Prva Kolona"][2]
#  p table["Prva Kolona"].class
# table["Prva Kolona"][2]= 2556
#  table.drugaKolona.each {|k| p k}
# p table.prvaKolona.sum
p table.index.rn10222
