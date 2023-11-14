require "google_drive"

session = GoogleDrive::Session.from_config("config.json")
spreadsheet = session.spreadsheet_by_key("1rwfAax11xRiqGEoKELU42pneJMoY-8fDmiIlVSXOcH8")
worksheet = spreadsheet.worksheets[0]
sheet = worksheet.rows

class Table
  include Enumerable

  def initialize(n)
    @sheet = n
  end

  def row(row)
    @sheet[row]
  end

  def sheet
    @sheet
  end

  def each
    @sheet.each do |row|
      row.each do |el|
        yield(el)
      end
    end
  end

  def [](col)
    idx = @sheet.first.index(col)
    raise "Column not found" unless idx

    Column.new(self, idx)
  end

class Column
    def initialize(table, idx)
      @te = table
      @col = idx
    end

    def [] row
      @te.sheet[row][@col]
    end

    def []=(row, value)
      @te.sheet[row, @col] = value
      @te.sheet.save
    end

  end
end


 table = Table.new(sheet)
# row_dva = table.row(1)
# p row_dva
# table.each {|k| p k}
p table["Prva Kolona"][1]
# table["Prva Kolona"][1]= 2556
